import '../../core/capability.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import 'chat.dart';
import 'client.dart';
import 'config.dart';
import 'package:dio/dio.dart';

/// Phind Provider implementation
///
/// This is the main provider class that implements the ChatCapability interface
/// and delegates to specialized modules for different functionalities.
/// Phind is specialized for coding tasks and development assistance.
class PhindProvider implements ChatCapability, ProviderCapabilities {
  final PhindConfig config;
  final PhindClient client;

  // Capability modules
  late final PhindChat _chat;

  PhindProvider(this.config)
      : client = PhindClient(config, customDio: config.dioClient) {
    _chat = PhindChat(client, config);
  }

  String get providerName => 'Phind';

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
  Future<ChatResponse> chat(List<ChatMessage> messages) async {
    return _chat.chat(messages);
  }

  @override
  Future<List<ChatMessage>?> memoryContents() async {
    return _chat.memoryContents();
  }

  @override
  Future<String> summarizeHistory(List<ChatMessage> messages) async {
    return _chat.summarizeHistory(messages);
  }

  /// Create a new provider with updated configuration
  PhindProvider copyWith({
    String? apiKey,
    String? baseUrl,
    String? model,
    int? maxTokens,
    double? temperature,
    String? systemPrompt,
    Duration? timeout,
    bool? stream,
    double? topP,
    int? topK,
    List<Tool>? tools,
    ToolChoice? toolChoice,
    Dio? dioClient,
  }) {
    final newConfig = config.copyWith(
      apiKey: apiKey,
      baseUrl: baseUrl,
      model: model,
      maxTokens: maxTokens,
      temperature: temperature,
      systemPrompt: systemPrompt,
      timeout: timeout,
      topP: topP,
      topK: topK,
      tools: tools,
      toolChoice: toolChoice,
      dioClient: dioClient,
    );

    return PhindProvider(newConfig);
  }

  /// Get provider information
  Map<String, dynamic> get info => {
        'provider': providerName,
        'model': config.model,
        'baseUrl': config.baseUrl,
        'supportsChat': true,
        'supportsStreaming': true,
        'supportsTools': config.supportsToolCalling,
        'supportsVision': config.supportsVision,
        'supportsReasoning': config.supportsReasoning,
        'supportsCodeGeneration': config.supportsCodeGeneration,
        'modelFamily': config.modelFamily,
      };

  @override
  String toString() => 'PhindProvider(model: ${config.model})';
}
