import '../../models/tool_models.dart';
import '../../core/config.dart';
import 'package:dio/dio.dart';

/// Phind provider configuration
///
/// This class contains all configuration options for the Phind providers.
/// Phind is a coding-focused AI assistant with specialized models.
class PhindConfig {
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
  final Dio? dioClient;

  /// Reference to original LLMConfig for accessing extensions
  final LLMConfig? _originalConfig;

  const PhindConfig({
    required this.apiKey,
    this.baseUrl = 'https://https.extension.phind.com/agent/',
    this.model = 'Phind-70B',
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

  /// Create PhindConfig from unified LLMConfig
  factory PhindConfig.fromLLMConfig(LLMConfig config) {
    return PhindConfig(
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

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // Phind doesn't support tool calling yet
    return false;
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // Phind doesn't support vision yet
    return false;
  }

  /// Check if this model supports reasoning/thinking
  bool get supportsReasoning {
    // Phind models are designed for coding and reasoning
    return true;
  }

  /// Check if this model supports code generation
  bool get supportsCodeGeneration {
    // Phind is specialized for coding tasks
    return true;
  }

  /// Get the model family
  String get modelFamily {
    if (model.contains('Phind')) return 'Phind';
    return 'Unknown';
  }

  PhindConfig copyWith({
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
      PhindConfig(
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
