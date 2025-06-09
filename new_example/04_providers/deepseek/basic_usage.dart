// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🟠 DeepSeek Basic Usage - Getting Started with DeepSeek
///
/// This example demonstrates the fundamental usage of DeepSeek models:
/// - Model selection and configuration
/// - Basic chat functionality
/// - Cost-effective usage patterns
/// - Best practices for DeepSeek
///
/// Before running, set your API key:
/// export DEEPSEEK_API_KEY="your-deepseek-api-key"
void main() async {
  print('🟠 DeepSeek Basic Usage - Getting Started\n');

  // Get API key
  final apiKey = Platform.environment['DEEPSEEK_API_KEY'] ?? 'sk-TESTKEY';

  // Demonstrate different DeepSeek usage patterns
  await demonstrateModelSelection(apiKey);
  await demonstrateBasicChat(apiKey);
  await demonstrateConfigurationOptions(apiKey);
  await demonstrateResponseHandling(apiKey);
  await demonstrateBestPractices(apiKey);

  print('\n✅ DeepSeek basic usage completed!');
  print(
      '📖 Next: Try reasoning_models.dart for advanced DeepSeek capabilities');
}

/// Demonstrate different DeepSeek models
Future<void> demonstrateModelSelection(String apiKey) async {
  print('🎯 Model Selection:\n');

  final models = [
    {
      'name': 'deepseek-chat',
      'description': 'General purpose conversational AI'
    },
    {
      'name': 'deepseek-reasoner',
      'description': 'Advanced reasoning with thinking'
    },
    {'name': 'deepseek-coder', 'description': 'Specialized for coding tasks'},
  ];

  final question = 'What is the time complexity of binary search?';

  for (final model in models) {
    try {
      print('   Testing ${model['name']}: ${model['description']}');

      final provider = await ai()
          .deepseek()
          .apiKey(apiKey)
          .model(model['name']!)
          .temperature(0.7)
          .maxTokens(200)
          .build();

      final stopwatch = Stopwatch()..start();
      final response = await provider.chat([ChatMessage.user(question)]);
      stopwatch.stop();

      print('      Response: ${response.text}');
      print('      Time: ${stopwatch.elapsedMilliseconds}ms');

      if (response.usage != null) {
        print('      Tokens: ${response.usage!.totalTokens}');
      }

      print('');
    } catch (e) {
      print('      ❌ Error with ${model['name']}: $e\n');
    }
  }

  print('   💡 Model Selection Tips:');
  print('      • deepseek-chat: Best for general conversations');
  print('      • deepseek-reasoner: Use for complex reasoning tasks');
  print('      • deepseek-coder: Optimal for programming tasks');
  print('   ✅ Model selection demonstration completed\n');
}

/// Demonstrate basic chat functionality
Future<void> demonstrateBasicChat(String apiKey) async {
  print('💬 Basic Chat Functionality:\n');

  try {
    // Create DeepSeek provider
    final provider = await ai()
        .deepseek()
        .apiKey(apiKey)
        .model('deepseek-chat')
        .temperature(0.7)
        .maxTokens(500)
        .build();

    // Single message
    print('   Single Message:');
    var response = await provider.chat(
        [ChatMessage.user('Explain the concept of recursion in programming.')]);
    print('      User: Explain the concept of recursion in programming.');
    print('      DeepSeek: ${response.text}\n');

    // Conversation with context
    print('   Conversation with Context:');
    final conversation = [
      ChatMessage.system('You are a helpful programming tutor.'),
      ChatMessage.user('What is object-oriented programming?'),
    ];

    response = await provider.chat(conversation);
    print('      System: You are a helpful programming tutor.');
    print('      User: What is object-oriented programming?');
    print('      DeepSeek: ${response.text}\n');

    // Follow-up question
    conversation.add(ChatMessage.assistant(response.text ?? ''));
    conversation
        .add(ChatMessage.user('Can you give me a simple example in Python?'));

    response = await provider.chat(conversation);
    print('      User: Can you give me a simple example in Python?');
    print('      DeepSeek: ${response.text}');

    print('   ✅ Basic chat demonstration completed\n');
  } catch (e) {
    print('   ❌ Basic chat failed: $e\n');
  }
}

/// Demonstrate configuration options
Future<void> demonstrateConfigurationOptions(String apiKey) async {
  print('⚙️  Configuration Options:\n');

  // Temperature comparison
  print('   Temperature Effects:');
  final question = 'Write a function to calculate fibonacci numbers.';
  final temperatures = [0.1, 0.5, 0.9];

  for (final temp in temperatures) {
    try {
      final provider = await ai()
          .deepseek()
          .apiKey(apiKey)
          .model('deepseek-coder')
          .temperature(temp)
          .maxTokens(150)
          .build();

      final response = await provider.chat([ChatMessage.user(question)]);

      print('      Temperature $temp: ${response.text?.substring(0, 100)}...');
    } catch (e) {
      print('      Temperature $temp: Error - $e');
    }
  }

  print('\n   Advanced Configuration:');
  try {
    final advancedProvider = await ai()
        .deepseek()
        .apiKey(apiKey)
        .model('deepseek-reasoner')
        .temperature(0.3) // Lower for reasoning
        .maxTokens(1000)
        .timeout(Duration(seconds: 60)) // Longer for reasoning
        .systemPrompt('You are an expert problem solver.')
        .build();

    final response = await advancedProvider.chat([
      ChatMessage.user(
          'Solve this step by step: If a train travels 120 km in 1.5 hours, what is its average speed?')
    ]);

    print('      Advanced config result: ${response.text}');
    if (response.thinking != null) {
      print('      Thinking process: ${response.thinking}');
    }
  } catch (e) {
    print('      Advanced config error: $e');
  }

  print('\n   💡 Configuration Guide:');
  print('      • Temperature: 0.1 = deterministic, 0.9 = creative');
  print('      • Use lower temperature for reasoning tasks');
  print('      • Increase timeout for complex reasoning');
  print('      • System prompts help guide behavior');
  print('   ✅ Configuration demonstration completed\n');
}

/// Demonstrate response handling
Future<void> demonstrateResponseHandling(String apiKey) async {
  print('📊 Response Handling:\n');

  try {
    final provider = await ai()
        .deepseek()
        .apiKey(apiKey)
        .model('deepseek-chat')
        .temperature(0.7)
        .maxTokens(300)
        .build();

    final response = await provider.chat([
      ChatMessage.user(
          'Explain the advantages of using microservices architecture.')
    ]);

    // Basic response data
    print('   Response Content:');
    print('      Text: ${response.text}');
    print('      Length: ${response.text?.length ?? 0} characters');

    // Usage statistics
    if (response.usage != null) {
      final usage = response.usage!;
      print('\n   Usage Statistics:');
      print('      Prompt tokens: ${usage.promptTokens}');
      print('      Completion tokens: ${usage.completionTokens}');
      print('      Total tokens: ${usage.totalTokens}');

      // Cost estimation (DeepSeek is very cost-effective)
      final inputCost =
          (usage.promptTokens ?? 0) * 0.00014 / 1000; // $0.14 per 1K tokens
      final outputCost =
          (usage.completionTokens ?? 0) * 0.00028 / 1000; // $0.28 per 1K tokens
      final totalCost = inputCost + outputCost;

      print('      Estimated cost: \$${totalCost.toStringAsFixed(6)}');
      print('      Cost efficiency: Excellent! 💰');
    }

    // Response metadata
    print('\n   Response Metadata:');
    print('      Has thinking process: ${response.thinking != null}');
    print('      Has tool calls: ${response.toolCalls != null}');

    print('   ✅ Response handling demonstration completed\n');
  } catch (e) {
    print('   ❌ Response handling failed: $e\n');
  }
}

/// Demonstrate best practices
Future<void> demonstrateBestPractices(String apiKey) async {
  print('🏆 Best Practices:\n');

  // Error handling
  print('   Error Handling:');
  try {
    final provider = await ai()
        .deepseek()
        .apiKey('invalid-key') // Intentionally invalid
        .model('deepseek-chat')
        .build();

    await provider.chat([ChatMessage.user('Test')]);
  } on AuthError catch (e) {
    print('      ✅ Properly caught AuthError: ${e.message}');
  } catch (e) {
    print('      ⚠️  Unexpected error type: $e');
  }

  // Cost optimization
  print('\n   Cost Optimization:');
  try {
    final provider = await ai()
        .deepseek()
        .apiKey(apiKey)
        .model('deepseek-chat')
        .temperature(0.7)
        .build();

    // Demonstrate efficient token usage
    final shortPrompts = ['Define AI', 'Explain ML', 'What is NLP?'];

    var totalTokens = 0;
    for (final prompt in shortPrompts) {
      final response = await provider.chat([ChatMessage.user(prompt)]);
      if (response.usage != null) {
        totalTokens += response.usage!.totalTokens ?? 0;
      }
    }

    print('      ✅ Processed ${shortPrompts.length} requests');
    print('      Total tokens used: $totalTokens');
    print('      Average per request: ${totalTokens / shortPrompts.length}');
  } catch (e) {
    print('      ⚠️  Cost optimization issue: $e');
  }

  // OpenAI compatibility
  print('\n   OpenAI Compatibility:');
  try {
    final openaiProvider = await ai()
        .deepseekOpenAI() // Use OpenAI-compatible interface
        .apiKey(apiKey)
        .model('deepseek-chat')
        .build();

    final response = await openaiProvider
        .chat([ChatMessage.user('Test OpenAI compatibility')]);

    print('      ✅ OpenAI-compatible interface works');
    print('      Response: ${response.text?.substring(0, 50)}...');
  } catch (e) {
    print('      ⚠️  Compatibility issue: $e');
  }

  print('\n   💡 Best Practices Summary:');
  print('      • Choose appropriate model for task type');
  print('      • Monitor token usage for cost control');
  print('      • Use reasoning models for complex problems');
  print('      • Leverage OpenAI compatibility when needed');
  print('      • Implement proper error handling');
  print('      • Take advantage of cost-effectiveness');
  print('   ✅ Best practices demonstration completed\n');
}

/// 🎯 Key DeepSeek Concepts Summary:
///
/// Model Selection:
/// - deepseek-chat: General purpose, cost-effective
/// - deepseek-reasoner: Advanced reasoning with thinking
/// - deepseek-coder: Specialized for programming tasks
///
/// Unique Strengths:
/// - Excellent cost-performance ratio
/// - Strong reasoning capabilities
/// - Advanced coding and programming support
/// - Fast inference speeds
/// - OpenAI-compatible interface
///
/// Configuration Parameters:
/// - temperature: Creativity level (0.1-0.9)
/// - max_tokens: Response length limit
/// - timeout: Extended for reasoning tasks
/// - system_prompt: Guide model behavior
///
/// Best Use Cases:
/// - Cost-sensitive applications
/// - Programming and coding tasks
/// - Mathematical reasoning
/// - Educational content
/// - Business applications
///
/// Next Steps:
/// - reasoning_models.dart: Advanced thinking capabilities
/// - coding_assistant.dart: Programming-specific features
/// - cost_optimization.dart: Efficient usage patterns
