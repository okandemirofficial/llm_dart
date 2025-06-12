import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// Layered HTTP Configuration Example
///
/// This example demonstrates the new layered approach to HTTP configuration,
/// which provides a cleaner and more organized way to configure HTTP settings.
Future<void> main() async {
  print('🏗️  Layered HTTP Configuration Demo\n');

  // Get API key from environment
  final apiKey = Platform.environment['OPENAI_API_KEY'];
  if (apiKey == null) {
    print('❌ Please set OPENAI_API_KEY environment variable');
    return;
  }

  await demonstrateBasicLayeredConfig(apiKey);
  await demonstrateAdvancedLayeredConfig(apiKey);
  await demonstrateTimeoutPriorityInLayeredConfig(apiKey);
  await demonstrateComparisonWithFlatAPI(apiKey);
  await demonstrateConfigReusability();

  print('✅ Layered HTTP configuration demonstration completed!');
}

/// Demonstrate basic layered HTTP configuration
Future<void> demonstrateBasicLayeredConfig(String apiKey) async {
  print('🔧 Basic Layered HTTP Configuration:\n');

  try {
    // Clean, organized HTTP configuration
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .http((http) => http
            .headers({'X-Request-ID': 'layered-demo-001'})
            .connectionTimeout(Duration(seconds: 30))
            .enableLogging(true))
        .build();

    final response = await provider.chat([
      ChatMessage.user('Hello! This uses the new layered HTTP configuration.'),
    ]);

    print('   ✅ Layered HTTP configuration successful');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Layered HTTP configuration failed: $e\n');
  }
}

/// Demonstrate advanced layered HTTP configuration
Future<void> demonstrateAdvancedLayeredConfig(String apiKey) async {
  print('🚀 Advanced Layered HTTP Configuration:\n');

  try {
    // Complex HTTP configuration with multiple settings
    final provider = await ai()
        .anthropic()
        .apiKey(apiKey)
        .model('claude-3-5-haiku-20241022')
        .http((http) => http
                // Headers configuration
                .headers({
                  'X-Request-ID': 'advanced-layered-demo-002',
                  'X-Client-Version': '2.0.0',
                  'X-Environment': 'production',
                })
                .header('X-Additional-Header', 'dynamic-value')
                // Timeout configuration
                .connectionTimeout(Duration(seconds: 20))
                .receiveTimeout(Duration(minutes: 5))
                .sendTimeout(Duration(seconds: 45))
                // Debugging
                .enableLogging(true)
            // SSL configuration (example)
            // .bypassSSLVerification(false)
            // .sslCertificate('/path/to/cert.pem')
            // Proxy configuration (example)
            // .proxy('http://corporate-proxy:8080')
            )
        .build();

    final response = await provider.chat([
      ChatMessage.user(
          'Hello! This uses advanced layered HTTP configuration with multiple settings.'),
    ]);

    print('   ✅ Advanced layered configuration successful');
    print('   📝 All HTTP settings applied cleanly');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Advanced layered configuration failed: $e\n');
  }
}

/// Demonstrate timeout priority in layered configuration
Future<void> demonstrateTimeoutPriorityInLayeredConfig(String apiKey) async {
  print('⏱️  Timeout Priority in Layered Configuration:\n');

  try {
    // Example: Global timeout with HTTP-specific overrides
    final provider = await ai()
        .deepseek()
        .apiKey(apiKey)
        .model('deepseek-chat')
        .timeout(Duration(minutes: 2)) // Global timeout: 2 minutes
        .http((http) => http
            .headers({'X-Timeout-Demo': 'priority-example'})
            .connectionTimeout(
                Duration(seconds: 15)) // Override connection: 15s
            .receiveTimeout(Duration(minutes: 5)) // Override receive: 5min
            // sendTimeout will use global timeout (2 minutes)
            .enableLogging(false))
        .build();

    final response = await provider.chat([
      ChatMessage.user('This demonstrates timeout priority in layered config!'),
    ]);

    print('   ✅ Timeout priority demonstration successful');
    print('   📝 Final timeouts: connection=15s, receive=5min, send=2min');
    print('   📝 Priority: HTTP-specific > Global > Provider defaults');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Timeout priority demonstration failed: $e\n');
  }
}

/// Compare layered API with flat API approach
Future<void> demonstrateComparisonWithFlatAPI(String apiKey) async {
  print('📊 Comparison: Layered vs Flat API:\n');

  print('   🔹 Old Flat API approach would look like:');
  print('   ```dart');
  print('   final provider = await ai()');
  print('       .openai()');
  print('       .apiKey(apiKey)');
  print('       .customHeaders({...})');
  print('       .header("X-Extra", "value")');
  print('       .connectionTimeout(Duration(seconds: 30))');
  print('       .receiveTimeout(Duration(minutes: 2))');
  print('       .enableHttpLogging(true)');
  print('       .proxy("http://proxy:8080")');
  print('       .bypassSSLVerification(false)');
  print('       .build();');
  print('   ```\n');

  print('   🔹 New Layered API approach:');
  print('   ```dart');
  print('   final provider = await ai()');
  print('       .openai()');
  print('       .apiKey(apiKey)');
  print('       .http((http) => http');
  print('           .headers({...})');
  print('           .header("X-Extra", "value")');
  print('           .connectionTimeout(Duration(seconds: 30))');
  print('           .receiveTimeout(Duration(minutes: 2))');
  print('           .enableLogging(true)');
  print('           .proxy("http://proxy:8080")');
  print('           .bypassSSLVerification(false))');
  print('       .build();');
  print('   ```\n');

  print('   ✅ Benefits of Layered Approach:');
  print('   📝 • Cleaner organization of related settings');
  print('   📝 • Reduced method count on main LLMBuilder');
  print('   📝 • Better IDE autocomplete grouping');
  print('   📝 • Easier to extend with new HTTP features');
  print('   📝 • More maintainable codebase\n');

  try {
    // Demonstrate the actual layered approach
    final provider = await ai()
        .groq()
        .apiKey(apiKey)
        .model('llama-3.1-8b-instant')
        .http((http) => http
            .headers({
              'X-Demo-Type': 'layered-comparison',
              'X-Timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            })
            .connectionTimeout(Duration(seconds: 25))
            .enableLogging(false)) // Disable logging for cleaner output
        .build();

    final response = await provider.chat([
      ChatMessage.user(
          'This demonstrates the clean layered HTTP configuration approach!'),
    ]);

    print('   ✅ Layered approach demonstration successful');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Layered approach demonstration failed: $e\n');
  }
}

/// Demonstrate HTTP configuration reusability
Future<void> demonstrateConfigReusability() async {
  print('♻️  HTTP Configuration Reusability:\n');

  // Create reusable HTTP configuration
  HttpConfig createProductionHttpConfig() {
    return HttpConfig()
        .headers({
          'X-Environment': 'production',
          'X-Client-Version': '1.0.0',
          'X-Request-Source': 'mobile-app',
        })
        .connectionTimeout(Duration(seconds: 30))
        .receiveTimeout(Duration(minutes: 3))
        .enableLogging(false); // Disable in production
  }

  HttpConfig createDevelopmentHttpConfig() {
    return HttpConfig()
        .headers({
          'X-Environment': 'development',
          'X-Debug-Mode': 'true',
        })
        .connectionTimeout(Duration(seconds: 10))
        .receiveTimeout(Duration(seconds: 30))
        .enableLogging(true) // Enable in development
        .bypassSSLVerification(true); // For local testing
  }

  print('   ✅ HTTP configurations can be created as reusable functions');
  print('   📝 Production config: secure, optimized timeouts, no logging');
  print(
      '   📝 Development config: debug-friendly, logging enabled, relaxed SSL');
  print('   📝 Usage: .http((http) => createProductionHttpConfig())\n');

  // Demonstrate the configurations
  final prodConfig = createProductionHttpConfig();
  final devConfig = createDevelopmentHttpConfig();

  print(
      '   📊 Production config settings: ${prodConfig.build().keys.join(', ')}');
  print(
      '   📊 Development config settings: ${devConfig.build().keys.join(', ')}\n');
}
