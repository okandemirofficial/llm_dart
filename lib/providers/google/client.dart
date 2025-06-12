import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../utils/utf8_stream_decoder.dart';
import 'config.dart';

/// Core Google HTTP client shared across all capability modules
///
/// This class provides the foundational HTTP functionality that all
/// Google capability implementations can use. It handles:
/// - Authentication via API key query parameter
/// - Request/response processing
/// - Error handling
/// - JSON array stream parsing (Google's streaming format)
/// - Provider-specific configurations
class GoogleClient {
  final GoogleConfig config;
  final Logger logger = Logger('GoogleClient');
  late final Dio dio;

  GoogleClient(this.config) {
    // Use custom Dio client if provided, otherwise create default one
    if (config.dioClient != null) {
      dio = config.dioClient!;
      // Update base options with Google-specific settings
      dio.options = dio.options.copyWith(
        baseUrl: config.baseUrl,
        headers: {
          ...dio.options.headers,
          'Content-Type': 'application/json',
        },
        connectTimeout: config.timeout ?? dio.options.connectTimeout,
        receiveTimeout: config.timeout ?? dio.options.receiveTimeout,
        sendTimeout: config.timeout ?? dio.options.sendTimeout,
      );
    } else {
      dio = Dio(BaseOptions(
        baseUrl: config.baseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: config.timeout,
        receiveTimeout: config.timeout,
        sendTimeout: config.timeout,
      ));
    }
  }

  /// Get endpoint with API key authentication
  String _getEndpointWithAuth(String endpoint) {
    // Google uses query parameter authentication
    final separator = endpoint.contains('?') ? '&' : '?';
    return '$endpoint${separator}key=${config.apiKey}';
  }

  /// Make a POST request and return JSON response
  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final fullEndpoint = _getEndpointWithAuth(endpoint);
      final response = await dio.post(fullEndpoint, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.severe('HTTP request failed: ${e.message}');
      rethrow;
    }
  }

  /// Make a POST request and return raw stream for JSON array streaming
  Stream<String> postStreamRaw(
    String endpoint,
    Map<String, dynamic> data,
  ) async* {
    try {
      final fullEndpoint = _getEndpointWithAuth(endpoint);
      final response = await dio.post(
        fullEndpoint,
        data: data,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'application/json'},
        ),
      );

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
      logger.severe('Stream request failed: ${e.message}');
      rethrow;
    }
  }
}
