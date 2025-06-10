import '../../core/capability.dart';
import '../../models/chat_models.dart';
import '../../models/file_models.dart';
import '../../models/tool_models.dart';
import 'client.dart';
import 'config.dart';
import 'chat.dart';
import 'files.dart';

/// Anthropic provider implementation
///
/// This provider implements multiple capability interfaces following the
/// modular architecture pattern. It supports:
/// - ChatCapability: Core chat functionality
/// - ModelListingCapability: Model discovery and information
///
/// **API Documentation:**
/// - Messages API: https://docs.anthropic.com/en/api/messages
/// - Models API: https://docs.anthropic.com/en/api/models-list
/// - Token Counting: https://docs.anthropic.com/en/api/messages-count-tokens
/// - Extended Thinking: https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking
///
/// This provider delegates to specialized capability modules for different
/// functionalities, maintaining clean separation of concerns.
class AnthropicProvider
    implements
        ChatCapability,
        ModelListingCapability,
        FileManagementCapability {
  final AnthropicClient _client;
  final AnthropicConfig config;

  // Capability modules
  late final AnthropicChat _chat;
  late final AnthropicFiles _files;

  AnthropicProvider(this.config) : _client = AnthropicClient(config) {
    // Validate configuration on initialization
    final validationError = config.validateThinkingConfig();
    if (validationError != null) {
      _client.logger
          .warning('Anthropic configuration warning: $validationError');
    }

    // Initialize capability modules
    _chat = AnthropicChat(_client, config);
    _files = AnthropicFiles(_client, config);
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

  @override
  Future<List<AIModel>> models() async {
    return listModels();
  }

  /// List available models from Anthropic API
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/models-list
  ///
  /// Supports pagination with [beforeId], [afterId], and [limit] parameters.
  /// Returns a list of available models with their metadata.
  Future<List<AIModel>> listModels({
    String? beforeId,
    String? afterId,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (beforeId != null) queryParams['before_id'] = beforeId;
      if (afterId != null) queryParams['after_id'] = afterId;
      if (limit != 20) queryParams['limit'] = limit;

      final endpoint = queryParams.isEmpty
          ? 'models'
          : 'models?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';

      final responseData = await _client.getJson(endpoint);
      final data = responseData['data'] as List?;

      if (data == null) return [];

      return data
          .map((modelData) =>
              AIModel.fromJson(modelData as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _client.logger.warning('Failed to list models: $e');
      return [];
    }
  }

  /// Get information about a specific model
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/models
  ///
  /// Returns detailed information about a specific model including its
  /// capabilities, creation date, and display name.
  Future<AIModel?> getModel(String modelId) async {
    try {
      final responseData = await _client.getJson('models/$modelId');
      return AIModel.fromJson(responseData);
    } catch (e) {
      _client.logger.warning('Failed to get model $modelId: $e');
      return null;
    }
  }

  /// Count tokens for messages using Anthropic's API
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/messages-count-tokens
  ///
  /// This uses Anthropic's dedicated token counting endpoint to provide
  /// accurate token counts for messages, system prompts, tools, and thinking
  /// configurations without actually sending a chat request.
  Future<int> countTokens(List<ChatMessage> messages,
      {List<Tool>? tools}) async {
    return _chat.countTokens(messages, tools: tools);
  }

  // ========== FileManagementCapability Implementation ==========

  @override
  Future<FileObject> uploadFile(FileUploadRequest request) async {
    return _files.uploadFile(request);
  }

  @override
  Future<FileListResponse> listFiles([FileListQuery? query]) async {
    return _files.listFiles(query);
  }

  @override
  Future<FileObject> retrieveFile(String fileId) async {
    return _files.retrieveFile(fileId);
  }

  @override
  Future<FileDeleteResponse> deleteFile(String fileId) async {
    return _files.deleteFile(fileId);
  }

  @override
  Future<List<int>> getFileContent(String fileId) async {
    return _files.getFileContent(fileId);
  }

  // ========== Legacy File Management Methods ==========

  /// Upload a file to Anthropic (legacy method)
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/files-create
  ///
  /// Uploads a file to Anthropic's file storage for use in conversations.
  /// Returns an [AnthropicFile] object with metadata about the uploaded file.
  Future<AnthropicFile> uploadFileAnthropic(
      AnthropicFileUploadRequest request) async {
    return _files.uploadFileAnthropic(request);
  }

  /// List files in the workspace (legacy method)
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/files-list
  ///
  /// Returns a paginated list of files with optional filtering.
  Future<AnthropicFileListResponse> listFilesAnthropic(
      [AnthropicFileListQuery? query]) async {
    return _files.listFilesAnthropic(query);
  }

  /// Get file metadata
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/files-metadata
  ///
  /// Returns metadata for a specific file including size, type, and creation date.
  Future<AnthropicFile> getFileMetadata(String fileId) async {
    return _files.getFileMetadata(fileId);
  }

  /// Download file content
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/files-content
  ///
  /// Downloads the raw content of a file as bytes.
  Future<List<int>> downloadFile(String fileId) async {
    return _files.downloadFile(fileId);
  }

  /// Delete a file (legacy method)
  ///
  /// **API Reference:** https://docs.anthropic.com/en/api/files-delete
  ///
  /// Permanently deletes a file from the workspace.
  Future<bool> deleteFileAnthropic(String fileId) async {
    return _files.deleteFileAnthropic(fileId);
  }

  /// Upload file from bytes with automatic filename
  Future<FileObject> uploadFileFromBytes(
    List<int> bytes, {
    String? filename,
  }) async {
    return _files.uploadFileFromBytes(bytes, filename: filename);
  }

  /// Check if a file exists
  Future<bool> fileExists(String fileId) async {
    return _files.fileExists(fileId);
  }

  /// Get file content as string (for text files)
  Future<String> getFileContentAsString(String fileId) async {
    return _files.getFileContentAsString(fileId);
  }

  /// Get total storage used by all files
  Future<int> getTotalStorageUsed() async {
    return _files.getTotalStorageUsed();
  }

  /// Batch delete multiple files
  Future<Map<String, bool>> deleteFiles(List<String> fileIds) async {
    return _files.deleteFiles(fileIds);
  }
}
