// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🌊 Streaming Chat - Real-time Response Streaming
///
/// This example demonstrates how to handle real-time streaming responses:
/// - Processing stream events as they arrive
/// - Building responsive user interfaces
/// - Handling different event types
/// - Error recovery and stream management
///
/// Before running, set your API key:
/// export OPENAI_API_KEY="your-key"
/// export GROQ_API_KEY="your-key"
void main() async {
  print('🌊 Streaming Chat - Real-time Response Streaming\n');

  // Get API key
  final apiKey = Platform.environment['GROQ_API_KEY'] ?? 'gsk-TESTKEY';

  // Create AI provider (Groq is great for streaming due to speed)
  final provider = await ai()
      .groq()
      .apiKey(apiKey)
      .model('llama-3.1-8b-instant')
      .temperature(0.7)
      .maxTokens(500)
      .build();

  // Demonstrate different streaming scenarios
  await demonstrateBasicStreaming(provider);
  await demonstrateStreamEventTypes(provider);
  await demonstrateStreamingWithThinking(provider);
  await demonstrateStreamErrorHandling(provider);
  await demonstrateStreamPerformance(provider);

  print('\n✅ Streaming chat completed!');
}

/// Demonstrate basic streaming functionality
Future<void> demonstrateBasicStreaming(ChatCapability provider) async {
  print('⚡ Basic Streaming:\n');

  try {
    final messages = [
      ChatMessage.user('Count from 1 to 10 and explain each number briefly.')
    ];

    print('   User: Count from 1 to 10 and explain each number briefly.');
    print('   AI: ');

    // Stream the response
    await for (final event in provider.chatStream(messages)) {
      switch (event) {
        case TextDeltaEvent(delta: final delta):
          // Print each text chunk as it arrives
          stdout.write(delta);
          break;
        case CompletionEvent():
          // Stream completed
          print('\n   ✅ Basic streaming successful\n');
          break;
        case ErrorEvent(error: final error):
          print('\n   ❌ Stream error: $error\n');
          break;
        case ThinkingDeltaEvent():
        case ToolCallDeltaEvent():
          // Handle other event types
          break;
      }
    }
  } catch (e) {
    print('   ❌ Basic streaming failed: $e\n');
  }
}

/// Demonstrate different stream event types
Future<void> demonstrateStreamEventTypes(ChatCapability provider) async {
  print('📡 Stream Event Types:\n');

  try {
    final messages = [
      ChatMessage.user('Write a short poem about programming.')
    ];

    print('   User: Write a short poem about programming.');
    print('   Processing events:\n');

    var textChunks = 0;
    var totalText = '';

    await for (final event in provider.chatStream(messages)) {
      switch (event) {
        case TextDeltaEvent(delta: final delta):
          textChunks++;
          totalText += delta;
          print('   📝 Text chunk $textChunks: "$delta"');
          break;

        case ThinkingDeltaEvent(delta: final delta):
          print('   🧠 Thinking: $delta');
          break;

        case ToolCallDeltaEvent(toolCall: final toolCall):
          print('   🔧 Tool call: ${toolCall.function.name}');
          break;

        case CompletionEvent(response: final response):
          print('\n   🏁 Completion event received');
          if (response.usage != null) {
            print('   📊 Usage: ${response.usage!.totalTokens} tokens');
          }
          break;

        case ErrorEvent(error: final error):
          print('   ❌ Error event: $error');
          break;
      }
    }

    print('\n   📈 Stream Statistics:');
    print('      • Total text chunks: $textChunks');
    print('      • Final text length: ${totalText.length} characters');
    print('   ✅ Event types demonstration successful\n');
  } catch (e) {
    print('   ❌ Event types demonstration failed: $e\n');
  }
}

/// Demonstrate streaming with thinking process (if supported)
Future<void> demonstrateStreamingWithThinking(ChatCapability provider) async {
  print('🧠 Streaming with Thinking Process:\n');

  try {
    // Try with a provider that supports thinking (switch to Anthropic if available)
    final anthropicKey = Platform.environment['ANTHROPIC_API_KEY'];
    ChatCapability thinkingProvider = provider;

    if (anthropicKey != null && anthropicKey.isNotEmpty) {
      thinkingProvider = await ai()
          .anthropic()
          .apiKey(anthropicKey)
          .model('claude-3-5-haiku-20241022')
          .temperature(0.7)
          .build();
    }

    final messages = [
      ChatMessage.user('Solve this step by step: What is 15% of 240?')
    ];

    print('   User: Solve this step by step: What is 15% of 240?');
    print('   Processing with thinking:\n');

    var hasThinking = false;

    await for (final event in thinkingProvider.chatStream(messages)) {
      switch (event) {
        case ThinkingDeltaEvent(delta: final delta):
          hasThinking = true;
          print('   🧠 Thinking: $delta');
          break;

        case TextDeltaEvent(delta: final delta):
          stdout.write(delta);
          break;

        case CompletionEvent():
          print('\n');
          break;

        case ErrorEvent(error: final error):
          print('   ❌ Error: $error');
          break;

        case ToolCallDeltaEvent():
          // Handle tool calls if needed
          break;
      }
    }

    if (hasThinking) {
      print('   ✅ Thinking process captured during streaming');
    } else {
      print(
          '   ℹ️  No thinking process available (provider may not support it)');
    }

    print('   ✅ Thinking demonstration completed\n');
  } catch (e) {
    print('   ❌ Thinking demonstration failed: $e\n');
  }
}

/// Demonstrate stream error handling
Future<void> demonstrateStreamErrorHandling(ChatCapability provider) async {
  print('🛡️  Stream Error Handling:\n');

  try {
    // Create a provider with invalid settings to trigger errors
    final invalidProvider = await ai()
        .openai()
        .apiKey('invalid-key') // Invalid API key
        .model('gpt-4o-mini')
        .build();

    final messages = [
      ChatMessage.user('This should fail due to invalid API key.')
    ];

    print('   Testing error handling with invalid API key...');

    await for (final event in invalidProvider.chatStream(messages)) {
      switch (event) {
        case TextDeltaEvent(delta: final delta):
          print('   📝 Unexpected text: $delta');
          break;

        case ErrorEvent(error: final error):
          print('   ✅ Caught error in stream: ${error.runtimeType}');
          print('   📝 Error message: ${error.toString()}');
          break;

        case CompletionEvent():
          print('   ❌ Unexpected completion');
          break;

        case ThinkingDeltaEvent():
        case ToolCallDeltaEvent():
          // Handle other event types
          break;
      }
    }
  } catch (e) {
    print('   ✅ Caught exception: ${e.runtimeType}');
    print('   📝 Exception message: $e');
  }

  print('\n   💡 Error Handling Best Practices:');
  print('      • Always wrap stream processing in try-catch');
  print('      • Handle ErrorEvent within the stream');
  print('      • Implement retry logic for transient errors');
  print('      • Provide user feedback for stream interruptions');
  print('   ✅ Error handling demonstration completed\n');
}

/// Demonstrate stream performance characteristics
Future<void> demonstrateStreamPerformance(ChatCapability provider) async {
  print('🚀 Stream Performance:\n');

  try {
    final messages = [
      ChatMessage.user(
          'Write a detailed explanation of machine learning in 200 words.')
    ];

    print(
        '   User: Write a detailed explanation of machine learning in 200 words.');
    print('   Measuring performance...\n');

    final stopwatch = Stopwatch()..start();
    var firstChunkTime = 0;
    var chunkCount = 0;
    var totalChars = 0;
    final chunkTimes = <int>[];

    await for (final event in provider.chatStream(messages)) {
      switch (event) {
        case TextDeltaEvent(delta: final delta):
          chunkCount++;
          totalChars += delta.length;

          if (firstChunkTime == 0) {
            firstChunkTime = stopwatch.elapsedMilliseconds;
            print('   ⚡ First chunk received: ${firstChunkTime}ms');
          }

          chunkTimes.add(stopwatch.elapsedMilliseconds);
          break;

        case CompletionEvent():
          stopwatch.stop();
          break;

        case ErrorEvent(error: final error):
          print('   ❌ Performance test error: $error');
          return;

        case ThinkingDeltaEvent():
        case ToolCallDeltaEvent():
          // Handle other event types
          break;
      }
    }

    final totalTime = stopwatch.elapsedMilliseconds;
    final avgChunkInterval = chunkTimes.length > 1
        ? (totalTime - firstChunkTime) / (chunkTimes.length - 1)
        : 0;

    print('\n   📊 Performance Metrics:');
    print('      • Time to first chunk: ${firstChunkTime}ms');
    print('      • Total response time: ${totalTime}ms');
    print('      • Total chunks: $chunkCount');
    print('      • Total characters: $totalChars');
    print(
        '      • Average chunk interval: ${avgChunkInterval.toStringAsFixed(1)}ms');
    print(
        '      • Characters per second: ${(totalChars * 1000 / totalTime).toStringAsFixed(1)}');

    print('\n   💡 Performance Benefits:');
    print('      • Reduced perceived latency (first chunk arrives quickly)');
    print('      • Better user experience (progressive content display)');
    print('      • Ability to process content as it arrives');
    print('      • Early error detection and handling');

    print('   ✅ Performance demonstration completed\n');
  } catch (e) {
    print('   ❌ Performance demonstration failed: $e\n');
  }
}

/// 🎯 Key Streaming Concepts Summary:
///
/// Stream Events:
/// - TextDeltaEvent: Incremental text content
/// - ThinkingDeltaEvent: AI reasoning process (some models)
/// - ToolCallDeltaEvent: Function calls (when using tools)
/// - CompletionEvent: Stream completion with metadata
/// - ErrorEvent: Error handling within stream
///
/// Benefits:
/// - Reduced perceived latency
/// - Real-time user feedback
/// - Progressive content display
/// - Better error handling
///
/// Best Practices:
/// 1. Handle all event types appropriately
/// 2. Implement proper error handling
/// 3. Measure and optimize performance
/// 4. Provide user feedback during streaming
/// 5. Consider buffering for UI updates
///
/// Next Steps:
/// - tool_calling.dart: Function calling and execution
/// - structured_output.dart: JSON schema responses
/// - error_handling.dart: Production-ready error management
