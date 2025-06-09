import '../../core/chat_provider.dart';
import '../../core/config.dart';
import '../../core/registry.dart';
import '../phind/phind.dart';

/// Factory for creating Phind provider instances using native Phind interface
class PhindProviderFactory implements LLMProviderFactory<ChatCapability> {
  @override
  String get providerId => 'phind';

  @override
  String get displayName => 'Phind';

  @override
  String get description =>
      'Phind AI models specialized for coding assistance and development tasks';

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.toolCalling,
      };

  @override
  ChatCapability create(LLMConfig config) {
    final phindConfig = _transformConfig(config);
    return PhindProvider(phindConfig);
  }

  /// Transform unified config to Phind-specific config
  PhindConfig _transformConfig(LLMConfig config) {
    return PhindConfig(
      apiKey: config.apiKey!,
      baseUrl: config.baseUrl,
      model: config.model,
      maxTokens: config.maxTokens,
      temperature: config.temperature,
      systemPrompt: config.systemPrompt,
      timeout: config.timeout,
      topP: config.topP,
      topK: config.topK,
      tools: config.tools,
      toolChoice: config.toolChoice,
    );
  }

  @override
  bool validateConfig(LLMConfig config) {
    // Phind requires an API key
    return config.apiKey != null && config.apiKey!.isNotEmpty;
  }

  @override
  LLMConfig getDefaultConfig() {
    return LLMConfig(
      baseUrl: 'https://https.extension.phind.com/agent/',
      model: 'Phind-70B',
    );
  }
}
