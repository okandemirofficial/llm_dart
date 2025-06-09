// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🔴 Google Basic Usage - Getting Started with Gemini
///
/// This example demonstrates the fundamental usage of Google's Gemini models:
/// - Model selection and configuration
/// - Basic chat functionality
/// - Performance comparison
/// - Best practices for Gemini
///
/// Before running, set your API key:
/// export GOOGLE_API_KEY="your-google-api-key"
void main() async {
  print('🔴 Google Basic Usage - Getting Started with Gemini\n');

  // Get API key
  final apiKey =
      Platform.environment['GOOGLE_API_KEY'] ?? 'your-google-api-key';

  // Demonstrate different Gemini usage patterns
  await demonstrateModelSelection(apiKey);
  await demonstrateBasicChat(apiKey);
  await demonstrateConfigurationOptions(apiKey);
  await demonstrateResponseHandling(apiKey);
  await demonstrateBestPractices(apiKey);

  print('\n✅ Google basic usage completed!');
  print('📖 Next: Try multi_modal.dart for advanced Gemini capabilities');
}

/// Demonstrate different Gemini models
Future<void> demonstrateModelSelection(String apiKey) async {
  print('🎯 Model Selection:\n');

  final models = [
    {
      'name': 'gemini-2.5-flash-preview-05-20',
      'description': 'Fast and efficient'
    },
    {
      'name': 'gemini-2.5-pro-preview-05-20',
      'description': 'Balanced performance'
    },
    {'name': 'gemini-1.5-pro', 'description': 'Large context window'},
  ];

  final question = 'What are the main benefits of renewable energy?';

  for (final model in models) {
    try {
      print('   Testing ${model['name']}: ${model['description']}');

      final provider = await ai()
          .google()
          .apiKey(apiKey)
          .model(model['name']!)
          .temperature(0.7)
          .maxTokens(150)
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
  print('      • Flash: Best for speed and cost efficiency');
  print('      • Pro: Balanced choice for most applications');
  print('      • 1.5 Pro: Use for large context requirements');
  print('   ✅ Model selection demonstration completed\n');
}

/// Demonstrate basic chat functionality
Future<void> demonstrateBasicChat(String apiKey) async {
  print('💬 Basic Chat Functionality:\n');

  try {
    // Create Gemini provider
    final provider = await ai()
        .google()
        .apiKey(apiKey)
        .model('gemini-2.5-flash-preview-05-20')
        .temperature(0.7)
        .maxTokens(500)
        .build();

    // Single message
    print('   Single Message:');
    var response = await provider
        .chat([ChatMessage.user('Explain machine learning in simple terms.')]);
    print('      User: Explain machine learning in simple terms.');
    print('      Gemini: ${response.text}\n');

    // Conversation with context
    print('   Conversation with Context:');
    final conversation = [
      ChatMessage.system('You are a helpful technology educator.'),
      ChatMessage.user('What is artificial intelligence?'),
    ];

    response = await provider.chat(conversation);
    print('      System: You are a helpful technology educator.');
    print('      User: What is artificial intelligence?');
    print('      Gemini: ${response.text}\n');

    // Follow-up question
    conversation.add(ChatMessage.assistant(response.text ?? ''));
    conversation.add(
        ChatMessage.user('How does it differ from traditional programming?'));

    response = await provider.chat(conversation);
    print('      User: How does it differ from traditional programming?');
    print('      Gemini: ${response.text}');

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
  final question = 'Write a creative story opening about space exploration.';
  final temperatures = [0.1, 0.7, 1.0];

  for (final temp in temperatures) {
    try {
      final provider = await ai()
          .google()
          .apiKey(apiKey)
          .model('gemini-2.5-flash-preview-05-20')
          .temperature(temp)
          .maxTokens(100)
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
        .google()
        .apiKey(apiKey)
        .model('gemini-2.5-flash-preview-05-20')
        .temperature(0.7)
        .maxTokens(200)
        .reasoning(true) // Enable reasoning
        .extension('thinkingBudgetTokens', 500) // Set thinking budget
        .extension('includeThoughts', true) // Include thinking process
        .timeout(Duration(seconds: 30))
        .build();

    final response = await advancedProvider.chat([
      ChatMessage.user(
          'Solve this logic puzzle: If all roses are flowers and some flowers are red, can we conclude that some roses are red?')
    ]);

    print('      Advanced config result: ${response.text}');
    if (response.thinking != null) {
      print('      Thinking process: ${response.thinking}');
    }
  } catch (e) {
    print('      Advanced config error: $e');
  }

  print('\n   💡 Configuration Guide:');
  print('      • Temperature: 0.1 = focused, 1.0 = creative');
  print('      • Reasoning: Enable for complex problem solving');
  print('      • Thinking budget: Allocate tokens for reasoning');
  print('      • Extensions: Use for advanced features');
  print('   ✅ Configuration demonstration completed\n');
}

/// Demonstrate response handling
Future<void> demonstrateResponseHandling(String apiKey) async {
  print('📊 Response Handling:\n');

  try {
    final provider = await ai()
        .google()
        .apiKey(apiKey)
        .model('gemini-2.5-flash-preview-05-20')
        .temperature(0.7)
        .maxTokens(300)
        .reasoning(true)
        .build();

    final response = await provider.chat([
      ChatMessage.user('Analyze the environmental impact of electric vehicles.')
    ]);

    // Basic response data
    print('   Response Content:');
    print('      Text: ${response.text}');
    print('      Length: ${response.text?.length ?? 0} characters');

    // Thinking process
    if (response.thinking != null) {
      print('      Thinking: ${response.thinking!.length} characters');
    }

    // Usage statistics
    if (response.usage != null) {
      final usage = response.usage!;
      print('\n   Usage Statistics:');
      print('      Prompt tokens: ${usage.promptTokens}');
      print('      Completion tokens: ${usage.completionTokens}');
      print('      Total tokens: ${usage.totalTokens}');

      // Cost estimation (approximate rates for Gemini)
      final inputCost =
          (usage.promptTokens ?? 0) * 0.000125 / 1000; // $0.125 per 1K tokens
      final outputCost = (usage.completionTokens ?? 0) *
          0.000375 /
          1000; // $0.375 per 1K tokens
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
        .google()
        .apiKey('invalid-key') // Intentionally invalid
        .model('gemini-2.5-flash-preview-05-20')
        .build();

    await provider.chat([ChatMessage.user('Test')]);
  } on AuthError catch (e) {
    print('      ✅ Properly caught AuthError: ${e.message}');
  } catch (e) {
    print('      ⚠️  Unexpected error type: $e');
  }

  // Context window optimization
  print('\n   Context Window Optimization:');
  try {
    final provider = await ai()
        .google()
        .apiKey(apiKey)
        .model('gemini-1.5-pro') // Large context model
        .build();

    // Simulate large context usage
    final longContext = List.generate(
        10,
        (i) => ChatMessage.user(
            'Context message $i: This is part of a long conversation.'));

    final response = await provider.chat([
      ...longContext,
      ChatMessage.user('Summarize our conversation so far.')
    ]);

    print('      ✅ Handled large context: ${longContext.length} messages');
    print('      Summary: ${response.text?.substring(0, 100)}...');
  } catch (e) {
    print('      ⚠️  Context handling issue: $e');
  }

  // Safety settings
  print('\n   Safety Configuration:');
  final safetyTips = [
    'Configure appropriate safety settings for your use case',
    'Use content filtering for user-generated content',
    'Monitor responses for quality and appropriateness',
    'Implement fallback mechanisms for blocked content'
  ];

  for (final tip in safetyTips) {
    print('      • $tip');
  }

  print('\n   💡 Best Practices Summary:');
  print('      • Choose appropriate model for task complexity');
  print('      • Leverage large context windows effectively');
  print('      • Use reasoning for complex problem solving');
  print('      • Configure safety settings appropriately');
  print('      • Monitor token usage and costs');
  print('      • Handle errors gracefully');
  print('   ✅ Best practices demonstration completed\n');
}

/// 🎯 Key Google Gemini Concepts Summary:
///
/// Model Selection:
/// - gemini-2.5-flash: Fast, cost-effective, general purpose
/// - gemini-2.5-pro: Balanced performance and capability
/// - gemini-1.5-pro: Large context window (2M tokens)
///
/// Unique Features:
/// - Large context windows for complex tasks
/// - Multi-modal processing capabilities
/// - Advanced reasoning with thinking process
/// - Real-time search integration
/// - Safety and content filtering
///
/// Configuration Parameters:
/// - temperature: Creativity level (0.1-1.0)
/// - max_tokens: Response length limit
/// - reasoning: Enable thinking process
/// - thinking_budget: Allocate reasoning tokens
/// - safety_settings: Content filtering
///
/// Best Use Cases:
/// - Complex analysis and reasoning
/// - Large document processing
/// - Multi-modal applications
/// - Research and fact-checking
/// - Educational content
///
/// Next Steps:
/// - multi_modal.dart: Image and video processing
/// - reasoning_features.dart: Advanced thinking capabilities
/// - search_integration.dart: Real-time information access
