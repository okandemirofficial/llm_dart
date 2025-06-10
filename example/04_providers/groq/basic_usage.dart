// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🟢 Groq Basic Usage - Ultra-Fast AI Inference
///
/// This example demonstrates the fundamental usage of Groq's lightning-fast models:
/// - Model selection for speed vs quality
/// - Basic chat functionality
/// - Performance benchmarking
/// - Best practices for Groq
///
/// Before running, set your API key:
/// export GROQ_API_KEY="your-groq-api-key"
void main() async {
  print('🟢 Groq Basic Usage - Ultra-Fast AI Inference\n');

  // Get API key
  final apiKey = Platform.environment['GROQ_API_KEY'] ?? 'gsk-TESTKEY';

  // Demonstrate different Groq usage patterns
  await demonstrateModelSelection(apiKey);
  await demonstrateSpeedBenchmark(apiKey);
  await demonstrateBasicChat(apiKey);
  await demonstrateStreamingPerformance(apiKey);
  await demonstrateBestPractices(apiKey);

  print('\n✅ Groq basic usage completed!');
  print(
      '📖 Next: Try speed_optimization.dart for advanced performance techniques');
}

/// Demonstrate different Groq models
Future<void> demonstrateModelSelection(String apiKey) async {
  print('🎯 Model Selection:\n');

  final models = [
    {
      'name': 'llama-3.1-8b-instant',
      'description': 'Fastest model, good quality'
    },
    {
      'name': 'llama-3.1-70b-versatile',
      'description': 'Higher quality, still fast'
    },
    {
      'name': 'mixtral-8x7b-32768',
      'description': 'Large context, multilingual'
    },
    {'name': 'gemma-7b-it', 'description': 'Instruction following'},
  ];

  final question = 'Explain artificial intelligence in 2 sentences.';

  for (final model in models) {
    try {
      print('   Testing ${model['name']}: ${model['description']}');

      final provider = await ai()
          .groq()
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
  print('      • llama-3.1-8b-instant: Best for speed-critical applications');
  print('      • llama-3.1-70b-versatile: When you need higher quality');
  print('      • mixtral-8x7b-32768: For multilingual or large context needs');
  print('      • gemma-7b-it: Good for instruction-following tasks');
  print('   ✅ Model selection demonstration completed\n');
}

/// Demonstrate speed benchmarking
Future<void> demonstrateSpeedBenchmark(String apiKey) async {
  print('⚡ Speed Benchmark:\n');

  try {
    // Create fastest provider
    final provider = await ai()
        .groq()
        .apiKey(apiKey)
        .model('llama-3.1-8b-instant')
        .temperature(0.7)
        .maxTokens(200)
        .build();

    final testQuestions = [
      'What is machine learning?',
      'Explain quantum computing.',
      'What is blockchain?',
      'Define artificial intelligence.',
      'What is cloud computing?',
    ];

    print(
        '   Running speed benchmark with ${testQuestions.length} questions...');

    final times = <int>[];

    for (int i = 0; i < testQuestions.length; i++) {
      final stopwatch = Stopwatch()..start();

      final response =
          await provider.chat([ChatMessage.user(testQuestions[i])]);

      stopwatch.stop();
      times.add(stopwatch.elapsedMilliseconds);

      print('   ${i + 1}. ${testQuestions[i]}');
      print('      Time: ${stopwatch.elapsedMilliseconds}ms');
      print(
          '      Response: ${response.text?.substring(0, response.text!.length > 80 ? 80 : response.text!.length)}...\n');
    }

    // Calculate statistics
    final avgTime = times.reduce((a, b) => a + b) / times.length;
    final minTime = times.reduce((a, b) => a < b ? a : b);
    final maxTime = times.reduce((a, b) => a > b ? a : b);

    print('   📊 Speed Statistics:');
    print('      • Average response time: ${avgTime.toStringAsFixed(1)}ms');
    print('      • Fastest response: ${minTime}ms');
    print('      • Slowest response: ${maxTime}ms');
    print(
        '      • Consistency: ${((maxTime - minTime) / avgTime * 100).toStringAsFixed(1)}% variation');

    print('\n   🚀 Groq Speed Advantages:');
    print('      • Sub-second responses for most queries');
    print('      • Consistent low latency');
    print('      • Excellent for real-time applications');
    print('      • High throughput capabilities');
    print('   ✅ Speed benchmark completed\n');
  } catch (e) {
    print('   ❌ Speed benchmark failed: $e\n');
  }
}

/// Demonstrate basic chat functionality
Future<void> demonstrateBasicChat(String apiKey) async {
  print('💬 Basic Chat Functionality:\n');

  try {
    // Create Groq provider
    final provider = await ai()
        .groq()
        .apiKey(apiKey)
        .model('llama-3.1-8b-instant')
        .temperature(0.7)
        .maxTokens(300)
        .build();

    // Single message
    print('   Single Message:');
    var response =
        await provider.chat([ChatMessage.user('Write a haiku about speed.')]);
    print('      User: Write a haiku about speed.');
    print('      Groq: ${response.text}\n');

    // Conversation with context
    print('   Conversation with Context:');
    final conversation = [
      ChatMessage.system(
          'You are a helpful assistant who gives concise, practical answers.'),
      ChatMessage.user('What are the benefits of fast AI responses?'),
    ];

    response = await provider.chat(conversation);
    print('      System: You are a helpful assistant...');
    print('      User: What are the benefits of fast AI responses?');
    print('      Groq: ${response.text}\n');

    // Follow-up question
    conversation.add(ChatMessage.assistant(response.text ?? ''));
    conversation.add(ChatMessage.user('Give me 3 specific examples.'));

    response = await provider.chat(conversation);
    print('      User: Give me 3 specific examples.');
    print('      Groq: ${response.text}');

    print('   ✅ Basic chat demonstration completed\n');
  } catch (e) {
    print('   ❌ Basic chat failed: $e\n');
  }
}

/// Demonstrate streaming performance
Future<void> demonstrateStreamingPerformance(String apiKey) async {
  print('🌊 Streaming Performance:\n');

  try {
    // Create provider optimized for streaming
    final provider = await ai()
        .groq()
        .apiKey(apiKey)
        .model('llama-3.1-8b-instant')
        .temperature(0.7)
        .maxTokens(400)
        .build();

    final question = 'Write a short story about a robot discovering emotions.';

    print('   Question: $question');
    print('   🤖 Groq (streaming): ');

    final stopwatch = Stopwatch()..start();
    var firstChunkTime = 0;
    var chunkCount = 0;
    var totalChars = 0;

    await for (final event
        in provider.chatStream([ChatMessage.user(question)])) {
      switch (event) {
        case TextDeltaEvent(delta: final delta):
          chunkCount++;
          totalChars += delta.length;

          if (firstChunkTime == 0) {
            firstChunkTime = stopwatch.elapsedMilliseconds;
          }

          stdout.write(delta);
          break;

        case CompletionEvent(response: final response):
          stopwatch.stop();
          print('\n');

          if (response.usage != null) {
            print('   📊 Usage: ${response.usage!.totalTokens} tokens');
          }
          break;

        case ErrorEvent(error: final error):
          print('\n   ❌ Streaming error: $error');
          return;

        case ThinkingDeltaEvent():
        case ToolCallDeltaEvent():
          break;
      }
    }

    print('\n   ⚡ Streaming Performance Metrics:');
    print('      • Time to first chunk: ${firstChunkTime}ms');
    print('      • Total response time: ${stopwatch.elapsedMilliseconds}ms');
    print('      • Chunks received: $chunkCount');
    print('      • Characters streamed: $totalChars');
    print(
        '      • Average chunk size: ${(totalChars / chunkCount).toStringAsFixed(1)} chars');
    print(
        '      • Streaming rate: ${(totalChars * 1000 / stopwatch.elapsedMilliseconds).toStringAsFixed(1)} chars/sec');

    print('\n   🚀 Groq Streaming Benefits:');
    print('      • Ultra-fast time to first token');
    print('      • Smooth, consistent streaming');
    print('      • Excellent for real-time UIs');
    print('      • High character throughput');
    print('   ✅ Streaming performance demonstration completed\n');
  } catch (e) {
    print('   ❌ Streaming demonstration failed: $e\n');
  }
}

/// Demonstrate best practices
Future<void> demonstrateBestPractices(String apiKey) async {
  print('🏆 Best Practices:\n');

  // Error handling
  print('   Error Handling:');
  try {
    final provider = await ai()
        .groq()
        .apiKey('invalid-key') // Intentionally invalid
        .model('llama-3.1-8b-instant')
        .build();

    await provider.chat([ChatMessage.user('Test')]);
  } on AuthError catch (e) {
    print('      ✅ Properly caught AuthError: ${e.message}');
  } catch (e) {
    print('      ⚠️  Unexpected error type: $e');
  }

  // Optimal configuration for speed
  print('\n   Speed-Optimized Configuration:');
  try {
    final speedProvider = await ai()
        .groq()
        .apiKey(apiKey)
        .model('llama-3.1-8b-instant') // Fastest model
        .temperature(0.7) // Balanced creativity
        .maxTokens(300) // Reasonable limit for speed
        .build();

    final response = await speedProvider.chat(
        [ChatMessage.user('Give me 3 quick tips for better productivity.')]);

    print('      ✅ Speed-optimized response: ${response.text}');
  } catch (e) {
    print('      ❌ Speed optimization error: $e');
  }

  // Parallel processing for throughput
  print('\n   Parallel Processing:');
  try {
    final provider = await ai()
        .groq()
        .apiKey(apiKey)
        .model('llama-3.1-8b-instant')
        .temperature(0.7)
        .maxTokens(100)
        .build();

    final questions = [
      'What is AI?',
      'What is ML?',
      'What is NLP?',
    ];

    final stopwatch = Stopwatch()..start();

    final futures =
        questions.map((q) => provider.chat([ChatMessage.user(q)])).toList();

    await Future.wait(futures);
    stopwatch.stop();

    print(
        '      ✅ Processed ${questions.length} questions in ${stopwatch.elapsedMilliseconds}ms');
    print(
        '      Average: ${(stopwatch.elapsedMilliseconds / questions.length).toStringAsFixed(1)}ms per question');
  } catch (e) {
    print('      ❌ Parallel processing error: $e');
  }

  print('\n   💡 Best Practices Summary:');
  print('      • Use llama-3.1-8b-instant for maximum speed');
  print('      • Implement streaming for better user experience');
  print('      • Keep token limits reasonable for faster responses');
  print('      • Use parallel processing for batch operations');
  print('      • Handle errors gracefully with proper types');
  print('      • Monitor response times and optimize accordingly');
  print('   ✅ Best practices demonstration completed\n');
}

/// 🎯 Key Groq Concepts Summary:
///
/// Model Selection:
/// - llama-3.1-8b-instant: Fastest, good for real-time apps
/// - llama-3.1-70b-versatile: Higher quality, still very fast
/// - mixtral-8x7b-32768: Large context, multilingual support
/// - gemma-7b-it: Good instruction following
///
/// Speed Advantages:
/// - Ultra-fast inference (50-200ms typical)
/// - Consistent low latency
/// - High throughput capabilities
/// - Excellent streaming performance
///
/// Best Use Cases:
/// - Real-time chat applications
/// - Interactive assistants
/// - Gaming and entertainment
/// - Live content generation
/// - Voice applications
///
/// Configuration Tips:
/// - Use fastest models for speed-critical apps
/// - Keep token limits reasonable
/// - Implement streaming for better UX
/// - Use parallel processing for throughput
///
/// Next Steps:
/// - speed_optimization.dart: Advanced performance techniques
/// - ../../02_core_features/streaming_chat.dart: Streaming best practices
/// - ../../03_advanced_features/performance_optimization.dart: General optimization
