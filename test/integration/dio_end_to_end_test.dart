import 'dart:async';

import 'package:test/test.dart';
import 'package:logging/logging.dart';
import 'package:llm_dart/llm_dart.dart';

void main() {
  group('Dio End-to-End Integration Tests', () {
    late List<LogRecord> logRecords;
    late StreamSubscription<LogRecord> logSubscription;

    setUp(() {
      logRecords = [];
      // Capture log records for testing
      logSubscription = Logger.root.onRecord.listen((record) {
        logRecords.add(record);
      });
      Logger.root.level = Level.ALL;
    });

    tearDown(() {
      logSubscription.cancel();
      logRecords.clear();
    });

    group('Provider Builder HTTP Configuration', () {
      test('should apply HTTP configuration through LLMBuilder for Anthropic',
          () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .anthropic()
              .apiKey('test-api-key')
              .model('claude-sonnet-4-20250514')
              .http((http) => http.enableLogging(true).headers({
                    'X-Test-Client': 'llm-dart-test'
                  }).connectionTimeout(Duration(seconds: 10)))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have custom header in logs
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Client'))
            .toList();
        expect(headerLogs.length, greaterThan(0));
      });

      test('should apply HTTP configuration through LLMBuilder for OpenAI',
          () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .openai()
              .apiKey('test-api-key')
              .model('gpt-4')
              .http((http) => http
                  .enableLogging(true)
                  .headers({'X-Test-Client': 'llm-dart-test'}).receiveTimeout(
                      Duration(seconds: 30)))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have custom header in logs
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Client'))
            .toList();
        expect(headerLogs.length, greaterThan(0));
      });

      test('should apply HTTP configuration through LLMBuilder for DeepSeek',
          () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .deepseek()
              .apiKey('test-api-key')
              .model('deepseek-chat')
              .http((http) => http
                  .enableLogging(true)
                  .headers({'X-Test-Client': 'llm-dart-test'}).sendTimeout(
                      Duration(seconds: 20)))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have custom header in logs
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Client'))
            .toList();
        expect(headerLogs.length, greaterThan(0));
      });

      test('should apply HTTP configuration through LLMBuilder for Groq',
          () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .groq()
              .apiKey('test-api-key')
              .model('llama-3.3-70b-versatile')
              .http((http) => http
                  .enableLogging(true)
                  .headers({'X-Test-Client': 'llm-dart-test'}))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have custom header in logs
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Client'))
            .toList();
        expect(headerLogs.length, greaterThan(0));
      });

      test('should apply HTTP configuration through LLMBuilder for xAI',
          () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .xai()
              .apiKey('test-api-key')
              .model('grok-2-latest')
              .http((http) => http
                  .enableLogging(true)
                  .headers({'X-Test-Client': 'llm-dart-test'}))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have custom header in logs
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Client'))
            .toList();
        expect(headerLogs.length, greaterThan(0));
      });

      test('should apply HTTP configuration through LLMBuilder for Google',
          () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .google()
              .apiKey('test-api-key')
              .model('gemini-1.5-flash')
              .http((http) => http
                  .enableLogging(true)
                  .headers({'X-Test-Client': 'llm-dart-test'}))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have custom header in logs
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Client'))
            .toList();
        expect(headerLogs.length, greaterThan(0));
      });
    });

    group('Complex HTTP Configuration Scenarios', () {
      test('should handle comprehensive HTTP configuration', () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .anthropic()
              .apiKey('test-api-key')
              .model('claude-sonnet-4-20250514')
              .http((http) => http
                  .enableLogging(true)
                  .headers({
                    'X-Test-Client': 'llm-dart-test',
                    'X-Test-Version': '1.0.0',
                    'X-Test-Environment': 'testing',
                  })
                  .connectionTimeout(Duration(seconds: 15))
                  .receiveTimeout(Duration(seconds: 60))
                  .sendTimeout(Duration(seconds: 30))
                  .proxy('http://proxy.example.com:8080')
                  .bypassSSLVerification(false))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have all custom headers in logs
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Client'))
            .toList();
        expect(headerLogs.length, greaterThan(0));

        final versionLogs = logRecords
            .where((record) => record.message.contains('X-Test-Version'))
            .toList();
        expect(versionLogs.length, greaterThan(0));

        final envLogs = logRecords
            .where((record) => record.message.contains('X-Test-Environment'))
            .toList();
        expect(envLogs.length, greaterThan(0));
      });

      test('should work without HTTP configuration', () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .anthropic()
              .apiKey('test-api-key')
              .model('claude-sonnet-4-20250514')
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should not have HTTP logs (logging not enabled)
        final httpLogs = logRecords
            .where((record) => record.loggerName == 'HttpConfigUtils')
            .toList();
        expect(httpLogs.length, equals(0));
      });

      test('should handle streaming with HTTP configuration', () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .openai()
              .apiKey('test-api-key')
              .model('gpt-4')
              .http((http) =>
                  http.enableLogging(true).headers({'X-Test-Stream': 'true'}))
              .build();

          await for (final _ in provider.chatStream([
            ChatMessage.user('Hello'),
          ])) {
            // Process stream events
            break; // Just test the first event
          }
        } catch (e) {
          // Expected to fail with mock API key
        }

        // Should have HTTP logs for streaming request
        final httpLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.message.contains('→ POST'))
            .toList();
        expect(httpLogs.length, greaterThan(0));

        // Should have streaming header in logs
        final streamLogs = logRecords
            .where((record) => record.message.contains('X-Test-Stream'))
            .toList();
        expect(streamLogs.length, greaterThan(0));
      });
    });

    group('Error Scenarios with HTTP Configuration', () {
      test('should log errors properly with HTTP configuration enabled',
          () async {
        // Clear any setup logs
        logRecords.clear();

        try {
          final provider = await ai()
              .anthropic()
              .apiKey('invalid-key')
              .model('claude-sonnet-4-20250514')
              .http((http) => http
                  .enableLogging(true)
                  .headers({'X-Test-Error': 'expected'}))
              .build();

          await provider.chat([
            ChatMessage.user('Hello'),
          ]);
        } catch (e) {
          // Expected to fail with invalid API key
        }

        // Should have HTTP error logs
        final errorLogs = logRecords
            .where((record) =>
                record.loggerName == 'HttpConfigUtils' &&
                record.level == Level.SEVERE &&
                record.message.contains('✗'))
            .toList();
        expect(errorLogs.length, greaterThan(0));

        // Should have request logs with custom header
        final headerLogs = logRecords
            .where((record) => record.message.contains('X-Test-Error'))
            .toList();
        expect(headerLogs.length, greaterThan(0));
      });
    });
  });
}
