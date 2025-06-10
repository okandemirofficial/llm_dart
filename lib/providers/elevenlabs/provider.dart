import '../../core/capability.dart';
import '../../core/llm_error.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import '../../models/audio_models.dart';
import 'audio.dart';
import 'client.dart';
import 'config.dart';
import 'models.dart';

/// ElevenLabs Provider implementation
///
/// This is the main provider class that implements audio capabilities
/// and delegates to specialized modules for different functionalities.
/// ElevenLabs specializes in text-to-speech and speech-to-text services.
class ElevenLabsProvider
    implements ChatCapability, TextToSpeechCapability, SpeechToTextCapability {
  final ElevenLabsConfig config;
  final ElevenLabsClient client;
  late final ElevenLabsAudio audio;
  late final ElevenLabsModels models;

  ElevenLabsProvider(this.config) : client = ElevenLabsClient(config) {
    audio = ElevenLabsAudio(client, config);
    models = ElevenLabsModels(client, config);
  }

  String get providerName => 'ElevenLabs';

  // ChatCapability implementation (not supported)
  @override
  Future<ChatResponse> chatWithTools(
    List<ChatMessage> messages,
    List<Tool>? tools,
  ) async {
    throw const ProviderError('ElevenLabs does not support chat functionality');
  }

  @override
  Future<ChatResponse> chat(List<ChatMessage> messages) async {
    return chatWithTools(messages, null);
  }

  @override
  Future<List<ChatMessage>?> memoryContents() async => null;

  @override
  Future<String> summarizeHistory(List<ChatMessage> messages) async {
    throw const ProviderError('ElevenLabs does not support chat functionality');
  }

  @override
  Stream<ChatStreamEvent> chatStream(
    List<ChatMessage> messages, {
    List<Tool>? tools,
  }) async* {
    yield ErrorEvent(
        const ProviderError('ElevenLabs does not support chat functionality'));
  }

  // TextToSpeechCapability implementation
  @override
  Future<TTSResponse> textToSpeech(TTSRequest request) async {
    return audio.textToSpeech(request);
  }

  @override
  Future<List<VoiceInfo>> getVoices() async {
    return audio.getVoices();
  }

  @override
  List<String> getSupportedAudioFormats() {
    return audio.getSupportedAudioFormats();
  }

  // SpeechToTextCapability implementation
  @override
  Future<STTResponse> speechToText(STTRequest request) async {
    return audio.speechToText(request);
  }

  @override
  Future<List<LanguageInfo>> getSupportedLanguages() async {
    return audio.getSupportedLanguages();
  }

  // Convenience methods for backward compatibility
  @override
  Future<List<int>> speech(String text) async {
    return audio.speech(text);
  }

  @override
  Future<String> transcribe(List<int> audio) async {
    return this.audio.transcribe(audio);
  }

  @override
  Future<String> transcribeFile(String filePath) async {
    return audio.transcribeFile(filePath);
  }

  /// Get available models
  Future<List<Map<String, dynamic>>> getModels() async {
    return models.getModels();
  }

  /// Get user subscription info
  Future<Map<String, dynamic>> getUserInfo() async {
    return models.getUserInfo();
  }

  /// Create a new provider with updated configuration
  ElevenLabsProvider copyWith({
    String? apiKey,
    String? baseUrl,
    String? voiceId,
    String? model,
    Duration? timeout,
    double? stability,
    double? similarityBoost,
    double? style,
    bool? useSpeakerBoost,
  }) {
    final newConfig = config.copyWith(
      apiKey: apiKey,
      baseUrl: baseUrl,
      voiceId: voiceId,
      model: model,
      timeout: timeout,
      stability: stability,
      similarityBoost: similarityBoost,
      style: style,
      useSpeakerBoost: useSpeakerBoost,
    );

    return ElevenLabsProvider(newConfig);
  }

  /// Check if the provider supports a specific capability
  bool supportsCapability(Type capability) {
    if (capability == TextToSpeechCapability) return true;
    if (capability == SpeechToTextCapability) return true;
    // ElevenLabs doesn't support chat
    if (capability == ChatCapability) return false;
    return false;
  }

  /// Get provider information
  Map<String, dynamic> get info => {
        'provider': providerName,
        'baseUrl': config.baseUrl,
        'supportsChat': false,
        'supportsTextToSpeech': config.supportsTextToSpeech,
        'supportsSpeechToText': config.supportsSpeechToText,
        'supportsVoiceCloning': config.supportsVoiceCloning,
        'supportsRealTimeStreaming': config.supportsRealTimeStreaming,
        'defaultVoiceId': config.defaultVoiceId,
        'defaultTTSModel': config.defaultTTSModel,
        'defaultSTTModel': config.defaultSTTModel,
        'supportedAudioFormats': config.supportedAudioFormats,
      };

  @override
  String toString() => 'ElevenLabsProvider(voice: ${config.defaultVoiceId})';
}
