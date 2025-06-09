import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../utils/config_utils.dart';
import 'config.dart';

/// Core Anthropic HTTP client shared across all capability modules
///
/// This class provides the foundational HTTP functionality that all
/// Anthropic capability implementations can use. It handles:
/// - Authentication and headers
/// - Request/response processing
/// - Error handling
/// - SSE stream parsing
/// - Provider-specific configurations
class AnthropicClient {
  final AnthropicConfig config;
  final Logger logger = Logger('AnthropicClient');
  late final Dio dio;

  AnthropicClient(this.config) {
    dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      headers: _buildHeaders(),
      connectTimeout: config.timeout,
      receiveTimeout: config.timeout,
      sendTimeout: config.timeout,
    ));
  }

  /// Build headers for Anthropic API requests
  Map<String, String> _buildHeaders() {
    final headers = ConfigUtils.buildAnthropicHeaders(config.apiKey);

    // Add beta headers for new features
    final betaFeatures = <String>[];

    // Always add output-128k support for thinking and extended features
    betaFeatures.add('output-128k-2025-02-19');

    // Add interleaved thinking if enabled
    if (config.interleavedThinking) {
      betaFeatures.add('interleaved-thinking-2025-05-14');
    }

    if (betaFeatures.isNotEmpty) {
      headers['anthropic-beta'] = betaFeatures.join(',');
    }

    return headers;
  }

  /// Make a POST request and return JSON response
  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.severe('HTTP request failed: ${e.message}');
      rethrow;
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
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
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

      await for (final chunk in stream) {
        final chunkString = String.fromCharCodes(chunk);
        yield chunkString;
      }
    } on DioException catch (e) {
      logger.severe('Stream request failed: ${e.message}');
      rethrow;
    }
  }
}
