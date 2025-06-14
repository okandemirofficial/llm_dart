import '../../builder/llm_builder.dart';
import '../../core/capability.dart';
import '../../models/chat_models.dart';
import 'config.dart';

/// Google-specific LLM builder with provider-specific configuration methods
///
/// This builder provides a layered configuration approach where Google-specific
/// parameters are handled separately from the generic LLMBuilder, keeping the
/// main builder clean and focused.
///
/// Use this for Google-specific parameters only. For common parameters like
/// apiKey, model, temperature, etc., continue using the base LLMBuilder methods.
class GoogleLLMBuilder {
  final LLMBuilder _baseBuilder;

  GoogleLLMBuilder(this._baseBuilder);

  // ========== Google-specific configuration methods ==========

  /// Sets the task type for embeddings
  ///
  /// Supported values:
  /// - 'SEMANTIC_SIMILARITY' - For semantic similarity tasks
  /// - 'RETRIEVAL_QUERY' - For search queries
  /// - 'RETRIEVAL_DOCUMENT' - For documents to be searched
  /// - 'CLASSIFICATION' - For classification tasks
  /// - 'CLUSTERING' - For clustering tasks
  /// - 'QUESTION_ANSWERING' - For Q&A tasks
  /// - 'FACT_VERIFICATION' - For fact checking
  /// - 'CODE_RETRIEVAL_QUERY' - For code search queries
  GoogleLLMBuilder embeddingTaskType(String taskType) {
    _baseBuilder.extension('embeddingTaskType', taskType);
    return this;
  }

  /// Sets the title for embedding documents (only for RETRIEVAL_DOCUMENT task type)
  ///
  /// Providing a title can improve embedding quality for retrieval tasks.
  GoogleLLMBuilder embeddingTitle(String title) {
    _baseBuilder.extension('embeddingTitle', title);
    return this;
  }

  /// Sets the output dimensionality for embeddings
  ///
  /// If set, the output embedding will be truncated to this dimension.
  /// Only supported by newer models (not models/embedding-001).
  GoogleLLMBuilder embeddingDimensions(int dimensions) {
    _baseBuilder.extension('embeddingDimensions', dimensions);
    return this;
  }

  /// Sets the reasoning effort for models that support it
  ///
  /// Valid values: ReasoningEffort.low, ReasoningEffort.medium, ReasoningEffort.high
  GoogleLLMBuilder reasoningEffort(ReasoningEffort effort) {
    _baseBuilder.extension('reasoningEffort', effort);
    return this;
  }

  /// Sets thinking budget tokens for reasoning models
  GoogleLLMBuilder thinkingBudgetTokens(int tokens) {
    _baseBuilder.extension('thinkingBudgetTokens', tokens);
    return this;
  }

  /// Enables or disables including thoughts in the response
  GoogleLLMBuilder includeThoughts(bool include) {
    _baseBuilder.extension('includeThoughts', include);
    return this;
  }

  /// Enables image generation capability
  GoogleLLMBuilder enableImageGeneration(bool enable) {
    _baseBuilder.extension('enableImageGeneration', enable);
    return this;
  }

  /// Sets response modalities (e.g., ['TEXT', 'IMAGE'])
  GoogleLLMBuilder responseModalities(List<String> modalities) {
    _baseBuilder.extension('responseModalities', modalities);
    return this;
  }

  /// Sets safety settings for content filtering
  GoogleLLMBuilder safetySettings(List<SafetySetting> settings) {
    _baseBuilder.extension('safetySettings', settings);
    return this;
  }

  /// Sets maximum inline data size (default: 20MB)
  GoogleLLMBuilder maxInlineDataSize(int size) {
    _baseBuilder.extension('maxInlineDataSize', size);
    return this;
  }

  /// Sets candidate count for response generation
  GoogleLLMBuilder candidateCount(int count) {
    _baseBuilder.extension('candidateCount', count);
    return this;
  }

  /// Sets stop sequences for response generation
  GoogleLLMBuilder stopSequences(List<String> sequences) {
    _baseBuilder.extension('stopSequences', sequences);
    return this;
  }

  // ========== Convenience methods for common embedding configurations ==========

  /// Configure for semantic similarity tasks
  GoogleLLMBuilder forSemanticSimilarity({int? dimensions}) {
    embeddingTaskType('SEMANTIC_SIMILARITY');
    if (dimensions != null) {
      embeddingDimensions(dimensions);
    }
    return this;
  }

  /// Configure for document retrieval
  GoogleLLMBuilder forDocumentRetrieval({String? title, int? dimensions}) {
    embeddingTaskType('RETRIEVAL_DOCUMENT');
    if (title != null) {
      embeddingTitle(title);
    }
    if (dimensions != null) {
      embeddingDimensions(dimensions);
    }
    return this;
  }

  /// Configure for search queries
  GoogleLLMBuilder forSearchQuery({int? dimensions}) {
    embeddingTaskType('RETRIEVAL_QUERY');
    if (dimensions != null) {
      embeddingDimensions(dimensions);
    }
    return this;
  }

  /// Configure for classification tasks
  GoogleLLMBuilder forClassification({int? dimensions}) {
    embeddingTaskType('CLASSIFICATION');
    if (dimensions != null) {
      embeddingDimensions(dimensions);
    }
    return this;
  }

  /// Configure for clustering tasks
  GoogleLLMBuilder forClustering({int? dimensions}) {
    embeddingTaskType('CLUSTERING');
    if (dimensions != null) {
      embeddingDimensions(dimensions);
    }
    return this;
  }

  // ========== Build methods ==========

  /// Builds and returns a configured LLM provider instance
  Future<ChatCapability> build() async {
    return _baseBuilder.build();
  }

  /// Builds a provider with EmbeddingCapability
  Future<EmbeddingCapability> buildEmbedding() async {
    return _baseBuilder.buildEmbedding();
  }

  /// Builds a provider with ModelListingCapability
  Future<ModelListingCapability> buildModelListing() async {
    return _baseBuilder.buildModelListing();
  }

  /// Builds a provider with ImageGenerationCapability
  Future<ImageGenerationCapability> buildImageGeneration() async {
    return _baseBuilder.buildImageGeneration();
  }
}
