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
