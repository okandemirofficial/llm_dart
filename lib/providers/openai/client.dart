import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../core/llm_error.dart';
import '../../models/chat_models.dart';
import '../../utils/config_utils.dart';
import '../../utils/utf8_stream_decoder.dart';
import 'config.dart';

/// Core OpenAI HTTP client shared across all capability modules
///
/// This class provides the foundational HTTP functionality that all
/// OpenAI capability implementations can use. It handles:
/// - Authentication and headers
/// - Request/response processing
/// - Error handling
/// - SSE stream parsing
/// - Provider-specific configurations
class OpenAIClient {
  final OpenAIConfig config;
  final Logger logger = Logger('OpenAIClient');
  late final Dio dio;

  OpenAIClient(this.config, {Dio? customDio}) {
    if (customDio != null) {
      dio = customDio;
      // Update the base options if they're not already set
      if (dio.options.baseUrl.isEmpty) {
        dio.options.baseUrl = config.baseUrl;
      }
      // Merge headers instead of replacing them
      final headers = ConfigUtils.buildOpenAIHeaders(config.apiKey);
      dio.options.headers.addAll(headers);
      // Set timeouts if not already configured
      dio.options.connectTimeout ??= config.timeout;
      dio.options.receiveTimeout ??= config.timeout;
      dio.options.sendTimeout ??= config.timeout;
    } else {
      dio = Dio(BaseOptions(
        baseUrl: config.baseUrl,
        headers: ConfigUtils.buildOpenAIHeaders(config.apiKey),
        connectTimeout: config.timeout,
        receiveTimeout: config.timeout,
        sendTimeout: config.timeout,
      ));
    }
  }

  /// Get provider ID based on base URL for provider-specific behavior
  String get providerId {
    final baseUrl = config.baseUrl.toLowerCase();

    if (baseUrl.contains('openrouter')) {
      return 'openrouter';
    } else if (baseUrl.contains('groq')) {
      return 'groq';
    } else if (baseUrl.contains('deepseek')) {
      return 'deepseek';
    } else if (baseUrl.contains('azure')) {
      return 'azure-openai';
    } else if (baseUrl.contains('copilot') || baseUrl.contains('github')) {
      return 'copilot';
    } else if (baseUrl.contains('together')) {
      return 'together';
    } else if (baseUrl.contains('openai')) {
      return 'openai';
    } else {
      return 'openai'; // Default fallback for OpenAI-compatible APIs
    }
  }

  /// Parse a Server-Sent Events (SSE) chunk from OpenAI's streaming API
  ///
  /// Returns:
  /// - `Map<String, dynamic>` - Parsed JSON data if found
  /// - `null` - If chunk should be skipped (e.g., ping, done signal)
  ///
  /// Throws:
  /// - `ResponseFormatError` - If critical parsing errors occur
  Map<String, dynamic>? parseSSEChunk(String chunk) {
    for (final line in chunk.split('\n')) {
      final trimmedLine = line.trim();

      if (trimmedLine.startsWith('data: ')) {
        final data = trimmedLine.substring(6).trim();

        // Handle completion signal
        if (data == '[DONE]') {
          return null;
        }

        // Skip empty data
        if (data.isEmpty) {
          continue;
        }

        try {
          final json = jsonDecode(data);
          if (json is! Map<String, dynamic>) {
            logger.warning('SSE chunk is not a JSON object: $data');
            continue;
          }

          // Check for error in the SSE data
          if (json.containsKey('error')) {
            final error = json['error'] as Map<String, dynamic>?;
            if (error != null) {
              final message = error['message'] as String? ?? 'Unknown error';
              final type = error['type'] as String?;
              final code = error['code'] as String?;

              throw ResponseFormatError(
                'SSE stream error: $message${type != null ? ' (type: $type)' : ''}${code != null ? ' (code: $code)' : ''}',
                data,
              );
            }
          }

          return json;
        } catch (e) {
          if (e is LLMError) rethrow;

          // Log and skip malformed JSON chunks, but don't fail the entire stream
          logger.warning('Failed to parse SSE chunk JSON: $e, data: $data');
          continue;
        }
      }
    }

    return null;
  }

  /// Convert ChatMessage to OpenAI API format
  Map<String, dynamic> convertMessage(ChatMessage message) {
    final result = <String, dynamic>{'role': message.role.name};

    // Add name field if present (useful for system messages)
    if (message.name != null) {
      result['name'] = message.name;
    }

    switch (message.messageType) {
      case TextMessage():
        result['content'] = message.content;
        break;
      case ImageMessage(mime: final mime, data: final data):
        // Handle base64 encoded images
        final base64Data = base64Encode(data);
        result['content'] = [
          {
            'type': 'image_url',
            'image_url': {'url': 'data:${mime.mimeType};base64,$base64Data'},
          },
        ];
        break;
      case ImageUrlMessage(url: final url):
        result['content'] = [
          {
            'type': 'image_url',
            'image_url': {'url': url},
          },
        ];
        break;
      case ToolUseMessage(toolCalls: final toolCalls):
        result['tool_calls'] = toolCalls.map((tc) => tc.toJson()).toList();
        break;
      case ToolResultMessage(results: final results):
        // Tool results need to be converted to separate tool messages
        // This case should not happen in normal message conversion
        // as tool results are handled separately in buildRequestBody
        result['content'] =
            message.content.isNotEmpty ? message.content : 'Tool result';
        result['tool_call_id'] = results.isNotEmpty ? results.first.id : null;
        break;
      default:
        result['content'] = message.content;
    }

    return result;
  }

  /// Build API messages array from ChatMessage list
  ///
  /// Note: System prompt should be added by the calling module if needed,
  /// not here to avoid duplication.
  List<Map<String, dynamic>> buildApiMessages(List<ChatMessage> messages) {
    final apiMessages = <Map<String, dynamic>>[];

    // Convert messages to OpenAI format
    for (final message in messages) {
      if (message.messageType is ToolResultMessage) {
        // Handle tool results as separate messages
        final toolResults = (message.messageType as ToolResultMessage).results;
        for (final result in toolResults) {
          apiMessages.add({
            'role': 'tool',
            'tool_call_id': result.id,
            'content': result.function.arguments.isNotEmpty
                ? result.function.arguments
                : message.content,
          });
        }
      } else {
        apiMessages.add(convertMessage(message));
      }
    }

    return apiMessages;
  }

  /// Make a POST request with JSON body
  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing OpenAI API key');
    }

    try {
      // Optimized logging with condition check
      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI request: POST /$endpoint');
        logger.fine('OpenAI request headers: ${dio.options.headers}');
      }

      final response = await dio.post(endpoint, data: body);

      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI HTTP status: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        _handleErrorResponse(response, endpoint);
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Make a POST request with form data
  Future<Map<String, dynamic>> postForm(
    String endpoint,
    FormData formData,
  ) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing OpenAI API key');
    }

    try {
      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI request: POST /$endpoint (form)');
        logger.fine('OpenAI request headers: ${dio.options.headers}');
      }

      final response = await dio.post(endpoint, data: formData);

      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI HTTP status: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        _handleErrorResponse(response, endpoint);
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Make a POST request and return raw bytes
  Future<List<int>> postRaw(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing OpenAI API key');
    }

    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        _handleErrorResponse(response, endpoint);
      }

      return response.data as List<int>;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Make a GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing OpenAI API key');
    }

    try {
      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI request: GET /$endpoint');
        logger.fine('OpenAI request headers: ${dio.options.headers}');
      }

      final response = await dio.get(endpoint);

      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI HTTP status: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        _handleErrorResponse(response, endpoint);
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Make a GET request and return raw bytes
  Future<List<int>> getRaw(String endpoint) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing OpenAI API key');
    }

    try {
      final response = await dio.get(
        endpoint,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        _handleErrorResponse(response, endpoint);
      }

      return response.data as List<int>;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing OpenAI API key');
    }

    try {
      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI request: DELETE /$endpoint');
        logger.fine('OpenAI request headers: ${dio.options.headers}');
      }

      final response = await dio.delete(endpoint);

      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI HTTP status: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        _handleErrorResponse(response, endpoint);
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Make a POST request and return SSE stream
  Stream<String> postStreamRaw(
    String endpoint,
    Map<String, dynamic> body,
  ) async* {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing OpenAI API key');
    }

    try {
      if (logger.isLoggable(Level.FINE)) {
        logger.fine('OpenAI request: POST /$endpoint (stream)');
        logger.fine('OpenAI request headers: ${dio.options.headers}');
      }

      final response = await dio.post(
        endpoint,
        data: body,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );

      if (response.statusCode != 200) {
        _handleErrorResponse(response, endpoint);
      }

      // Handle ResponseBody properly for streaming
      final responseBody = response.data;
      Stream<List<int>> stream;

      if (responseBody is Stream<List<int>>) {
        stream = responseBody;
      } else if (responseBody is ResponseBody) {
        stream = responseBody.stream;
      } else {
        throw GenericError(
            'Unexpected response type: ${responseBody.runtimeType}');
      }

      // Use UTF-8 stream decoder to handle incomplete byte sequences
      final decoder = Utf8StreamDecoder();

      await for (final chunk in stream) {
        final decoded = decoder.decode(chunk);
        if (decoded.isNotEmpty) {
          yield decoded;
        }
      }

      // Flush any remaining bytes
      final remaining = decoder.flush();
      if (remaining.isNotEmpty) {
        yield remaining;
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Handle Dio errors and convert them to appropriate LLM errors
  LLMError handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutError('Request timeout: ${e.message}');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (statusCode != null) {
          // Use HttpErrorMapper for consistent error handling
          final errorMessage =
              _extractErrorMessage(responseData) ?? '$statusCode';
          final responseMap =
              responseData is Map<String, dynamic> ? responseData : null;

          return HttpErrorMapper.mapStatusCode(
              statusCode, errorMessage, responseMap);
        } else {
          return ResponseFormatError(
            'HTTP error without status code',
            responseData?.toString() ?? '',
          );
        }
      case DioExceptionType.cancel:
        return const GenericError('Request cancelled');
      case DioExceptionType.connectionError:
        return const GenericError('Connection error');
      case DioExceptionType.badCertificate:
        return const GenericError('SSL certificate error');
      case DioExceptionType.unknown:
        return GenericError('Unknown error: ${e.message}');
    }
  }

  /// Extract error message from OpenAI API response
  String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // OpenAI error format: {"error": {"message": "...", "type": "...", "code": "..."}}
      final error = responseData['error'] as Map<String, dynamic>?;
      if (error != null) {
        final message = error['message'] as String?;
        final type = error['type'] as String?;
        final code = error['code'] as String?;

        if (message != null) {
          final parts = <String>[message];
          if (type != null) parts.add('type: $type');
          if (code != null) parts.add('code: $code');
          return parts.join(', ');
        }
      }

      // Fallback: look for direct message field
      final directMessage = responseData['message'] as String?;
      if (directMessage != null) return directMessage;
    }

    return null;
  }

  /// Handle error responses with specific error types
  void _handleErrorResponse(Response response, String endpoint) {
    final statusCode = response.statusCode;
    final errorData = response.data;

    if (statusCode != null) {
      final errorMessage = _extractErrorMessage(errorData) ??
          'OpenAI $endpoint API returned error status: $statusCode';
      final responseMap = errorData is Map<String, dynamic> ? errorData : null;

      throw HttpErrorMapper.mapStatusCode(
          statusCode, errorMessage, responseMap);
    } else {
      throw ResponseFormatError(
        'OpenAI $endpoint API returned unknown error',
        errorData?.toString() ?? '',
      );
    }
  }
}
