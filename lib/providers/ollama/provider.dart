import '../../core/capability.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import 'client.dart';
import 'config.dart';
import 'chat.dart';
import 'completion.dart';
import 'embeddings.dart';
import 'models.dart';

/// Ollama provider implementation
///
/// This provider implements multiple capabilities and delegates
/// to specialized capability modules for different functionalities.
/// Ollama is designed for local deployment and supports various models.
class OllamaProvider
    implements
        ChatCapability,
        CompletionCapability,
        EmbeddingCapability,
        ModelListingCapability {
  final OllamaClient _client;
  final OllamaConfig config;

  // Capability modules
  late final OllamaChat _chat;
  late final OllamaCompletion _completion;
  late final OllamaEmbeddings _embeddings;
  late final OllamaModels _models;

  OllamaProvider(this.config) : _client = OllamaClient(config) {
    // Initialize capability modules
    _chat = OllamaChat(_client, config);
    _completion = OllamaCompletion(_client, config);
    _embeddings = OllamaEmbeddings(_client, config);
    _models = OllamaModels(_client, config);
  }

  // Chat capability methods
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

  // Completion capability methods
  @override
  Future<CompletionResponse> complete(CompletionRequest request) async {
    return _completion.complete(request);
  }

  // Embedding capability methods
  @override
  Future<List<List<double>>> embed(List<String> input) async {
    return _embeddings.embed(input);
  }

  // Model listing capability methods
  @override
  Future<List<AIModel>> models() async {
    return _models.models();
  }

  /// Get provider name
  String get providerName => 'Ollama';

  /// Get supported capabilities
  List<String> get supportedCapabilities => [
        'chat',
        'streaming',
        'completion',
        'embeddings',
        'models',
        'local_deployment',
        if (config.supportsToolCalling) 'tools',
        if (config.supportsVision) 'vision',
        if (config.supportsReasoning) 'reasoning',
        if (config.supportsCodeGeneration) 'code_generation',
      ];

  /// Check if model supports a specific capability
  bool supportsCapability(String capability) {
    switch (capability.toLowerCase()) {
      case 'chat':
      case 'streaming':
      case 'completion':
      case 'embeddings':
      case 'models':
      case 'local_deployment':
        return true;
      case 'tools':
        return config.supportsToolCalling;
      case 'vision':
        return config.supportsVision;
      case 'reasoning':
      case 'thinking':
        return config.supportsReasoning;
      case 'code_generation':
      case 'coding':
        return config.supportsCodeGeneration;
      default:
        return false;
    }
  }

  /// Get model family information
  String get modelFamily => config.modelFamily;

  /// Check if this is a local deployment
  bool get isLocal => config.isLocal;

  /// Check if embeddings are supported by current model
  bool get supportsEmbeddings => config.supportsEmbeddings;
}
