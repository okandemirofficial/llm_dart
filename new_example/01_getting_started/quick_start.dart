// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🚀 5-Minute Quick Start - Your First AI Conversation
///
/// This example demonstrates the most basic usage of LLM Dart:
/// 1. Create an AI provider
/// 2. Send messages
/// 3. Get responses
///
/// Before running, please set environment variables:
/// export OPENAI_API_KEY="your-key"
/// export GROQ_API_KEY="your-key"
void main() async {
  print('🚀 LLM Dart - 5-Minute Quick Start\n');

  // 🎯 Method 1: Using OpenAI (recommended for beginners)
  await quickStartWithOpenAI();

  // 🎯 Method 2: Using Groq (free and fast)
  await quickStartWithGroq();

  // 🎯 Method 3: Using local Ollama (completely free)
  await quickStartWithOllama();

  print('\n✅ Quick start completed!');
  print(
      '📖 Next step: Run provider_comparison.dart to learn about more providers');
}

/// Use OpenAI for your first conversation
Future<void> quickStartWithOpenAI() async {
  print('🤖 Method 1: Using OpenAI');

  try {
    // Get API key
    final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';

    // Create AI provider - it's that simple!
    final provider = await ai()
        .openai() // Choose OpenAI
        .apiKey(apiKey) // Set API key
        .model('gpt-4o-mini') // Choose model (cheap and fast)
        .temperature(0.7) // Set creativity (0-1)
        .build();

    // Send your first message
    final messages = [
      ChatMessage.user('Hello! Please introduce yourself in one sentence.')
    ];

    // Get AI response
    final response = await provider.chat(messages);

    print('   AI Reply: ${response.text}');
    print('   ✅ OpenAI call successful\n');
  } catch (e) {
    print('   ❌ OpenAI call failed: $e');
    print('   💡 Please check OPENAI_API_KEY environment variable\n');
  }
}

/// Use Groq for fast conversation
Future<void> quickStartWithGroq() async {
  print('⚡ Method 2: Using Groq (super fast)');

  try {
    // Get API key
    final apiKey = Platform.environment['GROQ_API_KEY'] ?? 'gsk-TESTKEY';

    // Create Groq provider
    final provider = await ai()
        .groq() // Choose Groq
        .apiKey(apiKey) // Set API key
        .model('llama-3.1-8b-instant') // Fast model
        .temperature(0.7)
        .build();

    // Send message
    final messages = [
      ChatMessage.user('What is the capital of France? Answer in one sentence.')
    ];

    final response = await provider.chat(messages);

    print('   AI Reply: ${response.text}');
    print('   ✅ Groq call successful (notice the speed!)\n');
  } catch (e) {
    print('   ❌ Groq call failed: $e');
    print('   💡 Please check GROQ_API_KEY environment variable\n');
  }
}

/// Use local Ollama (completely free)
Future<void> quickStartWithOllama() async {
  print('🏠 Method 3: Using local Ollama (free)');

  try {
    // Create Ollama provider (no API key needed)
    final provider = await ai()
        .ollama() // Choose Ollama
        .baseUrl('http://localhost:11434') // Local address
        .model('llama3.1') // Local model
        .temperature(0.7)
        .build();

    // Send message
    final messages = [
      ChatMessage.user('Hello! Introduce yourself in one sentence.')
    ];

    final response = await provider.chat(messages);

    print('   AI Reply: ${response.text}');
    print('   ✅ Ollama call successful (completely local!)\n');
  } catch (e) {
    print('   ❌ Ollama call failed: $e');
    print('   💡 Please ensure Ollama is running: ollama serve');
    print('   💡 And install model: ollama pull llama3.1\n');
  }
}

/// 🎯 Key Points Summary:
///
/// 1. Three creation methods:
///    - ai().openai()    - Type-safe provider method
///    - ai().provider()  - Generic provider method
///    - createProvider() - Convenience function
///
/// 2. Basic configuration:
///    - apiKey: API key
///    - model: Model name
///    - temperature: Creativity (0-1)
///    - maxTokens: Maximum output length
///
/// 3. Sending messages:
///    - ChatMessage.user() - User message
///    - ChatMessage.system() - System prompt
///    - ChatMessage.assistant() - AI reply
///
/// 4. Getting responses:
///    - response.text - Text content
///    - response.usage - Usage statistics
///    - response.thinking - Thinking process (some models)
///
/// 🚀 Next steps:
/// - Run provider_comparison.dart to compare different providers
/// - Check basic_configuration.dart to learn more configurations
/// - Explore ../02_core_features/ for advanced features
