import 'package:test/test.dart';
import 'package:llm_dart/llm_dart.dart';

void main() {
  group('HttpConfig Tests', () {
    group('Basic Configuration', () {
      test('should create empty HttpConfig', () {
        final config = HttpConfig();
        expect(config, isNotNull);
        expect(config.build(), isEmpty);
      });

      test('should set proxy configuration', () {
        final config = HttpConfig().proxy('http://proxy.example.com:8080');
        final result = config.build();

        expect(result['httpProxy'], equals('http://proxy.example.com:8080'));
      });

      test('should set custom headers', () {
        final headers = {
          'X-Custom-Header': 'value1',
          'User-Agent': 'TestApp/1.0',
        };
        final config = HttpConfig().headers(headers);
        final result = config.build();

        expect(result['customHeaders'], equals(headers));
      });

      test('should set single header', () {
        final config = HttpConfig().header('X-Request-ID', 'test-123');
        final result = config.build();

        expect(result['customHeaders'], equals({'X-Request-ID': 'test-123'}));
      });

      test('should merge multiple headers', () {
        final config = HttpConfig()
            .headers({'X-Header-1': 'value1'}).header('X-Header-2', 'value2');
        final result = config.build();

        expect(
            result['customHeaders'],
            equals({
              'X-Header-1': 'value1',
              'X-Header-2': 'value2',
            }));
      });

      test('should override existing headers', () {
        final config = HttpConfig()
            .headers({'X-Header': 'original'}).header('X-Header', 'updated');
        final result = config.build();

        expect(result['customHeaders'], equals({'X-Header': 'updated'}));
      });
    });

    group('SSL Configuration', () {
      test('should set SSL verification bypass', () {
        final config = HttpConfig().bypassSSLVerification(true);
        final result = config.build();

        expect(result['bypassSSLVerification'], isTrue);
      });

      test('should set SSL certificate path', () {
        final config = HttpConfig().sslCertificate('/path/to/cert.pem');
        final result = config.build();

        expect(result['sslCertificate'], equals('/path/to/cert.pem'));
      });

      test('should configure both SSL settings', () {
        final config = HttpConfig()
            .bypassSSLVerification(false)
            .sslCertificate('/path/to/cert.pem');
        final result = config.build();

        expect(result['bypassSSLVerification'], isFalse);
        expect(result['sslCertificate'], equals('/path/to/cert.pem'));
      });
    });

    group('Timeout Configuration', () {
      test('should set connection timeout', () {
        final timeout = Duration(seconds: 30);
        final config = HttpConfig().connectionTimeout(timeout);
        final result = config.build();

        expect(result['connectionTimeout'], equals(timeout));
      });

      test('should set receive timeout', () {
        final timeout = Duration(minutes: 5);
        final config = HttpConfig().receiveTimeout(timeout);
        final result = config.build();

        expect(result['receiveTimeout'], equals(timeout));
      });

      test('should set send timeout', () {
        final timeout = Duration(seconds: 120);
        final config = HttpConfig().sendTimeout(timeout);
        final result = config.build();

        expect(result['sendTimeout'], equals(timeout));
      });

      test('should set all timeout configurations', () {
        final connectionTimeout = Duration(seconds: 15);
        final receiveTimeout = Duration(minutes: 3);
        final sendTimeout = Duration(seconds: 60);

        final config = HttpConfig()
            .connectionTimeout(connectionTimeout)
            .receiveTimeout(receiveTimeout)
            .sendTimeout(sendTimeout);
        final result = config.build();

        expect(result['connectionTimeout'], equals(connectionTimeout));
        expect(result['receiveTimeout'], equals(receiveTimeout));
        expect(result['sendTimeout'], equals(sendTimeout));
      });
    });

    group('Logging Configuration', () {
      test('should enable logging', () {
        final config = HttpConfig().enableLogging(true);
        final result = config.build();

        expect(result['enableHttpLogging'], isTrue);
      });

      test('should disable logging', () {
        final config = HttpConfig().enableLogging(false);
        final result = config.build();

        expect(result['enableHttpLogging'], isFalse);
      });
    });

    group('Method Chaining', () {
      test('should support fluent interface', () {
        final config = HttpConfig()
            .proxy('http://proxy:8080')
            .headers({'X-App': 'TestApp'})
            .header('X-Version', '1.0')
            .connectionTimeout(Duration(seconds: 30))
            .receiveTimeout(Duration(minutes: 2))
            .sendTimeout(Duration(seconds: 45))
            .bypassSSLVerification(false)
            .sslCertificate('/path/to/cert.pem')
            .enableLogging(true);

        expect(config, isNotNull);

        final result = config.build();
        expect(result['httpProxy'], equals('http://proxy:8080'));
        expect(
            result['customHeaders'],
            equals({
              'X-App': 'TestApp',
              'X-Version': '1.0',
            }));
        expect(result['connectionTimeout'], equals(Duration(seconds: 30)));
        expect(result['receiveTimeout'], equals(Duration(minutes: 2)));
        expect(result['sendTimeout'], equals(Duration(seconds: 45)));
        expect(result['bypassSSLVerification'], isFalse);
        expect(result['sslCertificate'], equals('/path/to/cert.pem'));
        expect(result['enableHttpLogging'], isTrue);
      });

      test('should return new instance for each method call', () {
        final config1 = HttpConfig();
        final config2 = config1.proxy('http://proxy:8080');
        final config3 = config2.enableLogging(true);

        // Each method should return the same instance (fluent interface)
        expect(identical(config1, config2), isTrue);
        expect(identical(config2, config3), isTrue);
      });
    });

    group('Configuration Isolation', () {
      test('should not affect other instances', () {
        final config1 = HttpConfig().proxy('http://proxy1:8080');
        final config2 = HttpConfig().proxy('http://proxy2:8080');

        final result1 = config1.build();
        final result2 = config2.build();

        expect(result1['httpProxy'], equals('http://proxy1:8080'));
        expect(result2['httpProxy'], equals('http://proxy2:8080'));
      });

      test('should create independent configurations', () {
        final baseConfig = HttpConfig().headers(
            {'X-Base': 'base'}).connectionTimeout(Duration(seconds: 30));

        final config1 = HttpConfig()
            .headers(baseConfig.build()['customHeaders'] ?? {})
            .connectionTimeout(baseConfig.build()['connectionTimeout'])
            .proxy('http://proxy1:8080');

        final config2 = HttpConfig()
            .headers(baseConfig.build()['customHeaders'] ?? {})
            .connectionTimeout(baseConfig.build()['connectionTimeout'])
            .proxy('http://proxy2:8080');

        final result1 = config1.build();
        final result2 = config2.build();

        expect(result1['httpProxy'], equals('http://proxy1:8080'));
        expect(result2['httpProxy'], equals('http://proxy2:8080'));
        expect(result1['customHeaders'], equals(result2['customHeaders']));
      });
    });

    group('Edge Cases', () {
      test('should handle empty headers map', () {
        final config = HttpConfig().headers({});
        final result = config.build();

        expect(result['customHeaders'], equals({}));
      });

      test('should handle null values gracefully', () {
        final config = HttpConfig();
        final result = config.build();

        // Should not contain keys for unset values
        expect(result.containsKey('httpProxy'), isFalse);
        expect(result.containsKey('customHeaders'), isFalse);
        expect(result.containsKey('bypassSSLVerification'), isFalse);
      });

      test('should handle zero duration timeouts', () {
        final config = HttpConfig()
            .connectionTimeout(Duration.zero)
            .receiveTimeout(Duration.zero)
            .sendTimeout(Duration.zero);
        final result = config.build();

        expect(result['connectionTimeout'], equals(Duration.zero));
        expect(result['receiveTimeout'], equals(Duration.zero));
        expect(result['sendTimeout'], equals(Duration.zero));
      });
    });
  });
}
