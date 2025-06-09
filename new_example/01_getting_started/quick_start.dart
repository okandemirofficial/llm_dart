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

/// 使用本地Ollama (完全免费)
Future<void> quickStartWithOllama() async {
  print('🏠 方法3：使用本地Ollama (免费)');

  try {
    // 创建Ollama提供商 (不需要API key)
    final provider = await ai()
        .ollama() // 选择Ollama
        .baseUrl('http://localhost:11434') // 本地地址
        .model('llama3.1') // 本地模型
        .temperature(0.7)
        .build();

    // 发送消息
    final messages = [
      ChatMessage.user('Hello! Introduce yourself in one sentence.')
    ];

    final response = await provider.chat(messages);

    print('   AI回复: ${response.text}');
    print('   ✅ Ollama调用成功 (完全本地！)\n');
  } catch (e) {
    print('   ❌ Ollama调用失败: $e');
    print('   💡 请确保Ollama正在运行: ollama serve');
    print('   💡 并安装模型: ollama pull llama3.1\n');
  }
}

/// 🎯 关键要点总结：
///
/// 1. 三种创建方式：
///    - ai().openai()    - 类型安全的提供商方法
///    - ai().provider()  - 通用的提供商方法
///    - createProvider() - 便捷函数
///
/// 2. 基础配置：
///    - apiKey: API密钥
///    - model: 模型名称
///    - temperature: 创造性 (0-1)
///    - maxTokens: 最大输出长度
///
/// 3. 发送消息：
///    - ChatMessage.user() - 用户消息
///    - ChatMessage.system() - 系统提示
///    - ChatMessage.assistant() - AI回复
///
/// 4. 获取响应：
///    - response.text - 文本内容
///    - response.usage - 使用统计
///    - response.thinking - 思维过程 (部分模型)
///
/// 🚀 下一步：
/// - 运行 provider_comparison.dart 对比不同提供商
/// - 查看 basic_configuration.dart 学习更多配置
/// - 探索 ../02_core_features/ 了解高级功能
