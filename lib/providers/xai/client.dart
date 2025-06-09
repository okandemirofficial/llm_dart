import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../core/llm_error.dart';
import 'config.dart';

/// Core xAI HTTP client shared across all capability modules
///
/// This class provides the foundational HTTP functionality that all
/// xAI capability implementations can use. It handles:
/// - Authentication and headers (OpenAI-compatible)
/// - Request/response processing
/// - Error handling
/// - SSE stream parsing
/// - Provider-specific configurations
class XAIClient {
  final XAIConfig config;
  final Logger logger = Logger('XAIClient');
  late final Dio dio;

  XAIClient(this.config) {
    dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      headers: _buildXAIHeaders(config.apiKey),
      connectTimeout: config.timeout,
      receiveTimeout: config.timeout,
      sendTimeout: config.timeout,
    ));
  }

  /// Build xAI-specific HTTP headers
  static Map<String, String> _buildXAIHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'User-Agent': 'llm_dart/xai',
    };
  }

  /// Make a POST request and return JSON response
  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      // Debug logging for request payload
      logger.finest('xAI request payload: ${jsonEncode(data)}');

      final response = await dio.post(endpoint, data: data);

      logger.fine('xAI HTTP status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'xAI API returned status ${response.statusCode}',
        );
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.severe('HTTP request failed: ${e.message}');
      throw _handleDioError(e);
    }
  }

  /// Make a POST request and return raw stream for SSE
  Stream<String> postStreamRaw(
    String endpoint,
    Map<String, dynamic> data,
  ) async* {
    try {
      final response = await dio.post(
        endpoint,
        data: data,
        options: Options(responseType: ResponseType.stream),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'xAI API returned status ${response.statusCode}',
        );
      }

      // Handle ResponseBody properly for streaming
      final responseBody = response.data;
      Stream<List<int>> stream;

      if (responseBody is Stream<List<int>>) {
        stream = responseBody;
      } else if (responseBody is ResponseBody) {
        stream = responseBody.stream;
      } else {
        throw Exception(
            'Unexpected response type: ${responseBody.runtimeType}');
      }

      await for (final chunk in stream) {
        final chunkString = utf8.decode(chunk);
        yield chunkString;
      }
    } on DioException catch (e) {
      logger.severe('Stream request failed: ${e.message}');
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to appropriate LLMError types
  LLMError _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return HttpError('Request timeout: ${e.message}');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (statusCode == 401) {
          return const AuthError('Invalid API key');
        } else if (statusCode == 429) {
          return const ProviderError('Rate limit exceeded');
        } else {
          return ProviderError('HTTP $statusCode: $data');
        }
      case DioExceptionType.cancel:
        return const GenericError('Request was cancelled');
      case DioExceptionType.connectionError:
        return HttpError('Connection error: ${e.message}');
      default:
        return HttpError('Network error: ${e.message}');
    }
  }
}
