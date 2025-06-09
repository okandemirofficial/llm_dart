import '../../models/tool_models.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';

/// Ollama provider configuration
///
/// This class contains all configuration options for the Ollama providers.
/// It's extracted from the main provider to improve modularity and reusability.
class OllamaConfig {
  final String baseUrl;
  final String? apiKey;
  final String model;
  final int? maxTokens;
  final double? temperature;
  final String? systemPrompt;
  final Duration? timeout;

  final double? topP;
  final int? topK;
  final List<Tool>? tools;
  final StructuredOutputFormat? jsonSchema;

  const OllamaConfig({
    this.baseUrl = ProviderDefaults.ollamaBaseUrl,
    this.apiKey,
    this.model = ProviderDefaults.ollamaDefaultModel,
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.timeout,
    this.topP,
    this.topK,
    this.tools,
    this.jsonSchema,
  });

  /// Create OllamaConfig from unified LLMConfig
  factory OllamaConfig.fromLLMConfig(LLMConfig config) {
    return OllamaConfig(
      baseUrl: config.baseUrl,
      apiKey: config.apiKey,
      model: config.model,
      maxTokens: config.maxTokens,
      temperature: config.temperature,
      systemPrompt: config.systemPrompt,
      timeout: config.timeout,

      topP: config.topP,
      topK: config.topK,
      tools: config.tools,
      // Ollama-specific extensions
      jsonSchema: config.getExtension<StructuredOutputFormat>('jsonSchema'),
    );
  }

  /// Check if this model supports reasoning/thinking
  bool get supportsReasoning {
    // Some Ollama models support reasoning, especially newer ones
    return model.contains('reasoning') ||
        model.contains('think') ||
        model.contains('qwen2.5');
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // Ollama supports vision through specific models
    return model.contains('vision') ||
        model.contains('llava') ||
        model.contains('minicpm') ||
        model.contains('moondream');
  }

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // Many Ollama models support tool calling
    return model.contains('llama3') ||
        model.contains('mistral') ||
        model.contains('qwen') ||
        model.contains('phi3');
  }

  /// Check if this model supports embeddings
  bool get supportsEmbeddings {
    // Embedding models in Ollama
    return model.contains('embed') ||
        model.contains('nomic') ||
        model.contains('mxbai') ||
        model.contains('all-minilm');
  }

  /// Check if this model supports code generation
  bool get supportsCodeGeneration {
    // Code-focused models
    return model.contains('codellama') ||
        model.contains('codegemma') ||
        model.contains('starcoder') ||
        model.contains('deepseek-coder');
  }

  /// Check if this is a local deployment
  bool get isLocal {
    return baseUrl.contains('localhost') ||
        baseUrl.contains('127.0.0.1') ||
        baseUrl.contains('0.0.0.0');
  }

  /// Get the model family
  String get modelFamily {
    if (model.contains('llama')) return 'Llama';
    if (model.contains('mistral')) return 'Mistral';
    if (model.contains('qwen')) return 'Qwen';
    if (model.contains('phi')) return 'Phi';
    if (model.contains('gemma')) return 'Gemma';
    if (model.contains('codellama')) return 'Code Llama';
    if (model.contains('llava')) return 'LLaVA';
    return 'Unknown';
  }

  OllamaConfig copyWith({
    String? baseUrl,
    String? apiKey,
    String? model,
    int? maxTokens,
    double? temperature,
    String? systemPrompt,
    Duration? timeout,
    double? topP,
    int? topK,
    List<Tool>? tools,
    StructuredOutputFormat? jsonSchema,
  }) =>
      OllamaConfig(
        baseUrl: baseUrl ?? this.baseUrl,
        apiKey: apiKey ?? this.apiKey,
        model: model ?? this.model,
        maxTokens: maxTokens ?? this.maxTokens,
        temperature: temperature ?? this.temperature,
        systemPrompt: systemPrompt ?? this.systemPrompt,
        timeout: timeout ?? this.timeout,
        topP: topP ?? this.topP,
        topK: topK ?? this.topK,
        tools: tools ?? this.tools,
        jsonSchema: jsonSchema ?? this.jsonSchema,
      );
}
