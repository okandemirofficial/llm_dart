import '../../core/chat_provider.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import 'client.dart';
import 'config.dart';
import 'chat.dart';

/// Anthropic provider implementation
///
/// This provider implements the ChatCapability interface and delegates
/// to specialized capability modules for different functionalities.
class AnthropicProvider implements ChatCapability {
  final AnthropicClient _client;
  final AnthropicConfig config;

  // Capability modules
  late final AnthropicChat _chat;

  AnthropicProvider(this.config) : _client = AnthropicClient(config) {
    // Validate configuration on initialization
    final validationError = config.validateThinkingConfig();
    if (validationError != null) {
      _client.logger
          .warning('Anthropic configuration warning: $validationError');
    }

    // Initialize capability modules
    _chat = AnthropicChat(_client, config);
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
  String get providerName => 'Anthropic';

  /// Get supported capabilities
  List<String> get supportedCapabilities => [
        'chat',
        'streaming',
        'tools',
        if (config.supportsVision) 'vision',
        if (config.supportsReasoning) 'reasoning',
        if (config.supportsPDF) 'pdf',
      ];

  /// Check if model supports a specific capability
  bool supportsCapability(String capability) {
    switch (capability.toLowerCase()) {
      case 'chat':
      case 'streaming':
      case 'tools':
        return true;
      case 'vision':
        return config.supportsVision;
      case 'reasoning':
      case 'thinking':
        return config.supportsReasoning;
      case 'pdf':
        return config.supportsPDF;
      case 'interleaved_thinking':
        return config.supportsInterleavedThinking;
      default:
        return false;
    }
  }
}
