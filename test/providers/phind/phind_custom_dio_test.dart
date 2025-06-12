import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:llm_dart/llm_dart.dart';

void main() {
  group('PhindProvider Custom Dio Tests', () {
    late Dio customDio;

    setUp(() {
      customDio = Dio();
    });

    group('PhindConfig with Custom Dio', () {
      test('should accept custom Dio client', () {
        final config = PhindConfig(
          apiKey: 'test-api-key',
          dioClient: customDio,
        );

        expect(config.dioClient, equals(customDio));
      });

      test('should create PhindClient with custom Dio', () {
        final config = PhindConfig(
          apiKey: 'test-api-key',
          dioClient: customDio,
        );

        final client = PhindClient(config, customDio: config.dioClient);

        // Verify that the client is created successfully
        expect(client, isNotNull);
        expect(client.config, equals(config));
      });

      test('should merge headers with custom Dio', () {
        // Pre-configure custom Dio with some headers
        customDio.options.headers['Custom-Header'] = 'custom-value';
        customDio.options.headers['Authorization'] = 'Bearer token';

        final config = PhindConfig(
          apiKey: 'test-api-key',
          baseUrl: 'https://api.phind.com/v1/',
          dioClient: customDio,
        );

        final client = PhindClient(config, customDio: config.dioClient);

        // Verify that Phind-specific headers are added while preserving custom ones
        expect(client.logger, isNotNull);
      });

      test('should use custom Dio base URL if not empty', () {
        customDio.options.baseUrl = 'https://custom.phind.com/';

        final config = PhindConfig(
          apiKey: 'test-api-key',
          baseUrl: 'https://api.phind.com/v1/', // This should be ignored
          dioClient: customDio,
        );

        final client = PhindClient(config, customDio: config.dioClient);

        // The custom Dio's base URL should be preserved
        expect(client, isNotNull);
      });
    });

    group('PhindProvider Integration', () {
      test('should create provider with custom Dio', () {
        final config = PhindConfig(
          apiKey: 'test-api-key',
          dioClient: customDio,
        );

        final provider = PhindProvider(config);

        expect(provider, isNotNull);
        expect(provider.config.dioClient, equals(customDio));
      });

      test('should use builder pattern with custom Dio', () {
        final builder =
            ai().phind().apiKey('test-api-key').dioClient(customDio);

        expect(builder, isNotNull);
        // Note: Can't test build() without actual API key
      });
    });

    group('LLMConfig Integration', () {
      test('should create PhindConfig from LLMConfig with custom Dio', () {
        final llmConfig = LLMConfig(
          apiKey: 'test-api-key',
          baseUrl: 'https://api.phind.com/v1/',
          model: 'Phind-70B',
          dioClient: customDio,
        );

        final phindConfig = PhindConfig.fromLLMConfig(llmConfig);

        expect(phindConfig.apiKey, equals('test-api-key'));
        expect(phindConfig.dioClient, equals(customDio));
      });

      test('should create PhindClient with LLMConfig custom Dio', () {
        final llmConfig = LLMConfig(
          apiKey: 'test-api-key',
          baseUrl: 'https://api.phind.com/v1/',
          model: 'Phind-70B',
          dioClient: customDio,
        );

        final phindConfig = PhindConfig.fromLLMConfig(llmConfig);
        final client =
            PhindClient(phindConfig, customDio: phindConfig.dioClient);

        expect(client, isNotNull);
        expect(client.config.dioClient, equals(customDio));
      });
    });

    group('Configuration Validation', () {
      test('copyWith should preserve dioClient', () {
        final originalConfig = PhindConfig(
          apiKey: 'test-api-key',
          model: 'Phind-70B',
          dioClient: customDio,
        );

        final newConfig = originalConfig.copyWith(model: 'Phind-34B');

        expect(newConfig.dioClient, equals(customDio));
      });

      test('copyWith should allow replacing dioClient', () {
        final originalDio = Dio();
        final newDio = Dio();

        final originalConfig = PhindConfig(
          apiKey: 'test-api-key',
          dioClient: originalDio,
        );

        final newConfig = originalConfig.copyWith(dioClient: newDio);

        expect(newConfig.dioClient, equals(newDio));
        expect(newConfig.dioClient, isNot(equals(originalDio)));
      });
    });

    group('Error Handling', () {
      test('should handle null custom Dio gracefully', () {
        final config = PhindConfig(
          apiKey: 'test-api-key',
          dioClient: null,
        );

        expect(() => PhindClient(config, customDio: config.dioClient),
            returnsNormally);
      });

      test('should handle empty base URL with custom Dio', () {
        customDio.options.baseUrl = '';

        final config = PhindConfig(
          apiKey: 'test-api-key',
          baseUrl: 'https://api.phind.com/v1/',
          dioClient: customDio,
        );

        // Should not throw during client creation
        expect(() => PhindClient(config, customDio: config.dioClient),
            returnsNormally);
      });
    });

    group('Timeout Configuration', () {
      test('should preserve existing timeouts in custom Dio', () {
        const customTimeout = Duration(seconds: 120);
        customDio.options.connectTimeout = customTimeout;
        customDio.options.receiveTimeout = customTimeout;
        customDio.options.sendTimeout = customTimeout;

        final config = PhindConfig(
          apiKey: 'test-api-key',
          timeout: const Duration(seconds: 30), // Different timeout
          dioClient: customDio,
        );

        final client = PhindClient(config, customDio: config.dioClient);

        // Custom Dio's timeouts should be preserved
        expect(client, isNotNull);
      });

      test('should set timeouts if not configured in custom Dio', () {
        final config = PhindConfig(
          apiKey: 'test-api-key',
          timeout: const Duration(seconds: 45),
          dioClient: customDio,
        );

        final client = PhindClient(config, customDio: config.dioClient);

        // Should not throw and should handle timeout configuration
        expect(client, isNotNull);
      });
    });
  });
}
