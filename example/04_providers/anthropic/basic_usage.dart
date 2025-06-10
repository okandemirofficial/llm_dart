// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🟣 Anthropic Basic Usage - Getting Started with Claude
///
/// This example demonstrates the fundamental usage of Anthropic's Claude models:
/// - Model selection and configuration
/// - Basic chat functionality
/// - Safety features and guidelines
/// - Best practices for Claude
///
/// Before running, set your API key:
/// export ANTHROPIC_API_KEY="your-anthropic-api-key"
void main() async {
  print('🟣 Anthropic Basic Usage - Getting Started with Claude\n');

  // Get API key
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? 'sk-ant-TESTKEY';

  // Demonstrate different Claude usage patterns
  await demonstrateModelSelection(apiKey);
  await demonstrateBasicChat(apiKey);
  await demonstrateSafetyFeatures(apiKey);
  await demonstrateReasoningCapabilities(apiKey);
  await demonstrateBestPractices(apiKey);

  print('\n✅ Anthropic basic usage completed!');
  print('📖 Next: Try extended_thinking.dart for advanced reasoning');
}

/// Demonstrate different Claude models
Future<void> demonstrateModelSelection(String apiKey) async {
  print('🎯 Model Selection:\n');

  final models = [
    {
      'name': 'claude-3-5-haiku-20241022',
      'description': 'Fast and cost-effective'
    },
    {
      'name': 'claude-3-5-sonnet-20241022',
      'description': 'Balanced performance'
    },
    {'name': 'claude-3-opus-20240229', 'description': 'Highest quality'},
  ];

  final question = 'Explain the concept of machine learning in simple terms.';

  for (final model in models) {
    try {
      print('   Testing ${model['name']}: ${model['description']}');

      final provider = await ai()
          .anthropic()
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
  print('      • Haiku: Best for speed and cost efficiency');
  print('      • Sonnet: Balanced choice for most applications');
  print('      • Opus: Use for complex reasoning and highest quality');
  print('   ✅ Model selection demonstration completed\n');
}

/// Demonstrate basic chat functionality
Future<void> demonstrateBasicChat(String apiKey) async {
  print('💬 Basic Chat Functionality:\n');

  try {
    // Create Claude provider
    final provider = await ai()
        .anthropic()
        .apiKey(apiKey)
        .model('claude-3-5-haiku-20241022')
        .temperature(0.7)
        .maxTokens(500)
        .build();

    // Single message
    print('   Single Message:');
    var response = await provider
        .chat([ChatMessage.user('What are the three laws of robotics?')]);
    print('      User: What are the three laws of robotics?');
    print('      Claude: ${response.text}\n');

    // Conversation with context
    print('   Conversation with Context:');
    final conversation = [
      ChatMessage.system(
          'You are a helpful philosophy teacher who explains complex concepts clearly.'),
      ChatMessage.user('What is the trolley problem?'),
    ];

    response = await provider.chat(conversation);
    print('      System: You are a helpful philosophy teacher...');
    print('      User: What is the trolley problem?');
    print('      Claude: ${response.text}\n');

    // Follow-up question
    conversation.add(ChatMessage.assistant(response.text ?? ''));
    conversation.add(ChatMessage.user(
        'What are the main ethical perspectives on this dilemma?'));

    response = await provider.chat(conversation);
    print(
        '      User: What are the main ethical perspectives on this dilemma?');
    print('      Claude: ${response.text}');

    print('   ✅ Basic chat demonstration completed\n');
  } catch (e) {
    print('   ❌ Basic chat failed: $e\n');
  }
}

/// Demonstrate Claude's safety features
Future<void> demonstrateSafetyFeatures(String apiKey) async {
  print('🛡️  Safety Features:\n');

  try {
    final provider = await ai()
        .anthropic()
        .apiKey(apiKey)
        .model('claude-3-5-haiku-20241022')
        .temperature(0.7)
        .maxTokens(300)
        .build();

    // Test ethical reasoning
    print('   Ethical Reasoning:');
    var response = await provider.chat(
        [ChatMessage.user('Should I lie to protect someone\'s feelings?')]);
    print('      User: Should I lie to protect someone\'s feelings?');
    print('      Claude: ${response.text}\n');

    // Test balanced perspective
    print('   Balanced Perspective:');
    response = await provider.chat(
        [ChatMessage.user('What are the pros and cons of social media?')]);
    print('      User: What are the pros and cons of social media?');
    print('      Claude: ${response.text}\n');

    // Test refusal of harmful content
    print('   Safety Boundaries:');
    response = await provider.chat(
        [ChatMessage.user('How can I help someone who seems depressed?')]);
    print('      User: How can I help someone who seems depressed?');
    print('      Claude: ${response.text}');

    print('\n   💡 Safety Features:');
    print('      • Refuses harmful or dangerous requests');
    print('      • Provides balanced, thoughtful perspectives');
    print('      • Considers ethical implications');
    print('      • Offers helpful, constructive advice');
    print('   ✅ Safety features demonstration completed\n');
  } catch (e) {
    print('   ❌ Safety features demonstration failed: $e\n');
  }
}

/// Demonstrate reasoning capabilities
Future<void> demonstrateReasoningCapabilities(String apiKey) async {
  print('🧠 Reasoning Capabilities:\n');

  try {
    final provider = await ai()
        .anthropic()
        .apiKey(apiKey)
        .model('claude-3-5-sonnet-20241022') // Better for reasoning
        .temperature(0.3) // Lower temperature for more focused reasoning
        .maxTokens(800)
        .build();

    // Logical reasoning
    print('   Logical Reasoning:');
    var response = await provider.chat([
      ChatMessage.user('''
All birds can fly.
Penguins are birds.
Can penguins fly?

Please explain your reasoning step by step.
''')
    ]);
    print(
        '      Logic Problem: All birds can fly. Penguins are birds. Can penguins fly?');
    print('      Claude: ${response.text}\n');

    // Mathematical reasoning
    print('   Mathematical Reasoning:');
    response = await provider.chat([
      ChatMessage.user('''
A store sells apples for \$2 per pound and oranges for \$3 per pound.
If I buy 4 pounds of apples and 2 pounds of oranges, and I pay with a \$20 bill,
how much change will I receive? Show your work.
''')
    ]);
    print('      Math Problem: Calculate change from fruit purchase');
    print('      Claude: ${response.text}\n');

    // Analytical reasoning
    print('   Analytical Reasoning:');
    response = await provider.chat([
      ChatMessage.user('''
A company's sales increased by 20% in Q1, decreased by 10% in Q2, 
increased by 15% in Q3, and decreased by 5% in Q4.
If they started with \$100,000 in sales, what were their final sales?
Explain each step.
''')
    ]);
    print('      Analysis Problem: Calculate quarterly sales changes');
    print('      Claude: ${response.text}');

    print('\n   💡 Reasoning Strengths:');
    print('      • Step-by-step problem breakdown');
    print('      • Clear explanation of logic');
    print('      • Identifies assumptions and limitations');
    print('      • Shows mathematical work');
    print('   ✅ Reasoning capabilities demonstration completed\n');
  } catch (e) {
    print('   ❌ Reasoning demonstration failed: $e\n');
  }
}

/// Demonstrate best practices
Future<void> demonstrateBestPractices(String apiKey) async {
  print('🏆 Best Practices:\n');

  // Error handling
  print('   Error Handling:');
  try {
    final provider = await ai()
        .anthropic()
        .apiKey('invalid-key') // Intentionally invalid
        .model('claude-3-5-haiku-20241022')
        .build();

    await provider.chat([ChatMessage.user('Test')]);
  } on AuthError catch (e) {
    print('      ✅ Properly caught AuthError: ${e.message}');
  } catch (e) {
    print('      ⚠️  Unexpected error type: $e');
  }

  // Prompt optimization
  print('\n   Prompt Optimization:');
  final provider = await ai()
      .anthropic()
      .apiKey(apiKey)
      .model('claude-3-5-haiku-20241022')
      .temperature(0.7)
      .build();

  // Compare different prompt styles
  final prompts = [
    'Explain AI',
    'Explain artificial intelligence in 3 key points',
    'As an AI expert, explain artificial intelligence using 3 key points with examples, suitable for a business audience'
  ];

  for (int i = 0; i < prompts.length; i++) {
    try {
      final response = await provider.chat([ChatMessage.user(prompts[i])]);

      print('      Prompt ${i + 1}: "${prompts[i]}"');
      print(
          '      Response quality: ${response.text!.length > 200 ? 'Detailed' : 'Brief'}');
      print(
          '      Structure: ${response.text!.contains('1.') ? 'Structured' : 'Unstructured'}');
      print('');
    } catch (e) {
      print('      Prompt ${i + 1}: Error - $e');
    }
  }

  // Configuration optimization
  print('   Configuration Optimization:');
  final configs = [
    {'temp': 0.1, 'desc': 'Focused, consistent'},
    {'temp': 0.7, 'desc': 'Balanced creativity'},
    {'temp': 1.0, 'desc': 'Highly creative'},
  ];

  for (final config in configs) {
    try {
      final configProvider = await ai()
          .anthropic()
          .apiKey(apiKey)
          .model('claude-3-5-haiku-20241022')
          .temperature(config['temp'] as double)
          .maxTokens(100)
          .build();

      final response = await configProvider.chat(
          [ChatMessage.user('Write a creative tagline for a coffee shop.')]);

      print('      Temperature ${config['temp']}: ${config['desc']}');
      print('      Result: ${response.text}');
      print('');
    } catch (e) {
      print('      Temperature ${config['temp']}: Error - $e');
    }
  }

  print('   💡 Best Practices Summary:');
  print('      • Use specific, detailed prompts');
  print('      • Choose appropriate model for task complexity');
  print('      • Adjust temperature based on creativity needs');
  print('      • Implement proper error handling');
  print('      • Leverage Claude\'s reasoning strengths');
  print('      • Use system messages for consistent behavior');
  print('   ✅ Best practices demonstration completed\n');
}

/// 🎯 Key Anthropic Concepts Summary:
///
/// Model Selection:
/// - claude-3-5-haiku: Fast, cost-effective, good for simple tasks
/// - claude-3-5-sonnet: Balanced performance, best for most use cases
/// - claude-3-opus: Highest quality, complex reasoning tasks
///
/// Unique Strengths:
/// - Advanced reasoning and analysis
/// - Strong safety and ethical guidelines
/// - Balanced, thoughtful responses
/// - Large context windows (200K tokens)
/// - Transparent thinking process
///
/// Configuration Tips:
/// - Lower temperature (0.1-0.3) for analytical tasks
/// - Higher temperature (0.7-1.0) for creative tasks
/// - Use detailed, specific prompts
/// - Leverage system messages for context
///
/// Best Use Cases:
/// - Complex problem solving
/// - Ethical reasoning and analysis
/// - Long document processing
/// - Educational content
/// - Research and analysis
///
/// Next Steps:
/// - extended_thinking.dart: Access Claude's reasoning process
/// - file_handling.dart: Document processing capabilities
/// - ../../03_advanced_features/reasoning_models.dart: Compare reasoning models
