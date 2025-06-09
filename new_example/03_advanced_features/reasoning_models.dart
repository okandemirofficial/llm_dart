// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🧠 Reasoning Models - AI Thinking Processes
///
/// This example demonstrates how to use reasoning models that show their thinking:
/// - Understanding reasoning vs standard models
/// - Accessing AI thinking processes
/// - Optimizing for complex problems
/// - Comparing different reasoning approaches
///
/// Before running, set your API key:
/// export OPENAI_API_KEY="your-key"
/// export ANTHROPIC_API_KEY="your-key"
void main() async {
  print('🧠 Reasoning Models - AI Thinking Processes\n');

  // Get API keys
  final openaiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';
  final anthropicKey =
      Platform.environment['ANTHROPIC_API_KEY'] ?? 'sk-ant-TESTKEY';

  // Demonstrate different reasoning scenarios
  await demonstrateBasicReasoning(openaiKey);
  await demonstrateComplexProblemSolving(openaiKey);
  await demonstrateReasoningComparison(openaiKey, anthropicKey);
  await demonstrateThinkingProcessAnalysis(anthropicKey);

  print('\n✅ Reasoning models completed!');
  print('📖 Next: Try multi_modal.dart for image and audio processing');
}

/// Demonstrate basic reasoning capabilities
Future<void> demonstrateBasicReasoning(String apiKey) async {
  print('🔍 Basic Reasoning:\n');

  try {
    // Create reasoning model (OpenAI o1 series)
    final reasoningProvider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('o1-mini') // Reasoning model
        .temperature(1.0) // Reasoning models use fixed temperature
        .build();

    final problem = '''
A farmer has chickens and rabbits. In total, there are 35 heads and 94 legs.
How many chickens and how many rabbits does the farmer have?
Show your reasoning step by step.
''';

    print('   Problem: $problem');

    final response = await reasoningProvider.chat([ChatMessage.user(problem)]);

    print('   🤖 AI Response: ${response.text}');

    // Check if thinking process is available
    if (response.thinking != null && response.thinking!.isNotEmpty) {
      print(
          '\n   🧠 Thinking Process Available: ${response.thinking!.length} characters');
      print(
          '   First 200 chars: ${response.thinking!.substring(0, response.thinking!.length > 200 ? 200 : response.thinking!.length)}...');
    } else {
      print('\n   ℹ️  No thinking process available for this model');
    }

    print('   ✅ Basic reasoning successful\n');
  } catch (e) {
    print('   ❌ Basic reasoning failed: $e\n');
  }
}

/// Demonstrate complex problem solving
Future<void> demonstrateComplexProblemSolving(String apiKey) async {
  print('🧩 Complex Problem Solving:\n');

  try {
    // Create reasoning model for complex problems
    final reasoningProvider =
        await ai().openai().apiKey(apiKey).model('o1-mini').build();

    final complexProblem = '''
You are planning a dinner party for 8 people. You have the following constraints:
1. 2 people are vegetarian
2. 1 person is allergic to nuts
3. 1 person doesn't eat spicy food
4. Your budget is \$120
5. You want to serve 3 courses: appetizer, main, dessert

Plan a complete menu that satisfies all constraints and stays within budget.
Include estimated costs and explain your reasoning.
''';

    print(
        '   Complex Problem: Planning a dinner party with multiple constraints');

    final response =
        await reasoningProvider.chat([ChatMessage.user(complexProblem)]);

    print('   🤖 AI Solution: ${response.text}');

    // Analyze the thinking process
    if (response.thinking != null && response.thinking!.isNotEmpty) {
      print('\n   🧠 Thinking Process Analysis:');
      final thinking = response.thinking!;
      print('      • Total thinking length: ${thinking.length} characters');
      print(
          '      • Estimated thinking time: ${(thinking.length / 100).round()} seconds');

      // Look for key reasoning patterns
      final patterns = [
        'constraint',
        'budget',
        'vegetarian',
        'allergic',
        'cost',
        'total',
      ];

      for (final pattern in patterns) {
        final count =
            RegExp(pattern, caseSensitive: false).allMatches(thinking).length;
        if (count > 0) {
          print('      • Mentions "$pattern": $count times');
        }
      }
    }

    print('   ✅ Complex problem solving successful\n');
  } catch (e) {
    print('   ❌ Complex problem solving failed: $e\n');
  }
}

/// Compare reasoning vs standard models
Future<void> demonstrateReasoningComparison(
    String openaiKey, String anthropicKey) async {
  print('⚖️  Reasoning vs Standard Model Comparison:\n');

  final mathProblem = '''
If a train travels at 60 mph for 2 hours, then 80 mph for 1.5 hours, 
and finally 40 mph for 30 minutes, what is the total distance traveled?
''';

  print('   Math Problem: $mathProblem');

  // Test with standard model
  await testStandardModel(openaiKey, mathProblem);

  // Test with reasoning model
  await testReasoningModel(openaiKey, mathProblem);

  // Test with Anthropic (which has built-in reasoning)
  await testAnthropicModel(anthropicKey, mathProblem);

  print('   💡 Comparison Insights:');
  print('      • Standard models: Fast, direct answers');
  print('      • Reasoning models: Slower, step-by-step thinking');
  print('      • Anthropic: Good balance of speed and reasoning');
  print('   ✅ Model comparison completed\n');
}

/// Test standard model
Future<void> testStandardModel(String apiKey, String problem) async {
  try {
    final standardProvider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini') // Standard model
        .temperature(0.3)
        .build();

    final stopwatch = Stopwatch()..start();
    final response = await standardProvider.chat([ChatMessage.user(problem)]);
    stopwatch.stop();

    print('\n   📊 Standard Model (gpt-4o-mini):');
    print('      Response time: ${stopwatch.elapsedMilliseconds}ms');
    print('      Answer: ${response.text}');
  } catch (e) {
    print('\n   ❌ Standard model test failed: $e');
  }
}

/// Test reasoning model
Future<void> testReasoningModel(String apiKey, String problem) async {
  try {
    final reasoningProvider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('o1-mini') // Reasoning model
        .build();

    final stopwatch = Stopwatch()..start();
    final response = await reasoningProvider.chat([ChatMessage.user(problem)]);
    stopwatch.stop();

    print('\n   🧠 Reasoning Model (o1-mini):');
    print('      Response time: ${stopwatch.elapsedMilliseconds}ms');
    print('      Answer: ${response.text}');

    if (response.thinking != null) {
      print('      Thinking process: ${response.thinking!.length} chars');
    }
  } catch (e) {
    print('\n   ❌ Reasoning model test failed: $e');
  }
}

/// Test Anthropic model
Future<void> testAnthropicModel(String apiKey, String problem) async {
  try {
    final anthropicProvider = await ai()
        .anthropic()
        .apiKey(apiKey)
        .model('claude-3-5-haiku-20241022')
        .temperature(0.3)
        .build();

    final stopwatch = Stopwatch()..start();
    final response = await anthropicProvider.chat([ChatMessage.user(problem)]);
    stopwatch.stop();

    print('\n   🎭 Anthropic Model (Claude):');
    print('      Response time: ${stopwatch.elapsedMilliseconds}ms');
    print('      Answer: ${response.text}');
  } catch (e) {
    print('\n   ❌ Anthropic model test failed: $e');
  }
}

/// Demonstrate thinking process analysis
Future<void> demonstrateThinkingProcessAnalysis(String apiKey) async {
  print('🔬 Thinking Process Analysis:\n');

  try {
    final anthropicProvider = await ai()
        .anthropic()
        .apiKey(apiKey)
        .model('claude-3-5-sonnet-20241022')
        .temperature(0.7)
        .build();

    final analyticalProblem = '''
Analyze the following business scenario and provide recommendations:

A small coffee shop has been losing customers over the past 6 months.
- Revenue down 30%
- Customer complaints about slow service
- New competitor opened nearby
- Staff turnover increased
- Equipment is 5 years old

What are the top 3 priorities to address, and why?
''';

    print('   Business Problem: Coffee shop losing customers');

    final response =
        await anthropicProvider.chat([ChatMessage.user(analyticalProblem)]);

    print('   🤖 AI Analysis: ${response.text}');

    // Analyze response structure
    final responseText = response.text ?? '';
    print('\n   📈 Response Analysis:');
    print('      • Response length: ${responseText.length} characters');
    print('      • Number of paragraphs: ${responseText.split('\n\n').length}');
    print(
        '      • Contains numbered list: ${responseText.contains(RegExp(r'\d+\.'))}');
    print(
        '      • Mentions priorities: ${responseText.toLowerCase().contains('priority')}');

    // Look for structured thinking
    final structureIndicators = [
      'first',
      'second',
      'third',
      'priority',
      'important',
      'critical',
      'because',
      'therefore',
      'however',
      'recommendation',
      'suggest',
      'should'
    ];

    var structureScore = 0;
    for (final indicator in structureIndicators) {
      if (responseText.toLowerCase().contains(indicator)) {
        structureScore++;
      }
    }

    print(
        '      • Structure score: $structureScore/${structureIndicators.length}');
    print(
        '      • Well-structured response: ${structureScore > 5 ? 'Yes' : 'No'}');

    print('   ✅ Thinking process analysis completed\n');
  } catch (e) {
    print('   ❌ Thinking process analysis failed: $e\n');
  }
}

/// 🎯 Key Reasoning Concepts Summary:
///
/// Reasoning Models:
/// - o1-mini: Fast reasoning for simpler problems
/// - o1-preview: Advanced reasoning for complex problems
/// - Claude: Built-in reasoning capabilities
///
/// When to Use Reasoning:
/// - Complex multi-step problems
/// - Mathematical calculations
/// - Logical puzzles
/// - Planning and analysis
/// - Code debugging
///
/// Thinking Process:
/// - Internal reasoning steps
/// - Problem decomposition
/// - Verification and checking
/// - Alternative approaches
///
/// Best Practices:
/// 1. Use reasoning models for complex problems
/// 2. Allow extra time for reasoning
/// 3. Analyze thinking process for insights
/// 4. Compare with standard models
/// 5. Consider cost vs accuracy trade-offs
///
/// Performance Characteristics:
/// - Slower response times
/// - Higher accuracy on complex tasks
/// - More expensive per token
/// - Better at self-correction
///
/// Next Steps:
/// - multi_modal.dart: Image and audio processing
/// - custom_providers.dart: Build custom AI providers
/// - performance_optimization.dart: Speed and efficiency
