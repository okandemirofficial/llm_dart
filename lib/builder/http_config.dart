/// HTTP configuration builder for LLM providers
///
/// This class provides a fluent interface for configuring HTTP settings
/// separately from the main LLMBuilder to reduce method count.
class HttpConfig {
  final Map<String, dynamic> _config = {};

  /// Sets HTTP proxy configuration
  HttpConfig proxy(String proxyUrl) {
    _config['httpProxy'] = proxyUrl;
    return this;
  }

  /// Sets custom HTTP headers
  HttpConfig headers(Map<String, String> headers) {
    _config['customHeaders'] = headers;
    return this;
  }

  /// Sets a single custom HTTP header
  HttpConfig header(String name, String value) {
    final existingHeaders =
        _config['customHeaders'] as Map<String, String>? ?? <String, String>{};
    _config['customHeaders'] = {...existingHeaders, name: value};
    return this;
  }

  /// Enables SSL certificate verification bypass
  HttpConfig bypassSSLVerification(bool bypass) {
    _config['bypassSSLVerification'] = bypass;
    return this;
  }

  /// Sets custom SSL certificate path
  HttpConfig sslCertificate(String certificatePath) {
    _config['sslCertificate'] = certificatePath;
    return this;
  }

  /// Sets connection timeout
  HttpConfig connectionTimeout(Duration timeout) {
    _config['connectionTimeout'] = timeout;
    return this;
  }

  /// Sets receive timeout
  HttpConfig receiveTimeout(Duration timeout) {
    _config['receiveTimeout'] = timeout;
    return this;
  }

  /// Sets send timeout
  HttpConfig sendTimeout(Duration timeout) {
    _config['sendTimeout'] = timeout;
    return this;
  }

  /// Enables request/response logging for debugging
  HttpConfig enableLogging(bool enable) {
    _config['enableHttpLogging'] = enable;
    return this;
  }

  /// Get the configuration map
  Map<String, dynamic> build() => Map.from(_config);
}

/// Audio configuration builder for LLM providers
class AudioConfig {
  final Map<String, dynamic> _config = {};

  /// Sets audio format
  AudioConfig format(String format) {
    _config['audioFormat'] = format;
    return this;
  }

  /// Sets audio quality
  AudioConfig quality(String quality) {
    _config['audioQuality'] = quality;
    return this;
  }

  /// Sets sample rate
  AudioConfig sampleRate(int rate) {
    _config['sampleRate'] = rate;
    return this;
  }

  /// Sets language code
  AudioConfig languageCode(String code) {
    _config['languageCode'] = code;
    return this;
  }

  /// Sets voice for TTS
  AudioConfig voice(String voiceName) {
    _config['voice'] = voiceName;
    return this;
  }

  /// Sets voice ID for ElevenLabs
  AudioConfig voiceId(String voiceId) {
    _config['voiceId'] = voiceId;
    return this;
  }

  /// Sets stability parameter for ElevenLabs TTS
  AudioConfig stability(double stability) {
    _config['stability'] = stability;
    return this;
  }

  /// Sets similarity boost parameter for ElevenLabs TTS
  AudioConfig similarityBoost(double similarityBoost) {
    _config['similarityBoost'] = similarityBoost;
    return this;
  }

  /// Sets style parameter for ElevenLabs TTS
  AudioConfig style(double style) {
    _config['style'] = style;
    return this;
  }

  /// Enables speaker boost for ElevenLabs TTS
  AudioConfig useSpeakerBoost(bool enable) {
    _config['useSpeakerBoost'] = enable;
    return this;
  }

  /// Enables diarization for STT
  AudioConfig diarize(bool enabled) {
    _config['diarize'] = enabled;
    return this;
  }

  /// Sets number of speakers for diarization
  AudioConfig numSpeakers(int count) {
    _config['numSpeakers'] = count;
    return this;
  }

  /// Enables timestamp inclusion
  AudioConfig includeTimestamps(bool enabled) {
    _config['includeTimestamps'] = enabled;
    return this;
  }

  /// Sets timestamp granularity
  AudioConfig timestampGranularity(String granularity) {
    _config['timestampGranularity'] = granularity;
    return this;
  }

  /// Get the configuration map
  Map<String, dynamic> build() => Map.from(_config);
}

/// Image generation configuration builder
class ImageConfig {
  final Map<String, dynamic> _config = {};

  /// Sets image size
  ImageConfig size(String size) {
    _config['imageSize'] = size;
    return this;
  }

  /// Sets batch size for generation
  ImageConfig batchSize(int size) {
    _config['batchSize'] = size;
    return this;
  }

  /// Sets seed for reproducible generation
  ImageConfig seed(String seed) {
    _config['imageSeed'] = seed;
    return this;
  }

  /// Sets number of inference steps
  ImageConfig numInferenceSteps(int steps) {
    _config['numInferenceSteps'] = steps;
    return this;
  }

  /// Sets guidance scale
  ImageConfig guidanceScale(double scale) {
    _config['guidanceScale'] = scale;
    return this;
  }

  /// Enables prompt enhancement
  ImageConfig promptEnhancement(bool enabled) {
    _config['promptEnhancement'] = enabled;
    return this;
  }

  /// Get the configuration map
  Map<String, dynamic> build() => Map.from(_config);
}

/// Provider-specific configuration builder
class ProviderConfig {
  final Map<String, dynamic> _config = {};

  /// OpenAI-specific configurations
  ProviderConfig openai() => _OpenAIConfig(this);

  /// Anthropic-specific configurations
  ProviderConfig anthropic() => _AnthropicConfig(this);

  /// Ollama-specific configurations
  ProviderConfig ollama() => _OllamaConfig(this);

  /// Add extension directly
  ProviderConfig extension(String key, dynamic value) {
    _config[key] = value;
    return this;
  }

  /// Get the configuration map
  Map<String, dynamic> build() => Map.from(_config);
}

/// OpenAI-specific configuration methods
class _OpenAIConfig extends ProviderConfig {
  _OpenAIConfig(ProviderConfig parent) {
    _config.addAll(parent._config);
  }

  ProviderConfig frequencyPenalty(double penalty) =>
      extension('frequencyPenalty', penalty);
  ProviderConfig presencePenalty(double penalty) =>
      extension('presencePenalty', penalty);
  ProviderConfig logitBias(Map<String, double> bias) =>
      extension('logitBias', bias);
  ProviderConfig seed(int seedValue) => extension('seed', seedValue);
  ProviderConfig parallelToolCalls(bool enabled) =>
      extension('parallelToolCalls', enabled);
  ProviderConfig logprobs(bool enabled) => extension('logprobs', enabled);
  ProviderConfig topLogprobs(int count) => extension('topLogprobs', count);
}

/// Anthropic-specific configuration methods
class _AnthropicConfig extends ProviderConfig {
  _AnthropicConfig(ProviderConfig parent) {
    _config.addAll(parent._config);
  }

  ProviderConfig reasoning(bool enable) => extension('reasoning', enable);
  ProviderConfig thinkingBudgetTokens(int tokens) =>
      extension('thinkingBudgetTokens', tokens);
  ProviderConfig interleavedThinking(bool enable) =>
      extension('interleavedThinking', enable);
  ProviderConfig metadata(Map<String, dynamic> data) =>
      extension('metadata', data);
}

/// Ollama-specific configuration methods
class _OllamaConfig extends ProviderConfig {
  _OllamaConfig(ProviderConfig parent) {
    _config.addAll(parent._config);
  }

  ProviderConfig numCtx(int contextLength) =>
      extension('numCtx', contextLength);
  ProviderConfig numGpu(int gpuLayers) => extension('numGpu', gpuLayers);
  ProviderConfig numThread(int threads) => extension('numThread', threads);
  ProviderConfig numa(bool enabled) => extension('numa', enabled);
  ProviderConfig numBatch(int batchSize) => extension('numBatch', batchSize);
  ProviderConfig keepAlive(String duration) => extension('keepAlive', duration);
  ProviderConfig raw(bool enabled) => extension('raw', enabled);
}
