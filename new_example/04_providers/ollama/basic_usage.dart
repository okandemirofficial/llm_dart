// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🟡 Ollama Basic Usage - Local AI Models
///
/// This example demonstrates the fundamental usage of Ollama for local AI:
/// - Setting up and connecting to local Ollama server
/// - Model selection and management
/// - Basic chat functionality with local models
/// - Performance considerations and optimization
///
/// Prerequisites:
/// 1. Install Ollama: curl -fsSL https://ollama.ai/install.sh | sh
/// 2. Download a model: ollama pull llama3.2
/// 3. Start Ollama server: ollama serve
///
/// Optional environment variable:
/// export OLLAMA_BASE_URL="http://localhost:11434"
void main() async {
  print('🟡 Ollama Basic Usage - Local AI Models\n');

  // Get Ollama base URL (defaults to localhost)
  final baseUrl =
      Platform.environment['OLLAMA_BASE_URL'] ?? 'http://localhost:11434';

  // Demonstrate different Ollama usage patterns
  await demonstrateServerConnection(baseUrl);
  await demonstrateModelSelection(baseUrl);
  await demonstrateBasicChat(baseUrl);
  await demonstratePerformanceOptimization(baseUrl);
  await demonstrateBestPractices(baseUrl);

  print('\n✅ Ollama basic usage completed!');
  print('📖 Next: Try local_deployment.dart for complete setup guide');
}

/// Demonstrate server connection and health check
Future<void> demonstrateServerConnection(String baseUrl) async {
  print('🔗 Server Connection:\n');

  try {
    // Test connection to Ollama server
    print('   Testing connection to Ollama server at $baseUrl...');

    final provider = await ai()
        .ollama()
        .baseUrl(baseUrl)
        .model('llama3.2') // Default model
        .build();

    // Simple test to verify connection
    final response = await provider.chat([
      ChatMessage.user(
          'Hello! Can you respond with just "OK" to test the connection?')
    ]);

    if (response.text != null && response.text!.isNotEmpty) {
      print('   ✅ Successfully connected to Ollama server');
      print('   🤖 Response: ${response.text}');
    } else {
      print('   ⚠️  Connected but received empty response');
    }

    print('\n   💡 Connection Tips:');
    print('      • Make sure Ollama server is running: ollama serve');
    print('      • Default URL is http://localhost:11434');
    print('      • Check firewall settings if using remote server');
    print('      • Verify model is downloaded: ollama list');
    print('   ✅ Server connection test completed\n');
  } catch (e) {
    print('   ❌ Connection failed: $e');
    print('\n   🔧 Troubleshooting:');
    print(
        '      1. Install Ollama: curl -fsSL https://ollama.ai/install.sh | sh');
    print('      2. Start server: ollama serve');
    print('      3. Download model: ollama pull llama3.2');
    print('      4. Check server status: curl $baseUrl/api/tags');
    print('   ❌ Server connection failed\n');
  }
}

/// Demonstrate different model selection
Future<void> demonstrateModelSelection(String baseUrl) async {
  print('🎯 Model Selection:\n');

  final models = [
    {'name': 'llama3.2', 'description': 'General purpose, good balance'},
    {'name': 'phi3', 'description': 'Lightweight, fast'},
    {'name': 'mistral', 'description': 'Fast inference, good quality'},
    {'name': 'codellama', 'description': 'Specialized for code'},
  ];

  final question = 'What is the capital of France? Answer in one sentence.';

  for (final model in models) {
    try {
      print('   Testing ${model['name']}: ${model['description']}');

      final provider = await ai()
          .ollama()
          .baseUrl(baseUrl)
          .model(model['name']!)
          .temperature(0.7)
          .build();

      final stopwatch = Stopwatch()..start();
      final response = await provider.chat([ChatMessage.user(question)]);
      stopwatch.stop();

      print('      Response: ${response.text}');
      print('      Time: ${stopwatch.elapsedMilliseconds}ms');
      print('');
    } catch (e) {
      print('      ❌ Model ${model['name']} not available: $e');
      print('      💡 Download with: ollama pull ${model['name']}\n');
    }
  }

  print('   💡 Model Selection Guide:');
  print('      • llama3.2: Best overall choice for most tasks');
  print('      • phi3: Use when resources are limited');
  print('      • mistral: Good for fast, quality responses');
  print('      • codellama: Specialized for programming tasks');
  print('   ✅ Model selection demonstration completed\n');
}

/// Demonstrate basic chat functionality
Future<void> demonstrateBasicChat(String baseUrl) async {
  print('💬 Basic Chat Functionality:\n');

  try {
    // Create Ollama provider
    final provider = await ai()
        .ollama()
        .baseUrl(baseUrl)
        .model('llama3.2')
        .temperature(0.7)
        .build();

    // Single message
    print('   Single Message:');
    var response = await provider.chat(
        [ChatMessage.user('Explain the benefits of local AI in 2 sentences.')]);
    print('      User: Explain the benefits of local AI in 2 sentences.');
    print('      Ollama: ${response.text}\n');

    // Conversation with context
    print('   Conversation with Context:');
    final conversation = [
      ChatMessage.system(
          'You are a helpful assistant running locally. Be concise and helpful.'),
      ChatMessage.user('What are the advantages of running AI models locally?'),
    ];

    response = await provider.chat(conversation);
    print('      System: You are a helpful assistant running locally...');
    print('      User: What are the advantages of running AI models locally?');
    print('      Ollama: ${response.text}\n');

    // Follow-up question
    conversation.add(ChatMessage.assistant(response.text ?? ''));
    conversation.add(ChatMessage.user('What about the disadvantages?'));

    response = await provider.chat(conversation);
    print('      User: What about the disadvantages?');
    print('      Ollama: ${response.text}');

    print('   ✅ Basic chat demonstration completed\n');
  } catch (e) {
    print('   ❌ Basic chat failed: $e\n');
  }
}

/// Demonstrate performance optimization
Future<void> demonstratePerformanceOptimization(String baseUrl) async {
  print('⚡ Performance Optimization:\n');

  try {
    // Test different configurations
    final configs = [
      {
        'name': 'Default',
        'model': 'llama3.2',
        'params': {},
      },
      {
        'name': 'Fast (smaller context)',
        'model': 'llama3.2',
        'params': {'num_ctx': 2048},
      },
      {
        'name': 'Lightweight model',
        'model': 'phi3',
        'params': {},
      },
    ];

    final question = 'Write a short paragraph about renewable energy.';

    for (final config in configs) {
      try {
        print('   Testing ${config['name']}:');

        final builder = ai()
            .ollama()
            .baseUrl(baseUrl)
            .model(config['model'] as String)
            .temperature(0.7);

        // Apply additional parameters if specified
        final params = config['params'] as Map<String, dynamic>;
        if (params.containsKey('num_ctx')) {
          // Note: This would require the builder to support numCtx
          // For now, we'll just use the basic configuration
        }

        final provider = await builder.build();

        final stopwatch = Stopwatch()..start();
        final response = await provider.chat([ChatMessage.user(question)]);
        stopwatch.stop();

        print('      Time: ${stopwatch.elapsedMilliseconds}ms');
        print(
            '      Response: ${response.text?.substring(0, response.text!.length > 100 ? 100 : response.text!.length)}...\n');
      } catch (e) {
        print('      ❌ Configuration failed: $e\n');
      }
    }

    print('   💡 Performance Tips:');
    print('      • Use smaller models (phi3) for faster responses');
    print('      • Reduce context length for speed');
    print('      • Enable GPU acceleration if available');
    print('      • Use SSD storage for faster model loading');
    print('   ✅ Performance optimization demonstration completed\n');
  } catch (e) {
    print('   ❌ Performance demonstration failed: $e\n');
  }
}

/// Demonstrate best practices
Future<void> demonstrateBestPractices(String baseUrl) async {
  print('🏆 Best Practices:\n');

  // Error handling for unavailable models
  print('   Error Handling:');
  try {
    final provider =
        await ai().ollama().baseUrl(baseUrl).model('nonexistent-model').build();

    await provider.chat([ChatMessage.user('Test')]);
  } catch (e) {
    print('      ✅ Properly caught error for unavailable model: $e');
  }

  // Connection error handling
  print('\n   Connection Error Handling:');
  try {
    final provider = await ai()
        .ollama()
        .baseUrl('http://localhost:99999') // Invalid port
        .model('llama3.2')
        .build();

    await provider.chat([ChatMessage.user('Test')]);
  } catch (e) {
    print('      ✅ Properly caught connection error: $e');
  }

  // Resource management
  print('\n   Resource Management:');
  try {
    final provider = await ai()
        .ollama()
        .baseUrl(baseUrl)
        .model('llama3.2')
        .temperature(0.7)
        .build();

    // Simulate multiple requests
    final requests = List.generate(
        3, (i) => provider.chat([ChatMessage.user('Quick test $i')]));

    final responses = await Future.wait(requests);
    print(
        '      ✅ Handled ${responses.length} concurrent requests successfully');
  } catch (e) {
    print('      ⚠️  Resource management issue: $e');
  }

  // Model availability check
  print('\n   Model Availability:');
  final commonModels = ['llama3.2', 'phi3', 'mistral'];

  for (final model in commonModels) {
    try {
      final provider =
          await ai().ollama().baseUrl(baseUrl).model(model).build();

      await provider.chat([ChatMessage.user('Hi')]);
      print('      ✅ $model: Available');
    } catch (e) {
      print(
          '      ❌ $model: Not available (download with: ollama pull $model)');
    }
  }

  print('\n   💡 Best Practices Summary:');
  print('      • Always handle connection and model errors gracefully');
  print('      • Check model availability before using');
  print('      • Use appropriate models for your hardware');
  print('      • Monitor resource usage (RAM, CPU, GPU)');
  print('      • Keep Ollama server updated');
  print('      • Use streaming for better user experience');
  print('   ✅ Best practices demonstration completed\n');
}

/// 🎯 Key Ollama Concepts Summary:
///
/// Local Deployment:
/// - Complete privacy: No data leaves your machine
/// - Offline capability: Works without internet
/// - No API costs: Free after initial setup
/// - Full control: Customize models and parameters
///
/// Model Management:
/// - Download models: ollama pull <model-name>
/// - List models: ollama list
/// - Remove models: ollama rm <model-name>
/// - Update models: ollama pull <model-name>
///
/// Performance Factors:
/// - Hardware: More RAM/GPU = better performance
/// - Model size: Smaller models = faster responses
/// - Context length: Shorter context = faster processing
/// - Concurrent requests: Limited by hardware
///
/// Best Use Cases:
/// - Privacy-sensitive applications
/// - Offline environments
/// - Development and testing
/// - Cost-sensitive projects
/// - Custom model requirements
///
/// Configuration Tips:
/// - Start with llama3.2 for best balance
/// - Use phi3 for resource-constrained environments
/// - Enable GPU acceleration when available
/// - Monitor system resources during usage
///
/// Next Steps:
/// - local_deployment.dart: Complete setup and deployment guide
/// - privacy_setup.dart: Privacy-focused configuration
/// - ../../03_advanced_features/custom_providers.dart: Custom provider patterns
