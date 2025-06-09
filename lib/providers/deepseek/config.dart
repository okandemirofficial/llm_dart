import '../../models/tool_models.dart';
import '../../core/config.dart';

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
  final bool stream;
  final double? topP;
  final int? topK;
  final List<Tool>? tools;
  final ToolChoice? toolChoice;

  const DeepSeekConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.deepseek.com/v1/',
    this.model = 'deepseek-chat',
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.timeout,
    this.stream = false,
    this.topP,
    this.topK,
    this.tools,
    this.toolChoice,
  });

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
      stream: config.stream,
      topP: config.topP,
      topK: config.topK,
      tools: config.tools,
      toolChoice: config.toolChoice,
    );
  }

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
    bool? stream,
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
        stream: stream ?? this.stream,
        topP: topP ?? this.topP,
        topK: topK ?? this.topK,
        tools: tools ?? this.tools,
        toolChoice: toolChoice ?? this.toolChoice,
      );
}
