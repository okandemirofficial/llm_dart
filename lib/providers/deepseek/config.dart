import '../../models/tool_models.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';

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
      originalConfig: config,
    );
  }

  /// Get extension value from original config
  T? getExtension<T>(String key) => _originalConfig?.getExtension<T>(key);

  /// Check if this model supports reasoning/thinking
  bool get supportsReasoning {
    // DeepSeek R1 models support reasoning
    return model.contains('r1') || model.contains('reasoning');
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // DeepSeek VL models support vision
    return model.contains('vl') || model.contains('vision');
  }

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // Most DeepSeek models support tool calling
    return !model.contains('base');
  }

  /// Check if this model supports code generation
  bool get supportsCodeGeneration {
    // DeepSeek Coder models are optimized for code
    return model.contains('coder') || model.contains('code');
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
      );
}
