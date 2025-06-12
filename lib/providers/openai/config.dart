import '../../models/tool_models.dart';
import '../../models/chat_models.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';
import 'package:dio/dio.dart';

/// OpenAI provider configuration
///
/// This class contains all configuration options for the OpenAI providers.
/// It's extracted from the main provider to improve modularity and reusability.
class OpenAIConfig {
  final String apiKey;
  final String baseUrl;
  final String model;
  final int? maxTokens;
  final double? temperature;
  final String? systemPrompt;
  final Duration? timeout;

  final double? topP;
  final int? topK;
  final List<Tool>? tools;
  final ToolChoice? toolChoice;
  final ReasoningEffort? reasoningEffort;
  final StructuredOutputFormat? jsonSchema;
  final String? voice;
  final String? embeddingEncodingFormat;
  final int? embeddingDimensions;
  final List<String>? stopSequences;
  final String? user;
  final ServiceTier? serviceTier;
  final Dio? dioClient;

  /// Reference to original LLMConfig for accessing extensions
  final LLMConfig? _originalConfig;

  const OpenAIConfig({
    required this.apiKey,
    this.baseUrl = ProviderDefaults.openaiBaseUrl,
    this.model = ProviderDefaults.openaiDefaultModel,
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.timeout,
    this.topP,
    this.topK,
    this.tools,
    this.toolChoice,
    this.reasoningEffort,
    this.jsonSchema,
    this.voice,
    this.embeddingEncodingFormat,
    this.embeddingDimensions,
    this.stopSequences,
    this.user,
    this.serviceTier,
    this.dioClient,
    LLMConfig? originalConfig,
  }) : _originalConfig = originalConfig;

  /// Create OpenAIConfig from unified LLMConfig
  factory OpenAIConfig.fromLLMConfig(LLMConfig config) {
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
      stopSequences: config.stopSequences,
      user: config.user,
      serviceTier: config.serviceTier,
      dioClient: config.dioClient,
      // OpenAI-specific extensions
      reasoningEffort: config.getExtension<ReasoningEffort>('reasoningEffort'),
      jsonSchema: config.getExtension<StructuredOutputFormat>('jsonSchema'),
      voice: config.getExtension<String>('voice'),
      embeddingEncodingFormat:
          config.getExtension<String>('embeddingEncodingFormat'),
      embeddingDimensions: config.getExtension<int>('embeddingDimensions'),
      originalConfig: config,
    );
  }

  /// Get extension value from original config
  T? getExtension<T>(String key) => _originalConfig?.getExtension<T>(key);

  OpenAIConfig copyWith({
    String? apiKey,
    String? baseUrl,
    String? model,
    int? maxTokens,
    double? temperature,
    String? systemPrompt,
    Duration? timeout,
    double? topP,
    int? topK,
    List<Tool>? tools,
    ToolChoice? toolChoice,
    ReasoningEffort? reasoningEffort,
    StructuredOutputFormat? jsonSchema,
    String? voice,
    String? embeddingEncodingFormat,
    int? embeddingDimensions,
    List<String>? stopSequences,
    String? user,
    ServiceTier? serviceTier,
    Dio? dioClient,
  }) =>
      OpenAIConfig(
        apiKey: apiKey ?? this.apiKey,
        baseUrl: baseUrl ?? this.baseUrl,
        model: model ?? this.model,
        maxTokens: maxTokens ?? this.maxTokens,
        temperature: temperature ?? this.temperature,
        systemPrompt: systemPrompt ?? this.systemPrompt,
        timeout: timeout ?? this.timeout,
        topP: topP ?? this.topP,
        topK: topK ?? this.topK,
        tools: tools ?? this.tools,
        toolChoice: toolChoice ?? this.toolChoice,
        reasoningEffort: reasoningEffort ?? this.reasoningEffort,
        jsonSchema: jsonSchema ?? this.jsonSchema,
        voice: voice ?? this.voice,
        embeddingEncodingFormat:
            embeddingEncodingFormat ?? this.embeddingEncodingFormat,
        embeddingDimensions: embeddingDimensions ?? this.embeddingDimensions,
        stopSequences: stopSequences ?? this.stopSequences,
        user: user ?? this.user,
        serviceTier: serviceTier ?? this.serviceTier,
        dioClient: dioClient ?? this.dioClient,
      );

  @override
  String toString() {
    return 'OpenAIConfig('
        'model: $model, '
        'baseUrl: $baseUrl, '
        'maxTokens: $maxTokens, '
        'temperature: $temperature'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpenAIConfig &&
        other.apiKey == apiKey &&
        other.baseUrl == baseUrl &&
        other.model == model &&
        other.maxTokens == maxTokens &&
        other.temperature == temperature &&
        other.systemPrompt == systemPrompt &&
        other.timeout == timeout &&
        other.topP == topP &&
        other.topK == topK &&
        other.tools == tools &&
        other.toolChoice == toolChoice &&
        other.reasoningEffort == reasoningEffort &&
        other.jsonSchema == jsonSchema &&
        other.voice == voice &&
        other.embeddingEncodingFormat == embeddingEncodingFormat &&
        other.embeddingDimensions == embeddingDimensions &&
        other.stopSequences == stopSequences &&
        other.user == user &&
        other.serviceTier == serviceTier;
  }

  @override
  int get hashCode {
    return Object.hash(
      apiKey,
      baseUrl,
      model,
      maxTokens,
      temperature,
      systemPrompt,
      timeout,
      topP,
      topK,
      tools,
      toolChoice,
      reasoningEffort,
      jsonSchema,
      voice,
      embeddingEncodingFormat,
      embeddingDimensions,
      stopSequences,
      user,
      serviceTier,
    );
  }
}
