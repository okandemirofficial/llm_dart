import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../core/llm_error.dart';
import '../../utils/config_utils.dart';
import 'config.dart';

/// ElevenLabs HTTP client implementation
///
/// This module handles all HTTP communication with the ElevenLabs API.
/// ElevenLabs provides text-to-speech and speech-to-text services.
class ElevenLabsClient {
  static final Logger _logger = Logger('ElevenLabsClient');

  final ElevenLabsConfig config;
  late final Dio _dio;

  ElevenLabsClient(this.config, {Dio? customDio}) {
    if (customDio != null) {
      _dio = customDio;
      // Update the base options if they're not already set
      if (_dio.options.baseUrl.isEmpty) {
        _dio.options.baseUrl = config.baseUrl;
      }
      // Merge ElevenLabs-specific headers
      final headers = ConfigUtils.buildElevenLabsHeaders(config.apiKey);
      _dio.options.headers.addAll(headers);
      // Set timeouts if not already configured
      _dio.options.connectTimeout ??=
          config.timeout ?? const Duration(seconds: 60);
      _dio.options.receiveTimeout ??=
          config.timeout ?? const Duration(seconds: 60);
      _dio.options.sendTimeout ??=
          config.timeout ?? const Duration(seconds: 60);
    } else {
      _dio = Dio(BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.timeout ?? const Duration(seconds: 60),
        receiveTimeout: config.timeout ?? const Duration(seconds: 60),
        sendTimeout: config.timeout ?? const Duration(seconds: 60),
        headers: ConfigUtils.buildElevenLabsHeaders(config.apiKey),
      ));
    }
  }

  /// Logger instance for debugging
  Logger get logger => _logger;

  /// Make a GET request and return JSON response
  Future<Map<String, dynamic>> getJson(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);

      if (response.statusCode != 200) {
        throw ProviderError(
          'ElevenLabs API returned status ${response.statusCode}: ${response.data}',
        );
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e, 'ElevenLabs');
    }
  }

  /// Make a GET request and return list response
  Future<List<dynamic>> getList(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);

      if (response.statusCode != 200) {
        throw ProviderError(
          'ElevenLabs API returned status ${response.statusCode}: ${response.data}',
        );
      }

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e, 'ElevenLabs');
    }
  }

  /// Make a POST request and return binary response (for TTS)
  Future<Uint8List> postBinary(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        throw ProviderError(
          'ElevenLabs API returned status ${response.statusCode}',
        );
      }

      return Uint8List.fromList(response.data as List<int>);
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e, 'ElevenLabs');
    }
  }

  /// Make a POST request with form data and return JSON response (for STT)
  Future<Map<String, dynamic>> postFormData(
    String endpoint,
    FormData formData, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParams,
        options: Options(headers: {'xi-api-key': config.apiKey}),
      );

      if (response.statusCode != 200) {
        throw ProviderError(
          'ElevenLabs STT API returned status ${response.statusCode}',
        );
      }

      // Handle both JSON and string responses like original implementation
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        return responseData;
      } else if (responseData is String) {
        // Try to parse as JSON if it's a string
        try {
          final Map<String, dynamic> parsed = {};
          // For simple text responses, wrap in a text field
          parsed['text'] = responseData;
          return parsed;
        } catch (e) {
          throw ResponseFormatError(
            'Failed to parse ElevenLabs STT response: $e',
            responseData,
          );
        }
      } else {
        return responseData as Map<String, dynamic>;
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handleDioError(e, 'ElevenLabs');
    } catch (e) {
      if (e is LLMError) rethrow;
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Get response headers from last request
  String? getContentType(Response response) {
    return response.headers.value('content-type');
  }
}
