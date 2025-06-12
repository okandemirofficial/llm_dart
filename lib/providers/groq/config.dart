import '../../models/tool_models.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';
import 'package:dio/dio.dart';

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

  /// Custom Dio instance for HTTP requests
  ///
  /// If provided, this Dio instance will be used for all HTTP requests
  /// instead of creating a default one. This allows for custom interceptors,
  /// proxy settings, certificates, and other advanced HTTP configurations.
  final Dio? dioClient;

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
    this.dioClient,
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
      dioClient: config.dioClient,
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
    // Based on Groq documentation, these models support tool calling:
    // - meta-llama/llama-4-scout-17b-16e-instruct
    // - meta-llama/llama-4-maverick-17b-128e-instruct
    // - qwen-qwq-32b
    // - deepseek-r1-distill-qwen-32b
    // - deepseek-r1-distill-llama-70b
    // - llama-3.3-70b-versatile
    // - llama-3.1-8b-instant
    // - gemma2-9b-it

    // Base models don't support tool calling
    if (model.contains('-base')) {
      return false;
    }

    // Models that support tool calling
    final supportedModels = [
      'llama-4-scout',
      'llama-4-maverick',
      'qwen-qwq',
      'deepseek-r1-distill',
      'llama-3.3',
      'llama-3.1',
      'gemma2-9b-it',
    ];

    return supportedModels
        .any((supportedModel) => model.contains(supportedModel));
  }

  /// Check if this model supports parallel tool calling
  bool get supportsParallelToolCalling {
    // Based on Groq documentation, these models support parallel tool calling:
    // All tool-calling models except gemma2-9b-it support parallel tool use
    return supportsToolCalling && !model.contains('gemma2-9b-it');
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
    Dio? dioClient,
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
        dioClient: dioClient ?? this.dioClient,
      );
}
