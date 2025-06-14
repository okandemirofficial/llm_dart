import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// HTTP Configuration Example
///
/// This example demonstrates how to configure HTTP settings for LLM providers,
/// including proxy configuration, custom headers, SSL settings, and logging.
///
/// Note: Advanced HTTP features (proxy, SSL bypass, custom certificates) are only
/// available on IO platforms (Desktop/Mobile/Server). On Web platforms, these
/// features are managed by the browser.
///
/// Before running, set API keys for the providers you want to test:
/// export OPENAI_API_KEY="your-openai-key"
/// export ANTHROPIC_API_KEY="your-anthropic-key"
/// export GROQ_API_KEY="your-groq-key"
/// export DEEPSEEK_API_KEY="your-deepseek-key"
/// export XAI_API_KEY="your-xai-key"
Future<void> main() async {
  print('🌐 HTTP Configuration Demo\n');

  // Get API keys from environment
  final apiKeys = {
    'openai': Platform.environment['OPENAI_API_KEY'],
    'anthropic': Platform.environment['ANTHROPIC_API_KEY'],
    'groq': Platform.environment['GROQ_API_KEY'],
    'deepseek': Platform.environment['DEEPSEEK_API_KEY'],
    'xai': Platform.environment['XAI_API_KEY'],
  };

  // Check if we have at least one API key
  final availableKeys = apiKeys.entries.where((e) => e.value != null).toList();
  if (availableKeys.isEmpty) {
    print('❌ Please set at least one API key:');
    print('   OPENAI_API_KEY, ANTHROPIC_API_KEY, GROQ_API_KEY,');
    print('   DEEPSEEK_API_KEY, or XAI_API_KEY');
    return;
  }

  print('📋 Available providers:');
  for (final entry in availableKeys) {
    print('   ✅ ${entry.key.toUpperCase()}');
  }

  print('');

  // Run demonstrations with available keys
  if (apiKeys['openai'] != null) {
    await demonstrateBasicHttpConfig(apiKeys['openai']!);
    await demonstrateProxyConfiguration(apiKeys['openai']!);
    await demonstrateSSLConfiguration(apiKeys['openai']!);
  }

  if (apiKeys['anthropic'] != null) {
    await demonstrateCustomHeaders(apiKeys['anthropic']!);
  }

  if (apiKeys['groq'] != null) {
    await demonstrateTimeoutConfiguration(apiKeys['groq']!);
  }

  if (apiKeys['deepseek'] != null) {
    await demonstrateLoggingConfiguration(apiKeys['deepseek']!);
  }

  if (apiKeys['xai'] != null) {
    await demonstrateComprehensiveConfig(apiKeys['xai']!);
  }

  await demonstrateConfigValidation();

  print('✅ HTTP configuration demonstration completed!');
}

/// Demonstrate basic HTTP configuration
Future<void> demonstrateBasicHttpConfig(String apiKey) async {
  print('🔧 Basic HTTP Configuration:\n');

  try {
    // Create provider with basic HTTP settings
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .timeout(Duration(seconds: 30))
        .build();

    final response = await provider.chat([
      ChatMessage.user('Hello! This is a test with basic HTTP configuration.'),
    ]);

    print('   ✅ Basic HTTP configuration successful');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Basic HTTP configuration failed: $e\n');
  }
}

/// Demonstrate proxy configuration
Future<void> demonstrateProxyConfiguration(String apiKey) async {
  print('🔄 Proxy Configuration:\n');
  print('   ℹ️  Note: Proxy configuration is only supported on IO platforms');
  print('   📝 On Web platforms, proxy settings are managed by the browser\n');

  try {
    // Note: This example shows the API usage. In practice, you would
    // need a real proxy server for this to work.
    await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .http((http) => http.proxy('http://proxy.company.com:8080'))
        .build();

    print('   ✅ Proxy configuration set successfully');
    print('   📝 Note: Proxy will be used for all HTTP requests\n');
  } catch (e) {
    print(
        '   ⚠️  Proxy configuration example (may fail without real proxy): $e\n');
  }
}

/// Demonstrate custom headers configuration
Future<void> demonstrateCustomHeaders(String anthropicApiKey) async {
  print('📋 Custom Headers Configuration (Anthropic):\n');

  try {
    final provider = await ai()
        .anthropic()
        .apiKey(anthropicApiKey)
        .model('claude-sonnet-4-20250514')
        .http((http) => http.headers({
              'X-Request-ID': 'demo-request-123',
              'X-Client-Version': '1.0.0',
              'User-Agent': 'LLMDart-Demo/1.0',
            }).header('X-Additional-Header', 'additional-value'))
        .build();

    final response = await provider.chat([
      ChatMessage.user('Hello! This request includes custom headers.'),
    ]);

    print('   ✅ Custom headers configuration successful');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Custom headers configuration failed: $e\n');
  }
}

/// Demonstrate SSL configuration
Future<void> demonstrateSSLConfiguration(String apiKey) async {
  print('🔒 SSL Configuration:\n');
  print('   ℹ️  Note: SSL configuration is only supported on IO platforms');
  print('   📝 On Web platforms, SSL/TLS is managed by the browser\n');

  try {
    // Example for local development with self-signed certificates
    await ai()
        .ollama()
        .baseUrl('https://localhost:11434/')
        .http((http) =>
            http.bypassSSLVerification(true)) // ⚠️ Only for development!
        .build();

    print('   ⚠️  SSL verification bypass enabled (development only)');
    print('   📝 Note: This should only be used for local development\n');
  } catch (e) {
    print('   ⚠️  SSL configuration example: $e\n');
  }

  try {
    // Example with custom SSL certificate
    await ai()
        .openai()
        .apiKey(apiKey)
        .http((http) => http.sslCertificate('/path/to/custom/certificate.pem'))
        .build();

    print('   ✅ Custom SSL certificate configuration set');
    print('   📝 Note: Certificate path configured for secure connections\n');
  } catch (e) {
    print('   ⚠️  Custom SSL certificate example: $e\n');
  }
}

/// Demonstrate timeout configuration with priority hierarchy
Future<void> demonstrateTimeoutConfiguration(String groqApiKey) async {
  print('⏱️  Timeout Configuration (Groq - Priority Hierarchy):\n');

  try {
    // Example 1: Global timeout only
    print('   📝 Example 1: Global timeout only');
    final provider1 = await ai()
        .groq()
        .apiKey(groqApiKey)
        .model('llama-3.1-8b-instant')
        .timeout(Duration(minutes: 1)) // Global timeout for all operations
        .build();

    final response1 = await provider1.chat([
      ChatMessage.user('Hello! This uses global timeout.'),
    ]);
    print('   ✅ Global timeout: connection=1m, receive=1m, send=1m');
    print('   📝 Response: ${response1.text}\n');

    // Example 2: Mixed configuration (global + HTTP overrides)
    print('   📝 Example 2: Mixed configuration (global + HTTP overrides)');
    final provider2 = await ai()
        .groq()
        .apiKey(groqApiKey)
        .model('llama-3.1-8b-instant')
        .timeout(Duration(minutes: 2)) // Global default: 2 minutes
        .http((http) => http
            .connectionTimeout(
                Duration(seconds: 15)) // Override connection: 15s
            .receiveTimeout(Duration(minutes: 3))) // Override receive: 3m
        // sendTimeout will use global timeout (2 minutes)
        .build();

    final response2 = await provider2.chat([
      ChatMessage.user('Hello! This uses mixed timeout configuration.'),
    ]);
    print('   ✅ Mixed timeouts: connection=15s, receive=3m, send=2m');
    print('   📝 Priority: HTTP-specific > Global > Provider defaults');
    print('   📝 Response: ${response2.text}\n');
  } catch (e) {
    print('   ❌ Timeout configuration failed: $e\n');
  }
}

/// Demonstrate logging configuration
Future<void> demonstrateLoggingConfiguration(String deepseekApiKey) async {
  print('📊 HTTP Logging Configuration (DeepSeek):\n');

  try {
    final provider = await ai()
        .deepseek()
        .apiKey(deepseekApiKey)
        .model('deepseek-chat')
        .http((http) => http.enableLogging(true))
        .build();

    print('   ✅ HTTP logging enabled');
    print('   📝 All HTTP requests and responses will be logged');
    print('   📝 Making a test request...\n');

    final response = await provider.chat([
      ChatMessage.user('Hello! This request will be logged.'),
    ]);

    print('   ✅ Request completed with logging');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Logging configuration failed: $e\n');
  }
}

/// Demonstrate comprehensive HTTP configuration
Future<void> demonstrateComprehensiveConfig(String xaiApiKey) async {
  print('🎯 Comprehensive HTTP Configuration (xAI Grok):\n');

  try {
    final provider = await ai()
        .xai()
        .apiKey(xaiApiKey)
        .model('grok-3')
        // HTTP configuration using the new layered approach
        .http((http) => http
            .headers({
              'X-Request-ID': 'comprehensive-demo-456',
              'X-Client-Name': 'LLMDart-Comprehensive-Demo',
            })
            .connectionTimeout(Duration(seconds: 20))
            .receiveTimeout(Duration(minutes: 3))
            .enableLogging(true))
        // Provider-specific configuration
        .temperature(0.7)
        .maxTokens(1000)
        .build();

    final response = await provider.chat([
      ChatMessage.user(
          'Hello! This request uses comprehensive HTTP configuration.'),
    ]);

    print('   ✅ Comprehensive configuration successful');
    print('   📝 All HTTP settings applied successfully');
    print('   📝 Response: ${response.text}\n');
  } catch (e) {
    print('   ❌ Comprehensive configuration failed: $e\n');
  }
}

/// Demonstrate configuration validation
Future<void> demonstrateConfigValidation() async {
  print('✅ Configuration Validation:\n');

  try {
    // This would typically be called internally, but shown here for demonstration
    final config = LLMConfig(
      baseUrl: 'https://api.openai.com/v1/',
      model: 'gpt-4o-mini',
      apiKey: 'test-key',
      timeout: Duration(seconds: 60),
    ).withExtensions({
      'httpProxy': 'invalid-proxy-url', // This will trigger a warning
      'bypassSSLVerification': true, // This will trigger a security warning
      'connectionTimeout':
          Duration(seconds: 30), // Different from global timeout
    });

    HttpConfigUtils.validateHttpConfig(config);
    print('   ✅ Configuration validation completed');
    print('   📝 Check logs for any warnings about configuration issues\n');
  } catch (e) {
    print('   ❌ Configuration validation failed: $e\n');
  }
}
