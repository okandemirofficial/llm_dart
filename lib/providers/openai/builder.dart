import '../../builder/llm_builder.dart';
import '../../core/capability.dart';
import '../../core/web_search.dart';

/// OpenAI-specific LLM builder with provider-specific configuration methods
///
/// This builder provides a layered configuration approach where OpenAI-specific
/// parameters are handled separately from the generic LLMBuilder, keeping the
/// main builder clean and focused.
///
/// Use this for OpenAI-specific parameters only. For common parameters like
/// apiKey, model, temperature, etc., continue using the base LLMBuilder methods.
class OpenAIBuilder {
  final LLMBuilder _baseBuilder;

  OpenAIBuilder(this._baseBuilder);

  // ========== OpenAI-specific configuration methods ==========

  /// Sets frequency penalty for reducing repetition (-2.0 to 2.0)
  ///
  /// Positive values penalize new tokens based on their existing frequency
  /// in the text so far, decreasing the model's likelihood to repeat the
  /// same line verbatim.
  ///
  /// - Negative values: Encourage repetition
  /// - 0.0: No penalty (default)
  /// - Positive values: Discourage repetition
  /// - Range: -2.0 to 2.0
  OpenAIBuilder frequencyPenalty(double penalty) {
    _baseBuilder.extension('frequencyPenalty', penalty);
    return this;
  }

  /// Sets presence penalty for encouraging topic diversity (-2.0 to 2.0)
  ///
  /// Positive values penalize new tokens based on whether they appear
  /// in the text so far, increasing the model's likelihood to talk about
  /// new topics.
  ///
  /// - Negative values: Encourage staying on topic
  /// - 0.0: No penalty (default)
  /// - Positive values: Encourage new topics
  /// - Range: -2.0 to 2.0
  OpenAIBuilder presencePenalty(double penalty) {
    _baseBuilder.extension('presencePenalty', penalty);
    return this;
  }

  /// Sets logit bias for specific tokens
  ///
  /// Modify the likelihood of specified tokens appearing in the completion.
  /// Maps tokens (specified by their token ID) to an associated bias value
  /// from -100 to 100.
  ///
  /// - -100: Token is banned
  /// - 0: No bias (default)
  /// - 100: Token is strongly encouraged
  OpenAIBuilder logitBias(Map<String, double> bias) {
    _baseBuilder.extension('logitBias', bias);
    return this;
  }

  /// Sets seed for deterministic outputs
  ///
  /// If specified, the system will make a best effort to sample
  /// deterministically, such that repeated requests with the same seed
  /// and parameters should return the same result.
  OpenAIBuilder seed(int seedValue) {
    _baseBuilder.extension('seed', seedValue);
    return this;
  }

  /// Enables or disables parallel tool calls
  ///
  /// Whether to enable parallel function calling during tool use.
  /// When enabled, the model can call multiple functions simultaneously.
  ///
  /// - true: Enable parallel tool calls (default for newer models)
  /// - false: Disable parallel tool calls (sequential execution)
  OpenAIBuilder parallelToolCalls(bool enabled) {
    _baseBuilder.extension('parallelToolCalls', enabled);
    return this;
  }

  /// Enables or disables log probabilities
  ///
  /// Whether to return log probabilities of the output tokens.
  /// If true, returns the log probabilities of each output token.
  OpenAIBuilder logprobs(bool enabled) {
    _baseBuilder.extension('logprobs', enabled);
    return this;
  }

  /// Sets the number of most likely tokens to return log probabilities for
  ///
  /// An integer between 0 and 20 specifying the number of most likely
  /// tokens to return at each token position, each with an associated
  /// log probability. logprobs must be set to true if this parameter is used.
  ///
  /// Range: 0-20
  OpenAIBuilder topLogprobs(int count) {
    _baseBuilder.extension('topLogprobs', count);
    return this;
  }

  // ========== OpenAI Web Search Configuration ==========

  /// Configures web search for OpenAI models
  ///
  /// OpenAI supports web search through specific models like `gpt-4o-search-preview`
  /// and provides context size control for search results.
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .openai((openai) => openai
  ///         .webSearch(contextSize: WebSearchContextSize.high))
  ///     .apiKey(apiKey)
  ///     .model('gpt-4o-search-preview')
  ///     .build();
  /// ```
  OpenAIBuilder webSearch({
    WebSearchContextSize contextSize = WebSearchContextSize.medium,
  }) {
    _baseBuilder.extension(
        'webSearchConfig',
        WebSearchConfig.openai(
          contextSize: contextSize,
        ));
    return this;
  }

  // ========== Convenience methods for common configurations ==========

  /// Configure for creative writing with reduced repetition
  ///
  /// Sets moderate frequency and presence penalties to encourage
  /// diverse and creative output while maintaining coherence.
  OpenAIBuilder forCreativeWriting() {
    return frequencyPenalty(0.5).presencePenalty(0.6).parallelToolCalls(false);
  }

  /// Configure for factual and consistent responses
  ///
  /// Sets low penalties and enables deterministic behavior for
  /// consistent, factual responses.
  OpenAIBuilder forFactualResponses({int? seed}) {
    final builder =
        frequencyPenalty(0.0).presencePenalty(0.0).parallelToolCalls(true);

    if (seed != null) {
      builder.seed(seed);
    }

    return builder;
  }

  /// Configure for code generation with deterministic output
  ///
  /// Optimized settings for code generation tasks with consistent
  /// formatting and reduced randomness.
  OpenAIBuilder forCodeGeneration({int? seed}) {
    final builder =
        frequencyPenalty(0.1).presencePenalty(0.1).parallelToolCalls(true);

    if (seed != null) {
      builder.seed(seed);
    }

    return builder;
  }

  /// Configure for conversational AI with balanced creativity
  ///
  /// Balanced settings for natural conversation with some creativity
  /// while avoiding excessive repetition.
  OpenAIBuilder forConversation() {
    return frequencyPenalty(0.3).presencePenalty(0.4).parallelToolCalls(true);
  }

  /// Configure for analysis tasks with log probabilities
  ///
  /// Enables log probabilities for confidence analysis and
  /// sets conservative penalties for analytical tasks.
  OpenAIBuilder forAnalysis({int topLogprobsCount = 5}) {
    return frequencyPenalty(0.1)
        .presencePenalty(0.1)
        .logprobs(true)
        .topLogprobs(topLogprobsCount)
        .parallelToolCalls(true);
  }

  // ========== Build methods ==========

  /// Builds and returns a configured LLM provider instance
  Future<ChatCapability> build() async {
    return _baseBuilder.build();
  }

  /// Builds a provider with AudioCapability
  Future<AudioCapability> buildAudio() async {
    return _baseBuilder.buildAudio();
  }

  /// Builds a provider with ImageGenerationCapability
  Future<ImageGenerationCapability> buildImageGeneration() async {
    return _baseBuilder.buildImageGeneration();
  }

  /// Builds a provider with EmbeddingCapability
  Future<EmbeddingCapability> buildEmbedding() async {
    return _baseBuilder.buildEmbedding();
  }

  /// Builds a provider with FileManagementCapability
  Future<FileManagementCapability> buildFileManagement() async {
    return _baseBuilder.buildFileManagement();
  }

  /// Builds a provider with ModerationCapability
  Future<ModerationCapability> buildModeration() async {
    return _baseBuilder.buildModeration();
  }

  /// Builds a provider with AssistantCapability
  Future<AssistantCapability> buildAssistant() async {
    return _baseBuilder.buildAssistant();
  }

  /// Builds a provider with ModelListingCapability
  Future<ModelListingCapability> buildModelListing() async {
    return _baseBuilder.buildModelListing();
  }
}
