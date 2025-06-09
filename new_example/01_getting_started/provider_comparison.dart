// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🔍 Provider Comparison - Help you choose the best AI provider
///
/// This example will test multiple providers simultaneously, allowing you to intuitively compare:
/// - Response quality
/// - Response speed
/// - Special features
/// - Cost considerations
///
/// Before running, please set the API keys for providers you want to test:
/// export OPENAI_API_KEY="your-key"
/// export ANTHROPIC_API_KEY="your-key"
/// export GROQ_API_KEY="your-key"
/// export DEEPSEEK_API_KEY="your-key"
void main() async {
  print('🔍 AI Provider Comparison Test\n');

  // Test question - shows basic capabilities while highlighting differences
  final testQuestion =
      'Explain artificial intelligence in 3 key points, each point no more than 20 words.';

  print('📝 Test Question: $testQuestion\n');
  print('⏱️  Testing all providers...\n');

  // Create provider list
  final providers = await createProviders();

  // Test all providers in parallel
  final results = <String, ProviderResult>{};

  for (final entry in providers.entries) {
    final name = entry.key;
    final provider = entry.value;

    if (provider != null) {
      final result = await testProvider(name, provider, testQuestion);
      results[name] = result;
    }
  }

  // Display comparison results
  displayComparison(results);

  // Provide selection recommendations
  provideRecommendations(results);
}

/// 创建所有可用的提供商
Future<Map<String, ChatCapability?>> createProviders() async {
  final providers = <String, ChatCapability?>{};

  // OpenAI - 最稳定可靠
  try {
    final openaiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';
    providers['OpenAI'] = await ai()
        .openai()
        .apiKey(openaiKey)
        .model('gpt-4o-mini') // 便宜快速的模型
        .temperature(0.7)
        .build();
  } catch (e) {
    providers['OpenAI'] = null;
    print('⚠️  OpenAI创建失败: $e');
  }

  // Anthropic Claude - 最佳推理
  try {
    final anthropicKey =
        Platform.environment['ANTHROPIC_API_KEY'] ?? 'sk-ant-TESTKEY';
    providers['Anthropic'] = await ai()
        .anthropic()
        .apiKey(anthropicKey)
        .model('claude-3-5-haiku-20241022') // 快速模型
        .temperature(0.7)
        .build();
  } catch (e) {
    providers['Anthropic'] = null;
    print('⚠️  Anthropic创建失败: $e');
  }

  // Groq - 最快速度
  try {
    final groqKey = Platform.environment['GROQ_API_KEY'] ?? 'gsk-TESTKEY';
    providers['Groq'] = await ai()
        .groq()
        .apiKey(groqKey)
        .model('llama-3.1-8b-instant')
        .temperature(0.7)
        .build();
  } catch (e) {
    providers['Groq'] = null;
    print('⚠️  Groq创建失败: $e');
  }

  // DeepSeek - 高性价比
  try {
    final deepseekKey =
        Platform.environment['DEEPSEEK_API_KEY'] ?? 'sk-TESTKEY';
    providers['DeepSeek'] = await ai()
        .deepseek()
        .apiKey(deepseekKey)
        .model('deepseek-chat')
        .temperature(0.7)
        .build();
  } catch (e) {
    providers['DeepSeek'] = null;
    print('⚠️  DeepSeek创建失败: $e');
  }

  // Ollama - 本地免费
  try {
    providers['Ollama'] = await ai()
        .ollama()
        .baseUrl('http://localhost:11434')
        .model('llama3.1')
        .temperature(0.7)
        .build();
  } catch (e) {
    providers['Ollama'] = null;
    print('⚠️  Ollama创建失败: $e');
  }

  return providers;
}

/// 测试单个提供商
Future<ProviderResult> testProvider(
    String name, ChatCapability provider, String question) async {
  final stopwatch = Stopwatch()..start();

  try {
    final messages = [ChatMessage.user(question)];
    final response = await provider.chat(messages);

    stopwatch.stop();

    return ProviderResult(
      name: name,
      success: true,
      response: response.text ?? '无响应',
      responseTime: stopwatch.elapsedMilliseconds,
      usage: response.usage,
      thinking: response.thinking,
    );
  } catch (e) {
    stopwatch.stop();

    return ProviderResult(
      name: name,
      success: false,
      response: '错误: $e',
      responseTime: stopwatch.elapsedMilliseconds,
    );
  }
}

/// 显示对比结果
void displayComparison(Map<String, ProviderResult> results) {
  print('📊 对比结果:\n');

  // 按响应时间排序
  final sortedResults = results.values.toList()
    ..sort((a, b) => a.responseTime.compareTo(b.responseTime));

  for (final result in sortedResults) {
    print('🤖 ${result.name}:');

    if (result.success) {
      print('   ✅ 状态: 成功');
      print('   ⏱️  响应时间: ${result.responseTime}ms');
      print('   💬 回复: ${result.response}');

      if (result.usage != null) {
        print('   📊 Token使用: ${result.usage!.totalTokens}');
      }

      if (result.thinking != null && result.thinking!.isNotEmpty) {
        print('   🧠 思维过程: 可用');
      }
    } else {
      print('   ❌ 状态: 失败');
      print('   💬 错误: ${result.response}');
    }

    print('');
  }
}

/// 提供选择建议
void provideRecommendations(Map<String, ProviderResult> results) {
  print('🎯 选择建议:\n');

  final successfulProviders = results.values.where((r) => r.success).toList();

  if (successfulProviders.isEmpty) {
    print('❌ 没有可用的提供商，请检查API key设置');
    return;
  }

  // 最快的提供商
  final fastest = successfulProviders
      .reduce((a, b) => a.responseTime < b.responseTime ? a : b);
  print('⚡ 最快响应: ${fastest.name} (${fastest.responseTime}ms)');

  // 推荐场景
  print('\n📋 使用场景推荐:');

  for (final result in successfulProviders) {
    switch (result.name) {
      case 'OpenAI':
        print('   🔵 OpenAI: 新手首选，稳定可靠，生态完善');
        break;
      case 'Anthropic':
        print('   🟣 Anthropic: 复杂推理，思维过程，安全性高');
        break;
      case 'Groq':
        print('   🟢 Groq: 实时应用，快速响应，成本较低');
        break;
      case 'DeepSeek':
        print('   🔴 DeepSeek: 高性价比，中文友好，推理能力强');
        break;
      case 'Ollama':
        print('   🟡 Ollama: 本地部署，完全免费，隐私保护');
        break;
    }
  }

  print('\n💡 选择建议:');
  print('   • 新手学习: OpenAI (稳定可靠)');
  print('   • 生产环境: Anthropic (质量最高)');
  print('   • 实时应用: Groq (速度最快)');
  print('   • 成本敏感: DeepSeek (性价比高)');
  print('   • 隐私要求: Ollama (本地部署)');

  print('\n🚀 下一步:');
  print('   • 运行 basic_configuration.dart 学习配置优化');
  print('   • 查看 ../02_core_features/ 了解高级功能');
  print('   • 选择 ../04_providers/ 深入特定提供商');
}

/// 提供商测试结果
class ProviderResult {
  final String name;
  final bool success;
  final String response;
  final int responseTime;
  final UsageInfo? usage;
  final String? thinking;

  ProviderResult({
    required this.name,
    required this.success,
    required this.response,
    required this.responseTime,
    this.usage,
    this.thinking,
  });
}
