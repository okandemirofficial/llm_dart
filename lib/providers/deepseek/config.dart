import '../../models/tool_models.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';
import 'package:dio/dio.dart';

/// DeepSeek provider configuration
///
/// This class contains all configuration options for the DeepSeek providers.
/// It's extracted from the main provider to improve modularity and reusability.
class DeepSeekConfig {
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

  // DeepSeek-specific parameters
  final bool? logprobs;
  final int? topLogprobs;
  final double? frequencyPenalty;
  final double? presencePenalty;
  final Map<String, dynamic>? responseFormat;
  final Dio? dioClient;

  /// Reference to original LLMConfig for accessing extensions
  final LLMConfig? _originalConfig;

  const DeepSeekConfig({
    required this.apiKey,
    this.baseUrl = ProviderDefaults.deepseekBaseUrl,
    this.model = ProviderDefaults.deepseekDefaultModel,
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.timeout,
    this.topP,
    this.topK,
    this.tools,
    this.toolChoice,
    this.logprobs,
    this.topLogprobs,
    this.frequencyPenalty,
    this.presencePenalty,
    this.responseFormat,
    this.dioClient,
    LLMConfig? originalConfig,
  }) : _originalConfig = originalConfig;

  /// Create DeepSeekConfig from unified LLMConfig
  factory DeepSeekConfig.fromLLMConfig(LLMConfig config) {
    return DeepSeekConfig(
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
      // DeepSeek-specific parameters from extensions
      logprobs: config.getExtension<bool>('logprobs'),
      topLogprobs: config.getExtension<int>('top_logprobs'),
      frequencyPenalty: config.getExtension<double>('frequency_penalty'),
      presencePenalty: config.getExtension<double>('presence_penalty'),
      responseFormat:
          config.getExtension<Map<String, dynamic>>('response_format'),
      dioClient: config.dioClient,
      originalConfig: config,
    );
  }

  /// Get extension value from original config
  T? getExtension<T>(String key) => _originalConfig?.getExtension<T>(key);

  /// Check if this model supports reasoning/thinking
  bool get supportsReasoning {
    // DeepSeek reasoner model supports reasoning
    // Reference: https://api-docs.deepseek.com/api/create-chat-completion
    return model == 'deepseek-reasoner';
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // Currently no vision models available in DeepSeek API
    // Reference: https://api-docs.deepseek.com/api/list-models
    return false;
  }

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // Both deepseek-chat and deepseek-reasoner support tool calling
    // Reference: https://api-docs.deepseek.com/guides/function_calling
    return model == 'deepseek-chat' || model == 'deepseek-reasoner';
  }

  /// Check if this model supports code generation
  bool get supportsCodeGeneration {
    // Both models can handle code generation tasks
    return model == 'deepseek-chat' || model == 'deepseek-reasoner';
  }

  DeepSeekConfig copyWith({
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
    bool? logprobs,
    int? topLogprobs,
    double? frequencyPenalty,
    double? presencePenalty,
    Map<String, dynamic>? responseFormat,
    Dio? dioClient,
  }) =>
      DeepSeekConfig(
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
        logprobs: logprobs ?? this.logprobs,
        topLogprobs: topLogprobs ?? this.topLogprobs,
        frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
        presencePenalty: presencePenalty ?? this.presencePenalty,
        responseFormat: responseFormat ?? this.responseFormat,
        dioClient: dioClient ?? this.dioClient,
      );
}
