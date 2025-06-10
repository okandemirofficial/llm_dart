import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../core/llm_error.dart';
import 'config.dart';

/// Phind HTTP client implementation
///
/// This module handles all HTTP communication with the Phind API.
/// Phind has a unique API format that requires special handling.
class PhindClient {
  static final Logger _logger = Logger('PhindClient');

  final PhindConfig config;
  final Dio _dio;

  PhindClient(this.config) : _dio = _createDio(config);

  /// Logger instance for debugging
  Logger get logger => _logger;

  /// Make a POST request and return JSON response
  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      if (_logger.isLoggable(Level.FINE)) {
        _logger.fine('Phind request payload: ${jsonEncode(data)}');
      }

      final response = await _dio.post(endpoint, data: data);

      _logger.info('Phind HTTP status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ProviderError(
          'Phind API returned status ${response.statusCode}: ${response.data}',
        );
      }

      // Phind returns streaming response even for non-streaming requests
      final responseText = response.data as String;
      final content = _parsePhindStreamResponse(responseText);

      if (content.isEmpty) {
        throw const ProviderError('No completion choice returned.');
      }

      // Return a mock JSON response with the parsed content
      return {
        'choices': [
          {
            'message': {'content': content}
          }
        ]
      };
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e, 'Phind');
    }
  }

  /// Make a POST request and return raw stream
  Stream<String> postStreamRaw(
    String endpoint,
    Map<String, dynamic> data,
  ) async* {
    try {
      if (_logger.isLoggable(Level.FINE)) {
        _logger.fine('Phind stream request payload: ${jsonEncode(data)}');
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(responseType: ResponseType.stream),
      );

      _logger.info('Phind stream HTTP status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ProviderError(
          'Phind API returned status ${response.statusCode}',
        );
      }

      final stream = response.data as ResponseBody;
      await for (final chunk in stream.stream.map(utf8.decode)) {
        yield chunk;
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e, 'Phind');
    }
  }

  /// Create configured Dio instance for Phind API
  static Dio _createDio(PhindConfig config) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.timeout ?? const Duration(seconds: 60),
        receiveTimeout: config.timeout ?? const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': '', // Phind requires empty User-Agent
          'Accept': '*/*',
          'Accept-Encoding': 'Identity',
        },
      ),
    );

    return dio;
  }

  /// Parse the complete Phind streaming response into a single string
  String _parsePhindStreamResponse(String responseText) {
    return responseText
        .split('\n')
        .map(_parsePhindLine)
        .where((content) => content != null)
        .join();
  }

  /// Parse a single line from the Phind streaming response
  String? _parsePhindLine(String line) {
    if (!line.startsWith('data: ')) return null;

    final data = line.substring(6);
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      return json['choices']?.first?['delta']?['content'] as String?;
    } catch (e) {
      return null;
    }
  }
}
