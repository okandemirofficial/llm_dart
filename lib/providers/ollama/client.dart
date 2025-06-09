import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'config.dart';

/// Core Ollama HTTP client shared across all capability modules
///
/// This class provides the foundational HTTP functionality that all
/// Ollama capability implementations can use. It handles:
/// - Authentication (optional API key)
/// - Request/response processing
/// - Error handling
/// - JSON streaming (Ollama's streaming format)
/// - Provider-specific configurations
class OllamaClient {
  final OllamaConfig config;
  final Logger logger = Logger('OllamaClient');
  late final Dio dio;

  OllamaClient(this.config) {
    dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      headers: _buildHeaders(),
      connectTimeout: config.timeout,
      receiveTimeout: config.timeout,
      sendTimeout: config.timeout,
    ));
  }

  /// Build headers for Ollama API requests
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (config.apiKey != null) {
      headers['Authorization'] = 'Bearer ${config.apiKey}';
    }
    return headers;
  }

  /// Make a POST request and return JSON response
  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      logger.fine('Ollama request payload: ${jsonEncode(data)}');
      final response = await dio.post(endpoint, data: data);
      
      logger.fine('Ollama HTTP status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Ollama API returned status ${response.statusCode}',
        );
      }
      
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.severe('HTTP request failed: ${e.message}');
      rethrow;
    }
  }

  /// Make a GET request and return JSON response
  Future<Map<String, dynamic>> getJson(String endpoint) async {
    try {
      logger.fine('Ollama request: GET $endpoint');
      final response = await dio.get(endpoint);
      
      logger.fine('Ollama HTTP status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Ollama API returned status ${response.statusCode}',
        );
      }
      
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.severe('HTTP request failed: ${e.message}');
      rethrow;
    }
  }

  /// Make a POST request and return raw stream for JSON streaming
  Stream<String> postStreamRaw(
    String endpoint,
    Map<String, dynamic> data,
  ) async* {
    try {
      logger.fine('Ollama streaming request payload: ${jsonEncode(data)}');
      
      final response = await dio.post(
        endpoint,
        data: data,
        options: Options(responseType: ResponseType.stream),
      );

      logger.fine('Ollama streaming HTTP status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Ollama API returned status ${response.statusCode}',
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
        throw Exception('Unexpected response type: ${responseBody.runtimeType}');
      }

      await for (final chunk in stream) {
        final chunkString = utf8.decode(chunk);
        yield chunkString;
      }
    } on DioException catch (e) {
      logger.severe('Stream request failed: ${e.message}');
      rethrow;
    }
  }
}
