import '../../core/capability.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import 'client.dart';
import 'config.dart';
import 'chat.dart';
import 'embeddings.dart';

/// Google provider implementation
///
/// This provider implements the ChatCapability and EmbeddingCapability interfaces
/// and delegates to specialized capability modules for different functionalities.
class GoogleProvider
    implements ChatCapability, EmbeddingCapability, ProviderCapabilities {
  final GoogleClient _client;
  final GoogleConfig config;

  // Capability modules
  late final GoogleChat _chat;
  late final GoogleEmbeddings _embeddings;

  GoogleProvider(this.config) : _client = GoogleClient(config) {
    // Initialize capability modules
    _chat = GoogleChat(_client, config);
    _embeddings = GoogleEmbeddings(_client, config);
  }

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

  // ========== EmbeddingCapability ==========

  @override
  Future<List<List<double>>> embed(List<String> input) async {
    return _embeddings.embed(input);
  }

  /// Get provider name
  String get providerName => 'Google';

  // ========== ProviderCapabilities ==========

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.toolCalling,
        if (config.supportsVision) LLMCapability.vision,
        if (config.supportsReasoning) LLMCapability.reasoning,
        if (config.supportsImageGeneration) LLMCapability.imageGeneration,
        if (config.supportsEmbeddings) LLMCapability.embedding,
      };

  @override
  bool supports(LLMCapability capability) {
    return supportedCapabilities.contains(capability);
  }
}
