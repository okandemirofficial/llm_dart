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
class GroqProvider implements ChatCapability {
  final GroqClient _client;
  final GroqConfig config;

  // Capability modules
  late final GroqChat _chat;

  GroqProvider(this.config) : _client = GroqClient(config) {
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

  /// Get supported capabilities
  List<String> get supportedCapabilities => [
        'chat',
        'streaming',
        'tools',
        'speed_optimized',
        if (config.supportsVision) 'vision',
      ];

  /// Check if model supports a specific capability
  bool supportsCapability(String capability) {
    switch (capability.toLowerCase()) {
      case 'chat':
      case 'streaming':
      case 'tools':
      case 'speed_optimized':
        return true;
      case 'vision':
        return config.supportsVision;
      case 'reasoning':
      case 'thinking':
        return config.supportsReasoning; // Currently false for Groq
      default:
        return false;
    }
  }

  /// Get model family information
  String get modelFamily => config.modelFamily;

  /// Check if this provider is optimized for speed
  bool get isSpeedOptimized => config.isSpeedOptimized;
}
