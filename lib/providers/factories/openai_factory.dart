import '../../core/chat_provider.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';
import '../../models/tool_models.dart';
import '../../models/chat_models.dart';
import '../openai/openai.dart';
import 'base_factory.dart';

/// Factory for creating OpenAI provider instances
class OpenAIProviderFactory
    extends OpenAICompatibleBaseFactory<ChatCapability> {
  @override
  String get providerId => 'openai';

  @override
  String get displayName => 'OpenAI';

  @override
  String get description =>
      'OpenAI GPT models including GPT-4, GPT-3.5, and reasoning models';

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.embedding,
        LLMCapability.modelListing,
        LLMCapability.toolCalling,
        LLMCapability.reasoning,
        LLMCapability.vision,
        LLMCapability.textToSpeech,
        LLMCapability.speechToText,
        LLMCapability.imageGeneration,
      };

  @override
  ChatCapability create(LLMConfig config) {
    return createProviderSafely<OpenAIConfig>(
      config,
      () => _transformConfig(config),
      (openaiConfig) => OpenAIProvider(openaiConfig),
    );
  }

  @override
  Map<String, dynamic> getProviderDefaults() {
    return ProviderDefaults.getDefaults('openai');
  }

  /// Transform unified config to OpenAI-specific config
  OpenAIConfig _transformConfig(LLMConfig config) {
    return OpenAIConfig(
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
      // OpenAI-specific extensions using helper method
      reasoningEffort: ReasoningEffort.fromString(
          getExtension<String>(config, 'reasoningEffort')),
      jsonSchema: getExtension<StructuredOutputFormat>(config, 'jsonSchema'),
      voice: getExtension<String>(config, 'voice'),
      embeddingEncodingFormat:
          getExtension<String>(config, 'embeddingEncodingFormat'),
      embeddingDimensions: getExtension<int>(config, 'embeddingDimensions'),
    );
  }
}
