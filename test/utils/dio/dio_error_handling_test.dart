import 'dart:async';

import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:llm_dart/core/config.dart';
import 'package:llm_dart/utils/http_config_utils.dart';

void main() {
  group('Dio Error Handling Tests', () {
    late List<LogRecord> logRecords;
    late StreamSubscription<LogRecord> logSubscription;

    setUp(() {
      // Enable hierarchical logging to allow setting levels on non-root loggers
      hierarchicalLoggingEnabled = true;

      logRecords = [];
      // Capture log records for testing
      logSubscription = Logger('HttpConfigUtils').onRecord.listen((record) {
        logRecords.add(record);
      });
      Logger('HttpConfigUtils').level = Level.ALL;
    });

    tearDown(() {
      logSubscription.cancel();
      logRecords.clear();
    });

    test('should log connection timeout errors', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
        'connectionTimeout': Duration(milliseconds: 1), // Very short timeout
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // This should timeout
        await dio.get('/delay/5'); // 5 second delay
        fail('Expected timeout exception');
      } catch (e) {
        expect(e, isA<DioException>());

        // Should have logged the error
        final errorLogs = logRecords
            .where((record) =>
                record.level == Level.SEVERE && record.message.contains('✗'))
            .toList();
        expect(errorLogs.length, greaterThan(0));
      }
    });

    test('should log HTTP status errors', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // This should return 404
        await dio.get('/status/404');
        fail('Expected 404 exception');
      } catch (e) {
        expect(e, isA<DioException>());

        // Should have logged the error
        final errorLogs = logRecords
            .where((record) =>
                record.level == Level.SEVERE && record.message.contains('✗'))
            .toList();
        expect(errorLogs.length, greaterThan(0));

        // Should contain the URL and error details
        final errorLog = errorLogs.first;
        expect(errorLog.message, contains('GET'));
        expect(errorLog.message, contains('/status/404'));
      }
    });

    test('should log authentication errors', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // This should return 401
        await dio.get('/status/401');
        fail('Expected 401 exception');
      } catch (e) {
        expect(e, isA<DioException>());

        // Should have logged the error
        final errorLogs = logRecords
            .where((record) =>
                record.level == Level.SEVERE && record.message.contains('✗'))
            .toList();
        expect(errorLogs.length, greaterThan(0));

        // Should contain the URL and error details
        final errorLog = errorLogs.first;
        expect(errorLog.message, contains('GET'));
        expect(errorLog.message, contains('/status/401'));
      }
    });

    test('should log server errors', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // This should return 500
        await dio.get('/status/500');
        fail('Expected 500 exception');
      } catch (e) {
        expect(e, isA<DioException>());

        // Should have logged the error
        final errorLogs = logRecords
            .where((record) =>
                record.level == Level.SEVERE && record.message.contains('✗'))
            .toList();
        expect(errorLogs.length, greaterThan(0));

        // Should contain the URL and error details
        final errorLog = errorLogs.first;
        expect(errorLog.message, contains('GET'));
        expect(errorLog.message, contains('/status/500'));
      }
    });

    test('should handle network errors gracefully', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://nonexistent-domain-12345.com',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // This should fail with network error
        await dio.get('/test');
        fail('Expected network exception');
      } catch (e) {
        expect(e, isA<DioException>());

        // Should have logged the error
        final errorLogs = logRecords
            .where((record) =>
                record.level == Level.SEVERE && record.message.contains('✗'))
            .toList();
        expect(errorLogs.length, greaterThan(0));
      }
    });

    test('should not log errors when logging is disabled', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': false,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // This should return 404
        await dio.get('/status/404');
        fail('Expected 404 exception');
      } catch (e) {
        expect(e, isA<DioException>());

        // Should not have logged anything (no logging interceptor)
        expect(logRecords.length, equals(0));
      }
    });

    test('should preserve original error information', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      try {
        await dio.get('/status/404');
        fail('Expected 404 exception');
      } catch (e) {
        expect(e, isA<DioException>());
        final dioError = e as DioException;

        // Original error information should be preserved
        expect(dioError.response?.statusCode, equals(404));
        expect(dioError.requestOptions.path, equals('/status/404'));
        expect(dioError.requestOptions.method, equals('GET'));
      }
    });

    test('should handle malformed response data gracefully', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // Get HTML response (not JSON)
        await dio.get('/html');

        // This should succeed, but let's check that logging handles non-JSON responses
        final responseLogs = logRecords
            .where((record) => record.message.contains('← 200'))
            .toList();
        expect(responseLogs.length, greaterThan(0));
      } catch (e) {
        // If it fails, that's also fine for this test
        final errorLogs =
            logRecords.where((record) => record.level == Level.SEVERE).toList();
        expect(errorLogs.length, greaterThan(0));
      }
    });

    test('should handle very large response data gracefully', () async {
      final config = LLMConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        model: 'test-model',
      ).withExtensions({
        'enableHttpLogging': true,
      });

      final dio = HttpConfigUtils.createConfiguredDio(
        baseUrl: 'https://httpbin.org',
        defaultHeaders: {'Authorization': 'Bearer test-key'},
        config: config,
      );

      // Clear any setup logs
      logRecords.clear();

      try {
        // Get a large response
        await dio.get(
            '/base64/SFRUUEJJTiBpcyBhd2Vzb21l' * 100); // Large base64 string

        // Should handle large responses without issues
        final responseLogs = logRecords
            .where((record) => record.message.contains('← 200'))
            .toList();
        expect(responseLogs.length, greaterThan(0));
      } catch (e) {
        // If it fails, that's also fine for this test
        final errorLogs =
            logRecords.where((record) => record.level == Level.SEVERE).toList();
        expect(errorLogs.length, greaterThan(0));
      }
    });
  });
}
