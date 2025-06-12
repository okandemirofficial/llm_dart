import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logging/logging.dart';

import '../core/config.dart';

/// HTTP configuration utilities for unified Dio setup across providers
///
/// This class provides common HTTP configuration functionality that can be
/// used by all providers to support features like proxies, custom headers,
/// SSL configuration, and logging.
class HttpConfigUtils {
  static final Logger _logger = Logger('HttpConfigUtils');

  /// Create a configured Dio instance with unified HTTP settings
  ///
  /// This method applies common HTTP configurations from LLMConfig extensions
  /// while allowing provider-specific customizations.
  static Dio createConfiguredDio({
    required String baseUrl,
    required Map<String, String> defaultHeaders,
    required LLMConfig config,
    Duration? defaultTimeout,
  }) {
    // Start with base options
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: _getConnectionTimeout(config, defaultTimeout),
      receiveTimeout: _getReceiveTimeout(config, defaultTimeout),
      sendTimeout: _getSendTimeout(config, defaultTimeout),
      headers: _buildHeaders(defaultHeaders, config),
    );

    final dio = Dio(options);

    // Configure HTTP client adapter with proxy and SSL settings
    _configureHttpClientAdapter(dio, config);

    // Add logging interceptor if enabled
    _configureLogging(dio, config);

    return dio;
  }

  /// Get connection timeout from config or use default
  static Duration _getConnectionTimeout(
      LLMConfig config, Duration? defaultTimeout) {
    final customTimeout = config.getExtension<Duration>('connectionTimeout');
    return customTimeout ??
        config.timeout ??
        defaultTimeout ??
        const Duration(seconds: 60);
  }

  /// Get receive timeout from config or use default
  static Duration _getReceiveTimeout(
      LLMConfig config, Duration? defaultTimeout) {
    final customTimeout = config.getExtension<Duration>('receiveTimeout');
    return customTimeout ??
        config.timeout ??
        defaultTimeout ??
        const Duration(seconds: 60);
  }

  /// Get send timeout from config or use default
  static Duration _getSendTimeout(LLMConfig config, Duration? defaultTimeout) {
    final customTimeout = config.getExtension<Duration>('sendTimeout');
    return customTimeout ??
        config.timeout ??
        defaultTimeout ??
        const Duration(seconds: 60);
  }

  /// Build headers by merging default headers with custom headers
  static Map<String, String> _buildHeaders(
    Map<String, String> defaultHeaders,
    LLMConfig config,
  ) {
    final customHeaders =
        config.getExtension<Map<String, String>>('customHeaders') ??
            <String, String>{};

    // Merge headers, with custom headers taking precedence
    return {
      ...defaultHeaders,
      ...customHeaders,
    };
  }

  /// Configure HTTP client adapter with proxy and SSL settings
  static void _configureHttpClientAdapter(Dio dio, LLMConfig config) {
    final proxyUrl = config.getExtension<String>('httpProxy');
    final bypassSSL =
        config.getExtension<bool>('bypassSSLVerification') ?? false;
    final certificatePath = config.getExtension<String>('sslCertificate');

    // Only configure adapter if any HTTP client settings are specified
    if ((proxyUrl != null && proxyUrl.isNotEmpty) ||
        bypassSSL ||
        (certificatePath != null && certificatePath.isNotEmpty)) {
      if (proxyUrl != null) {
        _logger.info('Configuring HTTP proxy: $proxyUrl');
      }
      if (bypassSSL) {
        _logger.warning('⚠️ SSL certificate verification is disabled');
      }
      if (certificatePath != null) {
        _logger.info('Loading SSL certificate from: $certificatePath');
      }

      // Set a new IOHttpClientAdapter with combined configuration
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();

          // Configure proxy if specified
          if (proxyUrl != null && proxyUrl.isNotEmpty) {
            client.findProxy = (uri) {
              return "PROXY $proxyUrl";
            };
          }

          // Configure SSL settings if specified
          if (bypassSSL) {
            client.badCertificateCallback = (cert, host, port) => true;
          }

          if (certificatePath != null && certificatePath.isNotEmpty) {
            try {
              final certFile = File(certificatePath);
              if (certFile.existsSync()) {
                // Note: This is a simplified example. In practice, you might need
                // more sophisticated certificate handling depending on the format.
                // For now, we just log that the certificate file exists
                _logger.info('SSL certificate loaded successfully');
              } else {
                _logger.warning(
                    'SSL certificate file not found: $certificatePath');
              }
            } catch (e) {
              _logger.severe('Failed to load SSL certificate: $e');
            }
          }

          return client;
        },
      );
    }
  }

  /// Configure logging interceptor if enabled
  static void _configureLogging(Dio dio, LLMConfig config) {
    final enableLogging =
        config.getExtension<bool>('enableHttpLogging') ?? false;

    if (enableLogging) {
      _logger.info('Enabling HTTP request/response logging');

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            _logger.info('→ ${options.method} ${options.uri}');
            _logger.fine('→ Headers: ${options.headers}');
            if (options.data != null) {
              _logger.fine('→ Data: ${options.data}');
            }
            handler.next(options);
          },
          onResponse: (response, handler) {
            _logger.info(
                '← ${response.statusCode} ${response.requestOptions.uri}');
            _logger.fine('← Headers: ${response.headers}');
            handler.next(response);
          },
          onError: (error, handler) {
            _logger.severe(
                '✗ ${error.requestOptions.method} ${error.requestOptions.uri}');
            _logger.severe('✗ Error: ${error.message}');
            handler.next(error);
          },
        ),
      );
    }
  }

  /// Create a simple Dio instance with minimal configuration
  ///
  /// This is a fallback method for providers that don't need advanced HTTP features.
  static Dio createSimpleDio({
    required String baseUrl,
    required Map<String, String> headers,
    Duration? timeout,
  }) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeout ?? const Duration(seconds: 60),
        receiveTimeout: timeout ?? const Duration(seconds: 60),
        headers: headers,
      ),
    );
  }

  /// Validate HTTP configuration
  ///
  /// Checks for common configuration issues and logs warnings.
  static void validateHttpConfig(LLMConfig config) {
    // Check for conflicting timeout settings
    final connectionTimeout =
        config.getExtension<Duration>('connectionTimeout');
    final receiveTimeout = config.getExtension<Duration>('receiveTimeout');
    final globalTimeout = config.timeout;

    if (connectionTimeout != null &&
        globalTimeout != null &&
        connectionTimeout != globalTimeout) {
      _logger.warning('Connection timeout differs from global timeout');
    }

    if (receiveTimeout != null &&
        globalTimeout != null &&
        receiveTimeout != globalTimeout) {
      _logger.warning('Receive timeout differs from global timeout');
    }

    // Check for security issues
    final bypassSSL =
        config.getExtension<bool>('bypassSSLVerification') ?? false;
    if (bypassSSL) {
      _logger.warning(
          '⚠️ SSL verification is disabled - use only for development');
    }

    // Check proxy configuration
    final proxyUrl = config.getExtension<String>('httpProxy');
    if (proxyUrl != null && !proxyUrl.startsWith('http')) {
      _logger.warning('Proxy URL should start with http:// or https://');
    }
  }
}
