import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:llm_dart/llm_dart.dart';

void main() {
  group('Groq Custom Dio Tests', () {
    test('should accept custom Dio instance', () async {
      // Create a custom Dio instance
      final customDio = Dio();
      customDio.options.connectTimeout = const Duration(seconds: 30);
      customDio.options.receiveTimeout = const Duration(seconds: 60);

      // Create a Groq provider with custom Dio
      final config = GroqConfig(
        apiKey: 'test-api-key',
        model: 'llama-3.3-70b-versatile',
        dioClient: customDio,
      );

      // Verify the config stores the custom Dio instance
      expect(config.dioClient, equals(customDio));
    });

    test('should pass custom Dio to client', () {
      // Create a custom Dio instance
      final customDio = Dio();
      customDio.options.baseUrl = 'https://custom.test.url';

      // Create a Groq config with custom Dio
      final config = GroqConfig(
        apiKey: 'test-api-key',
        model: 'llama-3.3-70b-versatile',
        dioClient: customDio,
      );

      // Create a client with the config
      final client = GroqClient(config, customDio: config.dioClient);

      // Verify the client uses the custom Dio instance
      expect(client.dio, equals(customDio));
    });

    test('should merge headers when using custom Dio', () {
      // Create a custom Dio instance with existing headers
      final customDio = Dio();
      customDio.options.headers['Custom-Header'] = 'custom-value';

      // Create a Groq config with custom Dio
      final config = GroqConfig(
        apiKey: 'test-api-key',
        model: 'llama-3.3-70b-versatile',
        dioClient: customDio,
      );

      // Create a client with the config
      final client = GroqClient(config, customDio: config.dioClient);

      // Verify the client merged headers (should have both custom and auth headers)
      expect(
          client.dio.options.headers['Custom-Header'], equals('custom-value'));
      expect(client.dio.options.headers['Authorization'],
          contains('Bearer test-api-key'));
    });

    test('should work with builder pattern', () async {
      // Create a custom Dio instance
      final customDio = Dio();

      // Track if our custom interceptor was called
      bool interceptorCalled = false;
      customDio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          interceptorCalled = true;
          handler.next(options);
        },
      ));

      try {
        // This should work without throwing errors (though it will fail due to fake API key)
        await ai()
            .groq()
            .apiKey('fake-api-key')
            .model('llama-3.3-70b-versatile')
            .dioClient(customDio)
            .build();
      } catch (e) {
        // Expected to fail with fake API key, but we've tested the builder pattern
      }

      // The builder should have accepted our custom Dio instance
      expect(customDio.options.headers.containsKey('Authorization'), isTrue);
    });

    test('should preserve existing timeout settings', () {
      // Create a custom Dio instance with custom timeouts
      final customDio = Dio();
      customDio.options.connectTimeout = const Duration(seconds: 45);
      customDio.options.receiveTimeout = const Duration(seconds: 90);

      // Create a Groq config with custom Dio
      final config = GroqConfig(
        apiKey: 'test-api-key',
        model: 'llama-3.3-70b-versatile',
        dioClient: customDio,
        timeout: const Duration(
            seconds: 30), // This should not override custom Dio timeouts
      );

      // Create a client with the config
      final client = GroqClient(config, customDio: config.dioClient);

      // Verify the client preserves custom timeouts
      expect(client.dio.options.connectTimeout,
          equals(const Duration(seconds: 45)));
      expect(client.dio.options.receiveTimeout,
          equals(const Duration(seconds: 90)));
    });

    test('should fall back to default Dio when no custom Dio provided', () {
      // Create a Groq config without custom Dio
      final config = GroqConfig(
        apiKey: 'test-api-key',
        model: 'llama-3.3-70b-versatile',
      );

      // Create a client with the config
      final client = GroqClient(config);

      // Verify the client created its own Dio instance
      expect(client.dio, isNotNull);
      expect(client.dio.options.baseUrl, equals(config.baseUrl));
      expect(client.dio.options.headers['Authorization'],
          contains('Bearer test-api-key'));
    });

    test('copyWith should preserve dioClient', () {
      final customDio = Dio();

      final config = GroqConfig(
        apiKey: 'test-api-key',
        model: 'llama-3.3-70b-versatile',
        dioClient: customDio,
      );

      final newConfig = config.copyWith(temperature: 0.7);

      expect(newConfig.dioClient, equals(customDio));
      expect(newConfig.temperature, equals(0.7));
      expect(newConfig.apiKey, equals('test-api-key'));
    });
  });
}
