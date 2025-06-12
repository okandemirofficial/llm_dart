import '../../core/capability.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import 'client.dart';
import 'config.dart';
import 'chat.dart';

/// Groq provider implementation
///
/// This provider implements the ChatCapability interface and delegates
/// to specialized capability modules for different functionalities.
/// Groq is optimized for fast inference.
class GroqProvider implements ChatCapability, ProviderCapabilities {
  final GroqClient _client;
  final GroqConfig config;

  // Capability modules
  late final GroqChat _chat;

  GroqProvider(this.config)
      : _client = GroqClient(config, customDio: config.dioClient) {
    // Initialize capability modules
    _chat = GroqChat(_client, config);
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

  /// Get provider name
  String get providerName => 'Groq';

  // ========== ProviderCapabilities ==========

  @override
  Set<LLMCapability> get supportedCapabilities => {
        LLMCapability.chat,
        LLMCapability.streaming,
        LLMCapability.toolCalling,
        if (config.supportsVision) LLMCapability.vision,
        if (config.supportsReasoning) LLMCapability.reasoning,
      };

  @override
  bool supports(LLMCapability capability) {
    return supportedCapabilities.contains(capability);
  }

  /// Get model family information
  String get modelFamily => config.modelFamily;

  /// Check if this provider is optimized for speed
  bool get isSpeedOptimized => config.isSpeedOptimized;
}
