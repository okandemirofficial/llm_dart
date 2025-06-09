import '../../models/tool_models.dart';
import '../../core/config.dart';

/// Search source configuration for search parameters
class SearchSource {
  /// Type of source: "web" or "news"
  final String sourceType;

  /// List of websites to exclude from this source
  final List<String>? excludedWebsites;

  const SearchSource({required this.sourceType, this.excludedWebsites});

  Map<String, dynamic> toJson() => {
        'type': sourceType,
        if (excludedWebsites != null) 'excluded_websites': excludedWebsites,
      };
}

/// Search parameters for LLM providers that support search functionality
class SearchParameters {
  /// Search mode (e.g., "auto")
  final String? mode;

  /// List of search sources with exclusions
  final List<SearchSource>? sources;

  /// Maximum number of search results to return
  final int? maxSearchResults;

  /// Start date for search results (format: "YYYY-MM-DD")
  final String? fromDate;

  /// End date for search results (format: "YYYY-MM-DD")
  final String? toDate;

  const SearchParameters({
    this.mode,
    this.sources,
    this.maxSearchResults,
    this.fromDate,
    this.toDate,
  });

  Map<String, dynamic> toJson() => {
        if (mode != null) 'mode': mode,
        if (sources != null)
          'sources': sources!.map((s) => s.toJson()).toList(),
        if (maxSearchResults != null) 'max_search_results': maxSearchResults,
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
      };
}

/// xAI provider configuration
///
/// This class contains all configuration options for the xAI providers.
/// It's extracted from the main provider to improve modularity and reusability.
class XAIConfig {
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
  final StructuredOutputFormat? jsonSchema;
  final String? embeddingEncodingFormat;
  final int? embeddingDimensions;
  final SearchParameters? searchParameters;

  const XAIConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.x.ai/v1/',
    this.model = 'grok-2-latest',
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.timeout,
    this.stream = false,
    this.topP,
    this.topK,
    this.tools,
    this.toolChoice,
    this.jsonSchema,
    this.embeddingEncodingFormat,
    this.embeddingDimensions,
    this.searchParameters,
  });

  /// Create XAIConfig from unified LLMConfig
  factory XAIConfig.fromLLMConfig(LLMConfig config) {
    return XAIConfig(
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
      // xAI-specific extensions
      jsonSchema: config.getExtension<StructuredOutputFormat>('jsonSchema'),
      embeddingEncodingFormat:
          config.getExtension<String>('embeddingEncodingFormat'),
      embeddingDimensions: config.getExtension<int>('embeddingDimensions'),
      searchParameters:
          config.getExtension<SearchParameters>('searchParameters'),
    );
  }

  /// Check if this model supports reasoning/thinking
  bool get supportsReasoning {
    // Grok models are designed for reasoning and thinking
    return model.contains('grok');
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // Grok Vision models support vision
    return model.contains('vision') || model.contains('grok-vision');
  }

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // xAI doesn't support tool calling yet
    return false;
  }

  /// Check if this model supports search
  bool get supportsSearch {
    // Grok models have access to real-time information
    return model.contains('grok');
  }

  /// Check if this model supports embeddings
  bool get supportsEmbeddings {
    // xAI provides embedding models
    return model.contains('embed') || model == 'text-embedding-ada-002';
  }

  /// Get the model family
  String get modelFamily {
    if (model.contains('grok')) return 'Grok';
    if (model.contains('embed')) return 'Embedding';
    return 'Unknown';
  }

  XAIConfig copyWith({
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
    StructuredOutputFormat? jsonSchema,
    String? embeddingEncodingFormat,
    int? embeddingDimensions,
    SearchParameters? searchParameters,
  }) =>
      XAIConfig(
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
        jsonSchema: jsonSchema ?? this.jsonSchema,
        embeddingEncodingFormat:
            embeddingEncodingFormat ?? this.embeddingEncodingFormat,
        embeddingDimensions: embeddingDimensions ?? this.embeddingDimensions,
        searchParameters: searchParameters ?? this.searchParameters,
      );
}
