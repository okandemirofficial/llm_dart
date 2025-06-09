import '../../core/chat_provider.dart';
import '../../models/chat_models.dart';
import '../../models/audio_models.dart';
import '../../models/tool_models.dart';
import '../../models/image_models.dart';
import '../../models/file_models.dart';
import '../../models/moderation_models.dart';
import '../../models/assistant_models.dart';
import 'client.dart';
import 'config.dart';
import 'chat.dart';
import 'embeddings.dart';
import 'audio.dart';
import 'images.dart';
import 'files.dart';
import 'models.dart';
import 'moderation.dart';
import 'assistants.dart';
import 'completion.dart';

/// Modular OpenAI Provider implementation
///
/// This provider demonstrates the new modular architecture inspired by async-openai.
/// Instead of a monolithic class, capabilities are implemented in separate modules
/// and composed together in this main provider class.
///
/// **Benefits of this approach:**
/// - Single Responsibility: Each module handles one capability
/// - Easier Testing: Modules can be tested independently
/// - Better Maintainability: Changes to one capability don't affect others
/// - Cleaner Code: Smaller, focused classes instead of one giant class
/// - Reusability: Modules can be reused across different provider implementations
class ModularOpenAIProvider
    implements
        ChatCapability,
        EmbeddingCapability,
        TextToSpeechCapability,
        SpeechToTextCapability,
        ImageGenerationCapability,
        FileManagementCapability,
        ModelListingCapability,
        ModerationCapability,
        AssistantCapability,
        CompletionCapability,
        ProviderCapabilities {
  final OpenAIClient _client;
  final ModularOpenAIConfig config;

  // Capability modules
  late final OpenAIChat _chat;
  late final OpenAIEmbeddings _embeddings;
  late final OpenAIAudio _audio;
  late final OpenAIImages _images;
  late final OpenAIFiles _files;
  late final OpenAIModels _models;
  late final OpenAIModeration _moderation;
  late final OpenAIAssistants _assistants;
  late final OpenAICompletion _completion;

  ModularOpenAIProvider(this.config) : _client = OpenAIClient(config) {
    // Initialize capability modules
    _chat = OpenAIChat(_client, config);
    _embeddings = OpenAIEmbeddings(_client, config);
    _audio = OpenAIAudio(_client, config);
    _images = OpenAIImages(_client, config);
    _files = OpenAIFiles(_client, config);
    _models = OpenAIModels(_client, config);
    _moderation = OpenAIModeration(_client, config);
    _assistants = OpenAIAssistants(_client, config);
    _completion = OpenAICompletion(_client, config);
  }

  String get providerName => 'OpenAI (Modular)';

  // ========== ProviderCapabilities ==========

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.embedding,
        LLMCapability.textToSpeech,
        LLMCapability.speechToText,
        LLMCapability.toolCalling,
        LLMCapability.reasoning,
        LLMCapability.vision,
        LLMCapability.imageGeneration,
        LLMCapability.fileManagement,
        LLMCapability.moderation,
        LLMCapability.assistants,
        LLMCapability.completion,
      };

  @override
  bool supports(LLMCapability capability) {
    return supportedCapabilities.contains(capability);
  }

  // ========== ChatCapability (delegated to chat module) ==========

  @override
  Future<ChatResponse> chat(List<ChatMessage> messages) async {
    return _chat.chat(messages);
  }

  @override
  Future<ChatResponse> chatWithTools(
    List<ChatMessage> messages,
    List<Tool>? tools,
  ) async {
    return _chat.chatWithTools(messages, tools);
  }

  @override
  Stream<ChatStreamEvent> chatStream(
    List<ChatMessage> messages, {
    List<Tool>? tools,
  }) {
    return _chat.chatStream(messages, tools: tools);
  }

  @override
  Future<List<ChatMessage>?> memoryContents() async {
    return _chat.memoryContents();
  }

  @override
  Future<String> summarizeHistory(List<ChatMessage> messages) async {
    return _chat.summarizeHistory(messages);
  }

  // ========== EmbeddingCapability (delegated to embeddings module) ==========

  @override
  Future<List<List<double>>> embed(List<String> input) async {
    return _embeddings.embed(input);
  }

  // ========== TextToSpeechCapability (delegated to audio module) ==========

  @override
  Future<TTSResponse> textToSpeech(TTSRequest request) async {
    return _audio.textToSpeech(request);
  }

  @override
  Future<List<int>> speech(String text) async {
    return _audio.speech(text);
  }

  @override
  Future<List<VoiceInfo>> getVoices() async {
    return _audio.getVoices();
  }

  @override
  List<String> getSupportedAudioFormats() {
    return _audio.getSupportedAudioFormats();
  }

  // ========== SpeechToTextCapability (delegated to audio module) ==========

  @override
  Future<STTResponse> speechToText(STTRequest request) async {
    return _audio.speechToText(request);
  }

  @override
  Future<String> transcribe(List<int> audio) async {
    return _audio.transcribe(audio);
  }

  @override
  Future<String> transcribeFile(String filePath) async {
    return _audio.transcribeFile(filePath);
  }

  @override
  Future<List<LanguageInfo>> getSupportedLanguages() async {
    return _audio.getSupportedLanguages();
  }

  // ========== ImageGenerationCapability (delegated to images module) ==========

  @override
  Future<ImageGenerationResponse> generateImages(
      ImageGenerationRequest request) async {
    return _images.generateImages(request);
  }

  @override
  List<String> getSupportedSizes() {
    return _images.getSupportedSizes();
  }

  @override
  List<String> getSupportedFormats() {
    return _images.getSupportedFormats();
  }

  @override
  Future<List<String>> generateImage({
    required String prompt,
    String? model,
    String? negativePrompt,
    String? imageSize,
    int? batchSize,
    String? seed,
    int? numInferenceSteps,
    double? guidanceScale,
    bool? promptEnhancement,
  }) async {
    return _images.generateImage(
      prompt: prompt,
      model: model,
      negativePrompt: negativePrompt,
      imageSize: imageSize,
      batchSize: batchSize,
      seed: seed,
      numInferenceSteps: numInferenceSteps,
      guidanceScale: guidanceScale,
      promptEnhancement: promptEnhancement,
    );
  }

  // ========== FileManagementCapability (delegated to files module) ==========

  @override
  Future<OpenAIFile> uploadFile(CreateFileRequest request) async {
    return _files.uploadFile(request);
  }

  @override
  Future<ListFilesResponse> listFiles([ListFilesQuery? query]) async {
    return _files.listFiles(query);
  }

  @override
  Future<OpenAIFile> retrieveFile(String fileId) async {
    return _files.retrieveFile(fileId);
  }

  @override
  Future<DeleteFileResponse> deleteFile(String fileId) async {
    return _files.deleteFile(fileId);
  }

  @override
  Future<List<int>> getFileContent(String fileId) async {
    return _files.getFileContent(fileId);
  }

  // ========== ModelListingCapability (delegated to models module) ==========

  @override
  Future<List<AIModel>> models() async {
    return _models.models();
  }

  // ========== ModerationCapability (delegated to moderation module) ==========

  @override
  Future<ModerationResponse> moderate(ModerationRequest request) async {
    return _moderation.moderate(request);
  }

  // ========== AssistantCapability (delegated to assistants module) ==========

  @override
  Future<Assistant> createAssistant(CreateAssistantRequest request) async {
    return _assistants.createAssistant(request);
  }

  @override
  Future<ListAssistantsResponse> listAssistants(
      [ListAssistantsQuery? query]) async {
    return _assistants.listAssistants(query);
  }

  @override
  Future<Assistant> retrieveAssistant(String assistantId) async {
    return _assistants.retrieveAssistant(assistantId);
  }

  @override
  Future<Assistant> modifyAssistant(
    String assistantId,
    ModifyAssistantRequest request,
  ) async {
    return _assistants.modifyAssistant(assistantId, request);
  }

  @override
  Future<DeleteAssistantResponse> deleteAssistant(String assistantId) async {
    return _assistants.deleteAssistant(assistantId);
  }

  // ========== CompletionCapability (delegated to completion module) ==========

  @override
  Future<CompletionResponse> complete(CompletionRequest request) async {
    return _completion.complete(request);
  }

  // ========== Additional Helper Methods ==========

  /// Get the underlying client for advanced usage
  OpenAIClient get client => _client;

  /// Get embedding dimensions for the configured model
  Future<int> getEmbeddingDimensions() async {
    return _embeddings.getEmbeddingDimensions();
  }

  /// Check if a model is valid and accessible
  Future<({bool valid, String? error})> checkModel() async {
    try {
      final messages = [ChatMessage.user('hi')];
      await _chat.chatWithTools(messages, null);
      return (valid: true, error: null);
    } catch (e) {
      return (valid: false, error: e.toString());
    }
  }

  @override
  String toString() {
    return 'ModularOpenAIProvider('
        'model: ${config.model}, '
        'baseUrl: ${config.baseUrl}'
        ')';
  }
}

/// Factory function to create a modular OpenAI provider
///
/// This demonstrates how the new modular approach can be used
/// while maintaining the same external API.
ModularOpenAIProvider createModularOpenAIProvider(ModularOpenAIConfig config) {
  return ModularOpenAIProvider(config);
}

/// Migration helper: Convert old config to new modular provider
///
/// This function helps migrate from the old monolithic provider
/// to the new modular one with minimal code changes.
ModularOpenAIProvider migrateToModular(dynamic oldConfig) {
  if (oldConfig is ModularOpenAIConfig) {
    return ModularOpenAIProvider(oldConfig);
  }

  // Handle other config types if needed
  throw ArgumentError('Unsupported config type: ${oldConfig.runtimeType}');
}
