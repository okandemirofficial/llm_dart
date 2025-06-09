import '../../core/chat_provider.dart';
import '../../core/config.dart';
import '../../core/registry.dart';
import '../../models/tool_models.dart';
import '../xai/xai.dart';

/// Factory for creating XAI provider instances using native XAI interface
class XAIProviderFactory implements LLMProviderFactory<ChatCapability> {
  @override
  String get providerId => 'xai';

  @override
  String get displayName => 'xAI (Grok)';

  @override
  String get description =>
      'xAI Grok models with search and reasoning capabilities';

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.toolCalling,
        LLMCapability.reasoning,
      };

  @override
  ChatCapability create(LLMConfig config) {
    final xaiConfig = _transformConfig(config);
    return XAIProvider(xaiConfig);
  }

  /// Transform unified config to XAI-specific config
  XAIConfig _transformConfig(LLMConfig config) {
    return XAIConfig(
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
      // XAI-specific extensions
      jsonSchema: config.getExtension<StructuredOutputFormat>('jsonSchema'),
      embeddingEncodingFormat:
          config.getExtension<String>('embeddingEncodingFormat'),
      embeddingDimensions: config.getExtension<int>('embeddingDimensions'),
      searchParameters:
          config.getExtension<SearchParameters>('searchParameters'),
    );
  }

  @override
  bool validateConfig(LLMConfig config) {
    // XAI requires an API key
    return config.apiKey != null && config.apiKey!.isNotEmpty;
  }

  @override
  LLMConfig getDefaultConfig() {
    return LLMConfig(
      baseUrl: 'https://api.x.ai/v1/',
      model: 'grok-2-latest',
    );
  }
}
