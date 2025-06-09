import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../core/llm_error.dart';
import '../../models/chat_models.dart';
import '../../utils/config_utils.dart';
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

  OpenAIClient(this.config) {
    dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      headers: ConfigUtils.buildOpenAIHeaders(config.apiKey),
      connectTimeout: config.timeout,
      receiveTimeout: config.timeout,
      sendTimeout: config.timeout,
    ));
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
          final json = jsonDecode(data) as Map<String, dynamic>;
          return json;
        } catch (e) {
          // Skip malformed JSON chunks
          logger.warning('Failed to parse SSE chunk JSON: $e');
          continue;
        }
      }
    }

    return null;
  }

  /// Convert ChatMessage to OpenAI API format
  Map<String, dynamic> convertMessage(ChatMessage message) {
    final result = <String, dynamic>{'role': message.role.name};

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
  List<Map<String, dynamic>> buildApiMessages(List<ChatMessage> messages) {
    final apiMessages = <Map<String, dynamic>>[];

    // Add system message if configured
    if (config.systemPrompt != null) {
      apiMessages.add({'role': 'system', 'content': config.systemPrompt});
    }

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

      final stream = response.data as Stream<List<int>>;
      await for (final chunk in stream) {
        final chunkString = String.fromCharCodes(chunk);
        yield chunkString;
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
        return const GenericError('Request timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const AuthError('Invalid API key');
        } else if (statusCode == 429) {
          return const ProviderError('Rate limit exceeded');
        } else {
          return ResponseFormatError(
            'HTTP error: $statusCode',
            e.response?.data?.toString() ?? '',
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

  /// Handle error responses with specific error types
  void _handleErrorResponse(Response response, String endpoint) {
    final statusCode = response.statusCode;
    final errorData = response.data;

    if (statusCode == 401) {
      throw AuthError('Invalid OpenAI API key for $endpoint');
    } else if (statusCode == 429) {
      throw ProviderError('Rate limit exceeded for $endpoint');
    } else {
      throw ResponseFormatError(
        'OpenAI $endpoint API returned error status: $statusCode',
        errorData?.toString() ?? '',
      );
    }
  }
}
