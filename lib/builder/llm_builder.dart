import '../core/capability.dart';
import '../core/config.dart';
import '../core/registry.dart';
import '../core/llm_error.dart';
import '../core/web_search.dart';
import '../models/tool_models.dart';
import '../models/chat_models.dart';
<<<<<<< Updated upstream
import '../providers/google/builder.dart';
import '../providers/openai/builder.dart';
import '../providers/anthropic/builder.dart';
import '../providers/ollama/builder.dart';
import '../providers/elevenlabs/builder.dart';
import '../providers/openai/compatible/openrouter/builder.dart';
import 'http_config.dart';
=======
import 'package:dio/dio.dart';
>>>>>>> Stashed changes

/// Builder for configuring and instantiating LLM providers
///
/// Provides a fluent interface for setting various configuration
/// options like model selection, API keys, generation parameters, etc.
///
/// The new version uses the provider registry system for extensibility.
class LLMBuilder {
  /// Selected provider ID (replaces backend enum)
  String? _providerId;

  /// Unified configuration being built
  LLMConfig _config = LLMConfig(
    baseUrl: '',
    model: '',
  );

  /// Creates a new empty builder instance with default values
  LLMBuilder();

  /// Sets the provider to use (new registry-based approach)
  LLMBuilder provider(String providerId) {
    _providerId = providerId;

    // Get default config for this provider if it's registered
    final factory = LLMProviderRegistry.getFactory(providerId);
    if (factory != null) {
      _config = factory.getDefaultConfig();
    }

    return this;
  }

  /// Convenience methods for built-in providers
  LLMBuilder openai([OpenAIBuilder Function(OpenAIBuilder)? configure]) {
    provider('openai');
    if (configure != null) {
      final openaiBuilder = OpenAIBuilder(this);
      configure(openaiBuilder);
    }
    return this;
  }

  LLMBuilder anthropic(
      [AnthropicBuilder Function(AnthropicBuilder)? configure]) {
    provider('anthropic');
    if (configure != null) {
      final anthropicBuilder = AnthropicBuilder(this);
      configure(anthropicBuilder);
    }
    return this;
  }

  LLMBuilder google([GoogleLLMBuilder Function(GoogleLLMBuilder)? configure]) {
    provider('google');
    if (configure != null) {
      final googleBuilder = GoogleLLMBuilder(this);
      configure(googleBuilder);
    }
    return this;
  }

  LLMBuilder deepseek() => provider('deepseek');

  LLMBuilder ollama([OllamaBuilder Function(OllamaBuilder)? configure]) {
    provider('ollama');
    if (configure != null) {
      final ollamaBuilder = OllamaBuilder(this);
      configure(ollamaBuilder);
    }
    return this;
  }

  LLMBuilder xai() => provider('xai');
  LLMBuilder phind() => provider('phind');
  LLMBuilder groq() => provider('groq');

  LLMBuilder elevenlabs(
      [ElevenLabsBuilder Function(ElevenLabsBuilder)? configure]) {
    provider('elevenlabs');
    if (configure != null) {
      final elevenLabsBuilder = ElevenLabsBuilder(this);
      configure(elevenLabsBuilder);
    }
    return this;
  }

  /// Convenience methods for OpenAI-compatible providers
  /// These use the OpenAI interface but with provider-specific configurations
  LLMBuilder deepseekOpenAI() => provider('deepseek-openai');
  LLMBuilder googleOpenAI() => provider('google-openai');
  LLMBuilder xaiOpenAI() => provider('xai-openai');
  LLMBuilder groqOpenAI() => provider('groq-openai');
  LLMBuilder phindOpenAI() => provider('phind-openai');
  LLMBuilder openRouter(
      [OpenRouterBuilder Function(OpenRouterBuilder)? configure]) {
    provider('openrouter');
    if (configure != null) {
      final openRouterBuilder = OpenRouterBuilder(this);
      configure(openRouterBuilder);
    }
    return this;
  }

  LLMBuilder githubCopilot() => provider('github-copilot');
  LLMBuilder togetherAI() => provider('together-ai');

  /// Sets the API key for authentication
  LLMBuilder apiKey(String key) {
    _config = _config.copyWith(apiKey: key);
    return this;
  }

  /// Sets the base URL for API requests
  LLMBuilder baseUrl(String url) {
    // Ensure the URL ends with a slash
    final normalizedUrl = url.endsWith('/') ? url : '$url/';
    _config = _config.copyWith(baseUrl: normalizedUrl);
    return this;
  }

  /// Sets the model identifier to use
  LLMBuilder model(String model) {
    _config = _config.copyWith(model: model);
    return this;
  }

  /// Sets the maximum number of tokens to generate
  LLMBuilder maxTokens(int tokens) {
    _config = _config.copyWith(maxTokens: tokens);
    return this;
  }

  /// Sets the temperature for controlling response randomness (0.0-1.0)
  LLMBuilder temperature(double temp) {
    _config = _config.copyWith(temperature: temp);
    return this;
  }

  /// Sets the system prompt/context
  LLMBuilder systemPrompt(String prompt) {
    _config = _config.copyWith(systemPrompt: prompt);
    return this;
  }

  /// Sets the global timeout for all HTTP operations
  ///
  /// This method sets a global timeout that serves as the default for all
  /// HTTP timeout types (connection, receive, send). Individual HTTP timeout
  /// configurations will override this global setting.
  ///
  /// **Priority order:**
  /// 1. HTTP-specific timeouts (highest priority)
  /// 2. Global timeout set by this method (medium priority)
  /// 3. Provider defaults (lowest priority)
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .timeout(Duration(minutes: 2))     // Global default: 2 minutes
  ///     .http((http) => http
  ///         .receiveTimeout(Duration(minutes: 5))) // Override receive: 5 minutes
  ///     .build();
  /// // Result: connection=2min, receive=5min, send=2min
  /// ```
  ///
  /// For setting all HTTP timeouts to the same value, use:
  /// ```dart
  /// .http((http) => http
  ///     .connectionTimeout(Duration(seconds: 30))
  ///     .receiveTimeout(Duration(minutes: 5))
  ///     .sendTimeout(Duration(seconds: 60)))
  /// ```
  LLMBuilder timeout(Duration timeout) {
    _config = _config.copyWith(timeout: timeout);
    return this;
  }

  /// Sets the top-p (nucleus) sampling parameter
  LLMBuilder topP(double topP) {
    _config = _config.copyWith(topP: topP);
    return this;
  }

  /// Sets the top-k sampling parameter
  LLMBuilder topK(int topK) {
    _config = _config.copyWith(topK: topK);
    return this;
  }

  /// Sets the function tools
  LLMBuilder tools(List<Tool> tools) {
    _config = _config.copyWith(tools: tools);
    return this;
  }

  /// Sets the tool choice
  LLMBuilder toolChoice(ToolChoice choice) {
    _config = _config.copyWith(toolChoice: choice);
    return this;
  }

  /// Sets stop sequences for generation
  LLMBuilder stopSequences(List<String> sequences) {
    _config = _config.copyWith(stopSequences: sequences);
    return this;
  }

  /// Sets user identifier for tracking and analytics
  LLMBuilder user(String userId) {
    _config = _config.copyWith(user: userId);
    return this;
  }

  /// Sets service tier for API requests
  LLMBuilder serviceTier(ServiceTier tier) {
    _config = _config.copyWith(serviceTier: tier);
    return this;
  }

  /// Sets a custom Dio instance for HTTP requests
  ///
  /// If provided, this Dio instance will be used for all HTTP requests
  /// instead of creating a default one. This allows for custom interceptors,
  /// proxy settings, certificates, and other advanced HTTP configurations.
  ///
  /// Example:
  /// ```dart
  /// final customDio = Dio();
  /// customDio.interceptors.add(LogInterceptor());
  ///
  /// final provider = await ai()
  ///     .anthropic()
  ///     .apiKey(apiKey)
  ///     .dioClient(customDio)
  ///     .build();
  /// ```
  LLMBuilder dioClient(Dio dio) {
    _config = _config.copyWith(dioClient: dio);
    return this;
  }

  /// Sets the reasoning effort for models that support it (e.g., OpenAI o1, Gemini)
  /// Valid values: ReasoningEffort.low, ReasoningEffort.medium, ReasoningEffort.high, or null to disable
  LLMBuilder reasoningEffort(ReasoningEffort? effort) {
    _config = _config.withExtension('reasoningEffort', effort?.value);
    return this;
  }

  /// Sets structured output schema for JSON responses
  LLMBuilder jsonSchema(StructuredOutputFormat schema) {
    _config = _config.withExtension('jsonSchema', schema);
    return this;
  }

  /// Sets voice for text-to-speech (OpenAI providers)
  LLMBuilder voice(String voiceName) {
    _config = _config.withExtension('voice', voiceName);
    return this;
  }

  /// Enables reasoning/thinking for supported providers (Anthropic, OpenAI o1)
  LLMBuilder reasoning(bool enable) {
    _config = _config.withExtension('reasoning', enable);
    return this;
  }

  /// Sets thinking budget tokens for Anthropic extended thinking
  LLMBuilder thinkingBudgetTokens(int tokens) {
    _config = _config.withExtension('thinkingBudgetTokens', tokens);
    return this;
  }

  /// Enables interleaved thinking for Anthropic (Claude 4 models only)
  LLMBuilder interleavedThinking(bool enable) {
    _config = _config.withExtension('interleavedThinking', enable);
    return this;
  }

  /// Sets provider-specific extension
  LLMBuilder extension(String key, dynamic value) {
    _config = _config.withExtension(key, value);
    return this;
  }

  /// Configure HTTP settings using a fluent builder
  ///
  /// This method provides a clean, organized way to configure HTTP settings
  /// without cluttering the main LLMBuilder interface.
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .http((http) => http
  ///         .proxy('http://proxy.company.com:8080')
  ///         .headers({'X-Custom-Header': 'value'})
  ///         .connectionTimeout(Duration(seconds: 30))
  ///         .enableLogging(true))
  ///     .build();
  /// ```
  LLMBuilder http(HttpConfig Function(HttpConfig) configure) {
    final httpConfig = HttpConfig();
    final configuredHttp = configure(httpConfig);
    final httpSettings = configuredHttp.build();

    // Apply all HTTP settings as extensions
    for (final entry in httpSettings.entries) {
      _config = _config.withExtension(entry.key, entry.value);
    }

    return this;
  }

  /// Convenience methods for common extensions
  LLMBuilder embeddingEncodingFormat(String format) =>
      extension('embeddingEncodingFormat', format);
  LLMBuilder embeddingDimensions(int dimensions) =>
      extension('embeddingDimensions', dimensions);

  /// Web Search configuration methods
  ///
  /// These methods provide a unified interface for configuring web search
  /// across different providers (xAI, Anthropic, etc.). The implementation
  /// details are handled automatically based on the selected provider.

  /// Enables web search functionality
  ///
  /// This is a universal method that works across all providers that support
  /// web search. The underlying implementation varies by provider:
  /// - **xAI**: Uses Live Search with search_parameters
  /// - **Anthropic**: Uses web_search tool
  /// - **Others**: Provider-specific implementations
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .xai()  // or .anthropic(), etc.
  ///     .apiKey(apiKey)
  ///     .enableWebSearch()
  ///     .build();
  /// ```
  LLMBuilder enableWebSearch() => extension('webSearchEnabled', true);

  /// Configures web search with detailed options
  ///
  /// This method provides fine-grained control over web search behavior
  /// using a unified configuration that adapts to each provider's API.
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .anthropic()
  ///     .apiKey(apiKey)
  ///     .webSearch(
  ///       maxUses: 3,
  ///       allowedDomains: ['wikipedia.org', 'github.com'],
  ///       location: WebSearchLocation.sanFrancisco(),
  ///     )
  ///     .build();
  /// ```
  LLMBuilder webSearch({
    int? maxUses,
    int? maxResults,
    List<String>? allowedDomains,
    List<String>? blockedDomains,
    WebSearchLocation? location,
    String? mode,
    String? fromDate,
    String? toDate,
  }) {
    final config = WebSearchConfig(
      maxUses: maxUses,
      maxResults: maxResults,
      allowedDomains: allowedDomains,
      blockedDomains: blockedDomains,
      location: location,
      mode: mode,
      fromDate: fromDate,
      toDate: toDate,
    );
    return extension('webSearchConfig', config);
  }

  /// Quick web search setup with basic options
  ///
  /// A simplified method for common web search scenarios.
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .xai()
  ///     .apiKey(apiKey)
  ///     .quickWebSearch(maxResults: 5)
  ///     .build();
  /// ```
  LLMBuilder quickWebSearch({
    int maxResults = 5,
    List<String>? blockedDomains,
  }) {
    return webSearch(
      maxResults: maxResults,
      blockedDomains: blockedDomains,
      mode: 'auto',
    );
  }

  /// Enables news search functionality
  ///
  /// Configures the provider to search news sources specifically.
  /// This is particularly useful for current events and recent information.
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .xai()
  ///     .apiKey(apiKey)
  ///     .newsSearch(
  ///       maxResults: 10,
  ///       fromDate: '2024-01-01',
  ///     )
  ///     .build();
  /// ```
  LLMBuilder newsSearch({
    int? maxResults,
    String? fromDate,
    String? toDate,
    List<String>? blockedDomains,
  }) {
    final config = WebSearchConfig(
      maxResults: maxResults,
      fromDate: fromDate,
      toDate: toDate,
      blockedDomains: blockedDomains,
      mode: 'auto',
      searchType: WebSearchType.news,
    );
    return extension('webSearchConfig', config);
  }

  /// Configures search location for localized results
  ///
  /// This method sets the geographic context for search results,
  /// which can improve relevance for location-specific queries.
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .anthropic()
  ///     .apiKey(apiKey)
  ///     .enableWebSearch()
  ///     .searchLocation(WebSearchLocation.newYork())
  ///     .build();
  /// ```
  LLMBuilder searchLocation(WebSearchLocation location) {
    return extension('webSearchLocation', location);
  }

  /// Advanced web search configuration with full control
  ///
  /// This method provides access to all web search parameters and allows
  /// fine-grained control over the search behavior across all providers.
  ///
  /// Example:
  /// ```dart
  /// final provider = await ai()
  ///     .anthropic()
  ///     .apiKey(apiKey)
  ///     .advancedWebSearch(
  ///       strategy: WebSearchStrategy.tool,
  ///       contextSize: WebSearchContextSize.high,
  ///       searchPrompt: 'Focus on academic sources',
  ///       maxUses: 3,
  ///       allowedDomains: ['arxiv.org', 'scholar.google.com'],
  ///     )
  ///     .build();
  /// ```
  LLMBuilder advancedWebSearch({
    WebSearchStrategy? strategy,
    WebSearchContextSize? contextSize,
    String? searchPrompt,
    int? maxUses,
    int? maxResults,
    List<String>? allowedDomains,
    List<String>? blockedDomains,
    WebSearchLocation? location,
    String? mode,
    String? fromDate,
    String? toDate,
    WebSearchType? searchType,
  }) {
    final config = WebSearchConfig(
      strategy: strategy ?? WebSearchStrategy.auto,
      contextSize: contextSize,
      searchPrompt: searchPrompt,
      maxUses: maxUses,
      maxResults: maxResults,
      allowedDomains: allowedDomains,
      blockedDomains: blockedDomains,
      location: location,
      mode: mode,
      fromDate: fromDate,
      toDate: toDate,
      searchType: searchType,
    );
    return extension('webSearchConfig', config);
  }

  /// Image generation configuration methods
  LLMBuilder imageSize(String size) => extension('imageSize', size);
  LLMBuilder batchSize(int size) => extension('batchSize', size);
  LLMBuilder imageSeed(String seed) => extension('imageSeed', seed);
  LLMBuilder numInferenceSteps(int steps) =>
      extension('numInferenceSteps', steps);
  LLMBuilder guidanceScale(double scale) => extension('guidanceScale', scale);
  LLMBuilder promptEnhancement(bool enabled) =>
      extension('promptEnhancement', enabled);

  /// Audio configuration methods
  LLMBuilder audioFormat(String format) => extension('audioFormat', format);
  LLMBuilder audioQuality(String quality) => extension('audioQuality', quality);
  LLMBuilder sampleRate(int rate) => extension('sampleRate', rate);
  LLMBuilder languageCode(String code) => extension('languageCode', code);

  /// Advanced audio configuration methods
  LLMBuilder audioProcessingMode(String mode) =>
      extension('audioProcessingMode', mode);
  LLMBuilder includeTimestamps(bool enabled) =>
      extension('includeTimestamps', enabled);
  LLMBuilder timestampGranularity(String granularity) =>
      extension('timestampGranularity', granularity);
  LLMBuilder textNormalization(String mode) =>
      extension('textNormalization', mode);
  LLMBuilder instructions(String instructions) =>
      extension('instructions', instructions);
  LLMBuilder previousText(String text) => extension('previousText', text);
  LLMBuilder nextText(String text) => extension('nextText', text);
  LLMBuilder audioSeed(int seed) => extension('audioSeed', seed);
  LLMBuilder enableLogging(bool enabled) => extension('enableLogging', enabled);
  LLMBuilder optimizeStreamingLatency(int level) =>
      extension('optimizeStreamingLatency', level);

  /// STT-specific configuration methods
  LLMBuilder diarize(bool enabled) => extension('diarize', enabled);
  LLMBuilder numSpeakers(int count) => extension('numSpeakers', count);
  LLMBuilder tagAudioEvents(bool enabled) =>
      extension('tagAudioEvents', enabled);
  LLMBuilder webhook(bool enabled) => extension('webhook', enabled);
  LLMBuilder prompt(String prompt) => extension('prompt', prompt);
  LLMBuilder responseFormat(String format) =>
      extension('responseFormat', format);
  LLMBuilder cloudStorageUrl(String url) => extension('cloudStorageUrl', url);

  /// Builds and returns a configured LLM provider instance
  ///
  /// Returns a unified ChatCapability interface that can be used consistently
  /// across different LLM providers. The actual implementation will vary based
  /// on the selected provider.
  ///
  /// Note: Some providers may implement additional interfaces like EmbeddingCapability,
  /// ModelListingCapability, etc. Use dynamic casting to access these features.
  ///
  /// Throws [LLMError] if:
  /// - No provider is specified
  /// - Provider is not registered
  /// - Required configuration like API keys are missing
  Future<ChatCapability> build() async {
    if (_providerId == null) {
      throw const GenericError('No provider specified');
    }

    // Use the registry to create the provider
    return LLMProviderRegistry.createProvider(_providerId!, _config);
  }

  // ========== Capability Factory Methods ==========
  // These methods provide type-safe access to specific capabilities
  // at build time, eliminating the need for runtime type casting.

  /// Builds a provider with AudioCapability
  ///
  /// Returns a provider that implements AudioCapability for text-to-speech,
  /// speech-to-text, and other audio processing features.
  ///
  /// Throws [UnsupportedCapabilityError] if the provider doesn't support audio capabilities.
  ///
  /// Example:
  /// ```dart
  /// final audioProvider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .buildAudio();
  ///
  /// // Direct usage without type casting
  /// final voices = await audioProvider.getVoices();
  /// ```
  Future<AudioCapability> buildAudio() async {
    final provider = await build();
    if (provider is! AudioCapability) {
      throw UnsupportedCapabilityError(
        'Provider "$_providerId" does not support audio capabilities. '
        'Supported providers: OpenAI, ElevenLabs',
      );
    }
    return provider as AudioCapability;
  }

  /// Builds a provider with ImageGenerationCapability
  ///
  /// Returns a provider that implements ImageGenerationCapability for
  /// generating, editing, and creating variations of images.
  ///
  /// Throws [UnsupportedCapabilityError] if the provider doesn't support image generation.
  ///
  /// Example:
  /// ```dart
  /// final imageProvider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .model('dall-e-3')
  ///     .buildImageGeneration();
  ///
  /// // Direct usage without type casting
  /// final images = await imageProvider.generateImage(prompt: 'A sunset');
  /// ```
  Future<ImageGenerationCapability> buildImageGeneration() async {
    final provider = await build();
    if (provider is! ImageGenerationCapability) {
      throw UnsupportedCapabilityError(
        'Provider "$_providerId" does not support image generation capabilities. '
        'Supported providers: OpenAI (DALL-E)',
      );
    }
    return provider as ImageGenerationCapability;
  }

  /// Builds a provider with EmbeddingCapability
  ///
  /// Returns a provider that implements EmbeddingCapability for
  /// generating vector embeddings from text.
  ///
  /// Throws [UnsupportedCapabilityError] if the provider doesn't support embeddings.
  ///
  /// Example:
  /// ```dart
  /// final embeddingProvider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .model('text-embedding-3-small')
  ///     .buildEmbedding();
  ///
  /// // Direct usage without type casting
  /// final embeddings = await embeddingProvider.embed(['Hello world']);
  /// ```
  Future<EmbeddingCapability> buildEmbedding() async {
    final provider = await build();
    if (provider is! EmbeddingCapability) {
      throw UnsupportedCapabilityError(
        'Provider "$_providerId" does not support embedding capabilities. '
        'Supported providers: OpenAI, Google, DeepSeek',
      );
    }
    return provider as EmbeddingCapability;
  }

  /// Builds a provider with FileManagementCapability
  ///
  /// Returns a provider that implements FileManagementCapability for
  /// uploading, managing, and processing files.
  ///
  /// Throws [UnsupportedCapabilityError] if the provider doesn't support file management.
  ///
  /// Example:
  /// ```dart
  /// final fileProvider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .buildFileManagement();
  ///
  /// // Direct usage without type casting
  /// final file = await fileProvider.uploadFile('document.pdf');
  /// ```
  Future<FileManagementCapability> buildFileManagement() async {
    final provider = await build();
    if (provider is! FileManagementCapability) {
      throw UnsupportedCapabilityError(
        'Provider "$_providerId" does not support file management capabilities. '
        'Supported providers: OpenAI, Anthropic',
      );
    }
    return provider as FileManagementCapability;
  }

  /// Builds a provider with ModerationCapability
  ///
  /// Returns a provider that implements ModerationCapability for
  /// content moderation and safety checks.
  ///
  /// Throws [UnsupportedCapabilityError] if the provider doesn't support moderation.
  ///
  /// Example:
  /// ```dart
  /// final moderationProvider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .buildModeration();
  ///
  /// // Direct usage without type casting
  /// final result = await moderationProvider.moderate('Some text to check');
  /// ```
  Future<ModerationCapability> buildModeration() async {
    final provider = await build();
    if (provider is! ModerationCapability) {
      throw UnsupportedCapabilityError(
        'Provider "$_providerId" does not support moderation capabilities. '
        'Supported providers: OpenAI',
      );
    }
    return provider as ModerationCapability;
  }

  /// Builds a provider with AssistantCapability
  ///
  /// Returns a provider that implements AssistantCapability for
  /// creating and managing AI assistants.
  ///
  /// Throws [UnsupportedCapabilityError] if the provider doesn't support assistants.
  ///
  /// Example:
  /// ```dart
  /// final assistantProvider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .buildAssistant();
  ///
  /// // Direct usage without type casting
  /// final assistant = await assistantProvider.createAssistant(request);
  /// ```
  Future<AssistantCapability> buildAssistant() async {
    final provider = await build();
    if (provider is! AssistantCapability) {
      throw UnsupportedCapabilityError(
        'Provider "$_providerId" does not support assistant capabilities. '
        'Supported providers: OpenAI',
      );
    }
    return provider as AssistantCapability;
  }

  /// Builds a provider with ModelListingCapability
  ///
  /// Returns a provider that implements ModelListingCapability for
  /// discovering available models.
  ///
  /// Throws [UnsupportedCapabilityError] if the provider doesn't support model listing.
  ///
  /// Example:
  /// ```dart
  /// final modelProvider = await ai()
  ///     .openai()
  ///     .apiKey(apiKey)
  ///     .buildModelListing();
  ///
  /// // Direct usage without type casting
  /// final models = await modelProvider.listModels();
  /// ```
  Future<ModelListingCapability> buildModelListing() async {
    final provider = await build();
    if (provider is! ModelListingCapability) {
      throw UnsupportedCapabilityError(
        'Provider "$_providerId" does not support model listing capabilities. '
        'Supported providers: OpenAI, Anthropic, DeepSeek, Ollama',
      );
    }
    return provider as ModelListingCapability;
  }
}
