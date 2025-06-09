import '../../core/chat_provider.dart';
import '../../core/config.dart';
import '../../core/registry.dart';
import '../groq/groq.dart';

/// Factory for creating Groq provider instances
class GroqProviderFactory implements LLMProviderFactory<ChatCapability> {
  @override
  String get providerId => 'groq';

  @override
  String get displayName => 'Groq';

  @override
  String get description => 'Groq AI models for ultra-fast inference';

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.toolCalling,
      };

  @override
  ChatCapability create(LLMConfig config) {
    final groqConfig = _transformConfig(config);
    return GroqProvider(groqConfig);
  }

  /// Transform unified config to Groq-specific config
  GroqConfig _transformConfig(LLMConfig config) {
    return GroqConfig(
      apiKey: config.apiKey!,
      baseUrl: config.baseUrl,
      model: config.model,
      maxTokens: config.maxTokens,
      temperature: config.temperature,
      systemPrompt: config.systemPrompt,
      timeout: config.timeout,
      stream: config.stream,
      topP: config.topP,
      topK: config.topK,
      tools: config.tools,
      toolChoice: config.toolChoice,
    );
  }

  @override
  bool validateConfig(LLMConfig config) {
    // Groq requires an API key
    return config.apiKey != null && config.apiKey!.isNotEmpty;
  }

  @override
  LLMConfig getDefaultConfig() {
    return LLMConfig(
      baseUrl: 'https://api.groq.com/openai/v1/',
      model: 'llama-3.1-70b-versatile',
    );
  }
}
