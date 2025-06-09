import '../../models/tool_models.dart';
import '../../core/config.dart';

/// Groq provider configuration
///
/// This class contains all configuration options for the Groq providers.
/// It's extracted from the main provider to improve modularity and reusability.
class GroqConfig {
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

  const GroqConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.groq.com/openai/v1/',
    this.model = 'llama-3.3-70b-versatile',
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

  /// Create GroqConfig from unified LLMConfig
  factory GroqConfig.fromLLMConfig(LLMConfig config) {
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

  /// Check if this model supports reasoning/thinking
  bool get supportsReasoning {
    // Groq doesn't currently support reasoning models
    return false;
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // Groq supports vision through Llama Vision models
    return model.contains('vision') || model.contains('llava');
  }

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // Most Groq models support tool calling
    return !model.contains('base');
  }

  /// Check if this model is optimized for speed
  bool get isSpeedOptimized {
    // Groq is known for fast inference
    return true;
  }

  /// Get the model family
  String get modelFamily {
    if (model.contains('llama')) return 'Llama';
    if (model.contains('mixtral')) return 'Mixtral';
    if (model.contains('gemma')) return 'Gemma';
    if (model.contains('whisper')) return 'Whisper';
    return 'Unknown';
  }

  GroqConfig copyWith({
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
      GroqConfig(
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
