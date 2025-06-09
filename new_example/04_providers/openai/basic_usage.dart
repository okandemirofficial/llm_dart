// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🔵 OpenAI Basic Usage - Getting Started with OpenAI
///
/// This example demonstrates the fundamental usage of OpenAI models:
/// - Model selection and configuration
/// - Basic chat functionality
/// - Response handling and metadata
/// - Best practices for OpenAI
///
/// Before running, set your API key:
/// export OPENAI_API_KEY="your-openai-api-key"
void main() async {
  print('🔵 OpenAI Basic Usage - Getting Started\n');

  // Get API key
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';

  // Demonstrate different OpenAI usage patterns
  await demonstrateModelSelection(apiKey);
  await demonstrateBasicChat(apiKey);
  await demonstrateConfigurationOptions(apiKey);
  await demonstrateResponseHandling(apiKey);
  await demonstrateBestPractices(apiKey);

  print('\n✅ OpenAI basic usage completed!');
  print('📖 Next: Try advanced_features.dart for advanced OpenAI capabilities');
}

/// Demonstrate different OpenAI models
Future<void> demonstrateModelSelection(String apiKey) async {
  print('🎯 Model Selection:\n');

  final models = [
    {'name': 'gpt-4o-mini', 'description': 'Fast and cost-effective'},
    {'name': 'gpt-4o', 'description': 'High quality with vision'},
    {'name': 'gpt-4-turbo', 'description': 'Advanced reasoning'},
  ];

  final question = 'What is the capital of France?';

  for (final model in models) {
    try {
      print('   Testing ${model['name']}: ${model['description']}');

      final provider = await ai()
          .openai()
          .apiKey(apiKey)
          .model(model['name']!)
          .temperature(0.7)
          .maxTokens(100)
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
  print('      • gpt-4o-mini: Best for most applications (fast + cheap)');
  print('      • gpt-4o: Use when you need vision or highest quality');
  print('      • gpt-4-turbo: For complex reasoning tasks');
  print('   ✅ Model selection demonstration completed\n');
}

/// Demonstrate basic chat functionality
Future<void> demonstrateBasicChat(String apiKey) async {
  print('💬 Basic Chat Functionality:\n');

  try {
    // Create OpenAI provider
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.7)
        .maxTokens(500)
        .build();

    // Single message
    print('   Single Message:');
    var response = await provider
        .chat([ChatMessage.user('Explain quantum computing in one sentence.')]);
    print('      User: Explain quantum computing in one sentence.');
    print('      AI: ${response.text}\n');

    // Conversation with context
    print('   Conversation with Context:');
    final conversation = [
      ChatMessage.system('You are a helpful science teacher.'),
      ChatMessage.user('What is photosynthesis?'),
    ];

    response = await provider.chat(conversation);
    print('      System: You are a helpful science teacher.');
    print('      User: What is photosynthesis?');
    print('      AI: ${response.text}\n');

    // Follow-up question
    conversation.add(ChatMessage.assistant(response.text ?? ''));
    conversation.add(ChatMessage.user('Can you give me a simple example?'));

    response = await provider.chat(conversation);
    print('      User: Can you give me a simple example?');
    print('      AI: ${response.text}');

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
  final question = 'Write a creative opening line for a story.';
  final temperatures = [0.0, 0.5, 1.0];

  for (final temp in temperatures) {
    try {
      final provider = await ai()
          .openai()
          .apiKey(apiKey)
          .model('gpt-4o-mini')
          .temperature(temp)
          .maxTokens(50)
          .build();

      final response = await provider.chat([ChatMessage.user(question)]);

      print('      Temperature $temp: ${response.text}');
    } catch (e) {
      print('      Temperature $temp: Error - $e');
    }
  }

  print('\n   Advanced Configuration:');
  try {
    final advancedProvider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.7)
        .maxTokens(200)
        .topP(0.9) // Nucleus sampling
        .extension('frequencyPenalty', 0.1) // Reduce repetition
        .extension('presencePenalty', 0.1) // Encourage new topics
        .systemPrompt('You are a creative writing assistant.')
        .timeout(Duration(seconds: 30))
        .build();

    final response = await advancedProvider
        .chat([ChatMessage.user('Write a haiku about programming.')]);

    print('      Advanced config result: ${response.text}');
  } catch (e) {
    print('      Advanced config error: $e');
  }

  print('\n   💡 Configuration Guide:');
  print('      • Temperature: 0.0 = deterministic, 1.0 = creative');
  print('      • Top-p: Controls diversity (0.1 = focused, 1.0 = diverse)');
  print('      • Frequency penalty: Reduces word repetition');
  print('      • Presence penalty: Encourages new topics');
  print('   ✅ Configuration demonstration completed\n');
}

/// Demonstrate response handling
Future<void> demonstrateResponseHandling(String apiKey) async {
  print('📊 Response Handling:\n');

  try {
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.7)
        .maxTokens(300)
        .build();

    final response = await provider
        .chat([ChatMessage.user('Explain the benefits of renewable energy.')]);

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

      // Cost estimation (approximate rates)
      final inputCost =
          (usage.promptTokens ?? 0) * 0.00015 / 1000; // $0.15 per 1K tokens
      final outputCost =
          (usage.completionTokens ?? 0) * 0.0006 / 1000; // $0.60 per 1K tokens
      final totalCost = inputCost + outputCost;

      print('      Estimated cost: \$${totalCost.toStringAsFixed(6)}');
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
        .openai()
        .apiKey('invalid-key') // Intentionally invalid
        .model('gpt-4o-mini')
        .build();

    await provider.chat([ChatMessage.user('Test')]);
  } on AuthError catch (e) {
    print('      ✅ Properly caught AuthError: ${e.message}');
  } catch (e) {
    print('      ⚠️  Unexpected error type: $e');
  }

  // Rate limiting simulation
  print('\n   Rate Limiting:');
  try {
    final provider =
        await ai().openai().apiKey(apiKey).model('gpt-4o-mini').build();

    // Simulate multiple rapid requests
    final futures = List.generate(
        3, (i) => provider.chat([ChatMessage.user('Quick test $i')]));

    final results = await Future.wait(futures);
    print('      ✅ Handled ${results.length} concurrent requests');
  } catch (e) {
    print('      ⚠️  Rate limiting issue: $e');
  }

  // Prompt optimization
  print('\n   Prompt Optimization:');
  final optimizedPrompts = [
    'Bad: Tell me about AI',
    'Good: Explain artificial intelligence in 3 key points for a beginner',
    'Better: As an AI expert, explain artificial intelligence using 3 key points, each with a real-world example, suitable for someone with no technical background'
  ];

  for (final prompt in optimizedPrompts) {
    print('      $prompt');
  }

  print('\n   💡 Best Practices Summary:');
  print('      • Always handle authentication errors');
  print('      • Implement retry logic for rate limits');
  print('      • Use specific, detailed prompts');
  print('      • Monitor token usage and costs');
  print('      • Set appropriate timeouts');
  print('      • Use system messages for consistent behavior');
  print('   ✅ Best practices demonstration completed\n');
}

/// 🎯 Key OpenAI Concepts Summary:
///
/// Model Selection:
/// - gpt-4o-mini: Fast, cost-effective, general purpose
/// - gpt-4o: High quality, vision capabilities
/// - gpt-4-turbo: Advanced reasoning, large context
/// - o1 series: Specialized reasoning models
///
/// Configuration Parameters:
/// - temperature: Creativity level (0.0-1.0)
/// - max_tokens: Response length limit
/// - top_p: Nucleus sampling for diversity
/// - frequency_penalty: Reduce repetition
/// - presence_penalty: Encourage new topics
///
/// Response Handling:
/// - text: Main response content
/// - usage: Token consumption statistics
/// - thinking: Reasoning process (o1 models)
/// - tool_calls: Function calling results
///
/// Best Practices:
/// 1. Choose appropriate model for task
/// 2. Handle errors gracefully
/// 3. Monitor usage and costs
/// 4. Use specific prompts
/// 5. Implement rate limiting
///
/// Next Steps:
/// - advanced_features.dart: Reasoning and function calling
/// - vision_example.dart: Image processing
/// - audio_processing.dart: Speech and audio
