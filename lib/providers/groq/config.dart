import '../../models/tool_models.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';

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

  final double? topP;
  final int? topK;
  final List<Tool>? tools;
  final ToolChoice? toolChoice;

  /// Reference to original LLMConfig for accessing extensions
  final LLMConfig? _originalConfig;

  const GroqConfig({
    required this.apiKey,
    this.baseUrl = ProviderDefaults.groqBaseUrl,
    this.model = ProviderDefaults.groqDefaultModel,
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
        topP: topP ?? this.topP,
        topK: topK ?? this.topK,
        tools: tools ?? this.tools,
        toolChoice: toolChoice ?? this.toolChoice,
      );
}
