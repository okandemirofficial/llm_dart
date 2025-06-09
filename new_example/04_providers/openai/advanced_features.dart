// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🔵 OpenAI Advanced Features - Reasoning, Function Calling, and Assistants
///
/// This example demonstrates advanced OpenAI capabilities:
/// - Reasoning models (o1 series) with thinking process
/// - Function calling and tool usage
/// - Assistants API integration
/// - Advanced configuration options
///
/// Before running, set your API key:
/// export OPENAI_API_KEY="your-openai-api-key"
void main() async {
  print('🔵 OpenAI Advanced Features - Reasoning and Tools\n');

  // Get API key
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';

  // Demonstrate advanced OpenAI features
  await demonstrateReasoningModels(apiKey);
  await demonstrateFunctionCalling(apiKey);
  await demonstrateAssistantsAPI(apiKey);
  await demonstrateAdvancedConfiguration(apiKey);
  await demonstrateStreamingFeatures(apiKey);

  print('\n✅ OpenAI advanced features completed!');
  print('📖 Next: Try image_generation.dart for DALL-E capabilities');
}

/// Demonstrate reasoning models (o1 series)
Future<void> demonstrateReasoningModels(String apiKey) async {
  print('🧠 Reasoning Models (o1 Series):\n');

  final reasoningModels = [
    {
      'name': 'o1-preview',
      'description': 'Advanced reasoning for complex problems'
    },
    {'name': 'o1-mini', 'description': 'Fast reasoning for simpler tasks'},
  ];

  const complexProblem = '''
A farmer has chickens and rabbits. In total, there are 35 heads and 94 legs.
How many chickens and how many rabbits does the farmer have?
Show your reasoning step by step.
''';

  for (final model in reasoningModels) {
    try {
      print('   Testing ${model['name']}: ${model['description']}');

      final provider = await ai()
          .openai()
          .apiKey(apiKey)
          .model(model['name']!)
          .reasoning(true) // Enable reasoning
          .reasoningEffort(ReasoningEffort.medium)
          .maxTokens(2000)
          .timeout(Duration(seconds: 120)) // Longer timeout for reasoning
          .build();

      final stopwatch = Stopwatch()..start();
      final response = await provider.chat([ChatMessage.user(complexProblem)]);
      stopwatch.stop();

      print('      Problem: Chickens and rabbits puzzle');
      print('      Time: ${stopwatch.elapsedMilliseconds}ms');

      if (response.thinking != null) {
        print(
            '      Thinking process: ${response.thinking!.length} characters');
        print('      Reasoning: ${response.thinking!.substring(0, 200)}...');
      }

      print('      Final answer: ${response.text}');

      if (response.usage != null) {
        print('      Tokens: ${response.usage!.totalTokens}');
      }

      print('');
    } catch (e) {
      print('      ❌ Error with ${model['name']}: $e\n');
    }
  }

  print('   💡 Reasoning Model Tips:');
  print('      • Use o1-preview for complex mathematical/logical problems');
  print('      • Use o1-mini for faster reasoning on simpler tasks');
  print('      • Allow longer timeouts for complex reasoning');
  print('      • Access thinking process for transparency');
  print('   ✅ Reasoning models demonstration completed\n');
}

/// Demonstrate function calling
Future<void> demonstrateFunctionCalling(String apiKey) async {
  print('🔧 Function Calling:\n');

  try {
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o')
        .temperature(0.3)
        .build();

    // Define tools/functions
    final weatherTool = Tool.function(
      name: 'get_weather',
      description: 'Get current weather information for a location',
      parameters: ParametersSchema(
        schemaType: 'object',
        properties: {
          'location': ParameterProperty(
            propertyType: 'string',
            description: 'City name or location',
          ),
          'unit': ParameterProperty(
            propertyType: 'string',
            description: 'Temperature unit',
            enumList: ['celsius', 'fahrenheit'],
          ),
        },
        required: ['location'],
      ),
    );

    final calculatorTool = Tool.function(
      name: 'calculate',
      description: 'Perform mathematical calculations',
      parameters: ParametersSchema(
        schemaType: 'object',
        properties: {
          'expression': ParameterProperty(
            propertyType: 'string',
            description: 'Mathematical expression to evaluate',
          ),
        },
        required: ['expression'],
      ),
    );

    final tools = [weatherTool, calculatorTool];

    // Test function calling
    print('   Testing function calling with multiple tools...');
    final response = await provider.chatWithTools([
      ChatMessage.user(
          'What\'s the weather like in Tokyo and calculate 15 * 23?')
    ], tools);

    print(
        '      User: What\'s the weather like in Tokyo and calculate 15 * 23?');

    if (response.toolCalls != null && response.toolCalls!.isNotEmpty) {
      print('      🔧 Tool calls made:');
      for (final toolCall in response.toolCalls!) {
        print(
            '         ${toolCall.function.name}: ${toolCall.function.arguments}');
      }

      // Simulate tool execution and continue conversation
      final toolResults = <ChatMessage>[];
      for (final toolCall in response.toolCalls!) {
        String result;
        if (toolCall.function.name == 'get_weather') {
          result = '{"temperature": 22, "condition": "sunny", "humidity": 65}';
        } else if (toolCall.function.name == 'calculate') {
          result = '{"result": 345}';
        } else {
          result = '{"error": "Unknown function"}';
        }

        toolResults.add(ChatMessage.toolResult(
          results: [toolCall],
          content: result,
        ));
      }

      // Continue conversation with tool results
      final finalResponse = await provider.chat([
        ChatMessage.user(
            'What\'s the weather like in Tokyo and calculate 15 * 23?'),
        ChatMessage.assistant(response.text ?? ''),
        ...toolResults,
      ]);

      print('      Final response: ${finalResponse.text}');
    } else {
      print('      Response: ${response.text}');
    }

    print('   ✅ Function calling demonstration completed\n');
  } catch (e) {
    print('   ❌ Function calling failed: $e\n');
  }
}

/// Demonstrate Assistants API
Future<void> demonstrateAssistantsAPI(String apiKey) async {
  print('🤖 Assistants API:\n');

  try {
    final provider = await ai().openai().apiKey(apiKey).model('gpt-4o').build();

    print('   Note: Assistants API requires OpenAI-specific implementation');
    print(
        '   For now, demonstrating basic conversation with assistant-like behavior...');

    final response = await provider.chat([
      ChatMessage.system('''
You are a patient and helpful math tutor. When solving problems:
1. Break down the problem into steps
2. Explain each step clearly
3. Show all calculations
4. Verify the answer
'''),
      ChatMessage.user('Solve this quadratic equation: 2x² + 5x - 3 = 0'),
    ]);

    print('      Math Tutor Response:');
    print('      ${response.text}');

    print('   ✅ Assistant-like behavior demonstration completed\n');
  } catch (e) {
    print('   ❌ Assistants API failed: $e\n');
  }
}

/// Demonstrate advanced configuration
Future<void> demonstrateAdvancedConfiguration(String apiKey) async {
  print('⚙️  Advanced Configuration:\n');

  // Structured output
  print('   Structured Output:');
  try {
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o')
        .temperature(0.1)
        .build();

    final response = await provider.chat([
      ChatMessage.user('''
Extract information from this text and return it in JSON format:
"John Smith, age 30, works as a software engineer at TechCorp. 
He lives in San Francisco and has 5 years of experience."

Return JSON with fields: name, age, job, company, location, experience_years
''')
    ]);

    print('      Structured response: ${response.text}');
  } catch (e) {
    print('      ❌ Structured output error: $e');
  }

  // Advanced parameters
  print('\n   Advanced Parameters:');
  try {
    final advancedProvider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o')
        .temperature(0.7)
        .topP(0.9)
        .extension('frequencyPenalty', 0.1)
        .extension('presencePenalty', 0.1)
        .maxTokens(500)
        .extension('seed', 42) // For reproducible outputs
        .extension('logitBias', {50256: -100}) // Bias against specific tokens
        .build();

    final response = await advancedProvider
        .chat([ChatMessage.user('Write a creative short story about AI.')]);

    print(
        '      Advanced config response: ${response.text?.substring(0, 200)}...');
  } catch (e) {
    print('      ❌ Advanced config error: $e');
  }

  print('\n   💡 Advanced Configuration Tips:');
  print('      • Use structured output for data extraction');
  print('      • Adjust frequency/presence penalties to reduce repetition');
  print('      • Use seed for reproducible outputs in testing');
  print('      • Logit bias can guide model behavior');
  print('   ✅ Advanced configuration demonstration completed\n');
}

/// Demonstrate streaming features
Future<void> demonstrateStreamingFeatures(String apiKey) async {
  print('🌊 Advanced Streaming:\n');

  try {
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o')
        .temperature(0.7)
        .build();

    print('   Streaming with function calls...');

    final weatherTool = Tool.function(
      name: 'get_weather',
      description: 'Get weather information',
      parameters: ParametersSchema(
        schemaType: 'object',
        properties: {
          'location': ParameterProperty(
            propertyType: 'string',
            description: 'City name',
          ),
        },
        required: ['location'],
      ),
    );

    var textContent = StringBuffer();
    var hasToolCalls = false;

    await for (final event in provider.chatStream([
      ChatMessage.user(
          'Tell me about the weather in Paris and write a short poem about it.')
    ], tools: [
      weatherTool
    ])) {
      switch (event) {
        case TextDeltaEvent(delta: final delta):
          textContent.write(delta);
          stdout.write(delta);
          break;
        case ToolCallDeltaEvent():
          if (!hasToolCalls) {
            print('\n\n🔧 Tool call detected');
            hasToolCalls = true;
          }
          break;
        case CompletionEvent(response: final response):
          print('\n\n✅ Streaming completed');
          if (response.usage != null) {
            print('   Tokens used: ${response.usage!.totalTokens}');
          }
          break;
        case ErrorEvent(error: final error):
          print('\n❌ Stream error: $error');
          break;
        case ThinkingDeltaEvent():
          // Handle thinking events if needed
          break;
      }
    }

    print('\n   Content length: ${textContent.length} characters');
    print('   Had tool calls: $hasToolCalls');

    print('   ✅ Advanced streaming demonstration completed\n');
  } catch (e) {
    print('   ❌ Advanced streaming failed: $e\n');
  }
}

/// 🎯 Key OpenAI Advanced Concepts Summary:
///
/// Reasoning Models (o1 Series):
/// - o1-preview: Complex reasoning and problem solving
/// - o1-mini: Faster reasoning for simpler tasks
/// - Thinking process access for transparency
/// - Extended timeouts for complex problems
///
/// Function Calling:
/// - Define tools with JSON schema
/// - Multi-tool conversations
/// - Tool result integration
/// - Streaming with function calls
///
/// Assistants API:
/// - Persistent conversations
/// - Code interpreter integration
/// - File handling capabilities
/// - Stateful interactions
///
/// Advanced Configuration:
/// - Structured output generation
/// - Reproducible outputs with seed
/// - Token bias for behavior control
/// - Fine-tuned parameter control
///
/// Best Practices:
/// 1. Choose appropriate model for task complexity
/// 2. Use reasoning models for complex problems
/// 3. Implement proper tool execution
/// 4. Handle streaming events appropriately
/// 5. Clean up assistants and threads
///
/// Next Steps:
/// - image_generation.dart: DALL-E image creation
/// - audio_processing.dart: Whisper and TTS
/// - ../../03_advanced_features/: Cross-provider comparisons
