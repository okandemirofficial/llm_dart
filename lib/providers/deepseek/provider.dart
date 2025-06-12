import '../../core/capability.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import 'client.dart';
import 'config.dart';
import 'chat.dart';
import 'models.dart';

/// DeepSeek provider implementation
///
/// This provider implements multiple capability interfaces and delegates
/// to specialized capability modules for different functionalities.
class DeepSeekProvider
    implements ChatCapability, ModelListingCapability, ProviderCapabilities {
  final DeepSeekClient _client;
  final DeepSeekConfig config;

  // Capability modules
  late final DeepSeekChat _chat;
  late final DeepSeekModels _models;

  DeepSeekProvider(this.config)
      : _client = DeepSeekClient(config, customDio: config.dioClient) {
    // Initialize capability modules
    _chat = DeepSeekChat(_client, config);
    _models = DeepSeekModels(_client, config);
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

  @override
  Future<List<AIModel>> models() async {
    return _models.models();
  }

  /// Get provider name
  String get providerName => 'DeepSeek';

  // ========== ProviderCapabilities ==========

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.toolCalling,
        LLMCapability.modelListing,
        if (config.supportsVision) LLMCapability.vision,
        if (config.supportsReasoning) LLMCapability.reasoning,
      };

  @override
  bool supports(LLMCapability capability) {
    return supportedCapabilities.contains(capability);
  }
}
