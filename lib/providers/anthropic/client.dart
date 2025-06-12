import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../utils/config_utils.dart';
import '../../utils/utf8_stream_decoder.dart';
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
///
/// **API Documentation:**
/// - API Overview: https://docs.anthropic.com/en/api/overview
/// - Authentication: https://docs.anthropic.com/en/api/overview#authentication
/// - Versioning: https://docs.anthropic.com/en/api/versioning
/// - Beta Features: https://docs.anthropic.com/en/api/overview#beta-features
class AnthropicClient {
  final AnthropicConfig config;
  final Logger logger = Logger('AnthropicClient');
  late final Dio dio;

  AnthropicClient(this.config, {Dio? customDio}) {
    if (customDio != null) {
      dio = customDio;
      // Update the base options if they're not already set
      if (dio.options.baseUrl.isEmpty) {
        dio.options.baseUrl = config.baseUrl;
      }
      // Merge headers instead of replacing them
      final headers = _buildHeaders();
      dio.options.headers.addAll(headers);
      // Set timeouts if not already configured
      dio.options.connectTimeout ??= config.timeout;
      dio.options.receiveTimeout ??= config.timeout;
      dio.options.sendTimeout ??= config.timeout;
    } else {
      dio = Dio(BaseOptions(
        baseUrl: config.baseUrl,
        headers: _buildHeaders(),
        connectTimeout: config.timeout,
        receiveTimeout: config.timeout,
        sendTimeout: config.timeout,
      ));
    }

    // Add request interceptor to set endpoint-specific headers
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Update headers based on endpoint
        final endpoint = options.path;
        final headers = _buildHeaders(endpoint: endpoint);
        options.headers.addAll(headers);
        handler.next(options);
      },
    ));
  }

  /// Build headers for Anthropic API requests
  Map<String, String> _buildHeaders({String? endpoint}) {
    final headers = ConfigUtils.buildAnthropicHeaders(config.apiKey);

    // Add beta headers for new features
    final betaFeatures = <String>[];

    // Note: Extended thinking is now generally available and doesn't require a beta header

    // Add interleaved thinking if enabled (Claude 4 only)
    if (config.interleavedThinking && config.supportsInterleavedThinking) {
      betaFeatures.add('interleaved-thinking-2025-05-14');
    }

    // Add files API beta for file-related endpoints
    if (endpoint != null && endpoint.startsWith('files')) {
      betaFeatures.add('files-api-2025-04-14');
    }

    // Add MCP connector beta if MCP servers are configured
    final mcpServers = config.getExtension<List>('mcpServers');
    if (mcpServers != null && mcpServers.isNotEmpty) {
      betaFeatures.add('mcp-client-2025-04-04');
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

  /// Make a GET request and return JSON response
  Future<Map<String, dynamic>> getJson(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.severe('HTTP GET request failed: ${e.message}');
      rethrow;
    }
  }

  /// Make a POST request with form data
  Future<Map<String, dynamic>> postForm(
      String endpoint, FormData formData) async {
    try {
      final response = await dio.post(endpoint, data: formData);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.severe('HTTP form request failed: ${e.message}');
      rethrow;
    }
  }

  /// Make a DELETE request
  Future<void> delete(String endpoint) async {
    try {
      await dio.delete(endpoint);
    } on DioException catch (e) {
      logger.severe('HTTP DELETE request failed: ${e.message}');
      rethrow;
    }
  }

  /// Make a GET request and return raw bytes
  Future<List<int>> getRaw(String endpoint) async {
    try {
      final response = await dio.get(
        endpoint,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data as List<int>;
    } on DioException catch (e) {
      logger.severe('HTTP raw request failed: ${e.message}');
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
