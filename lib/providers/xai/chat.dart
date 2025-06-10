import 'dart:convert';

import '../../core/capability.dart';
import '../../core/llm_error.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import 'client.dart';
import 'config.dart';

/// xAI Chat capability implementation
///
/// This module handles all chat-related functionality for xAI providers,
/// including streaming and search capabilities. xAI is known for Grok models.
class XAIChat implements ChatCapability {
  final XAIClient client;
  final XAIConfig config;

  XAIChat(this.client, this.config);

  String get chatEndpoint => 'chat/completions';

  @override
  Future<ChatResponse> chatWithTools(
    List<ChatMessage> messages,
    List<Tool>? tools,
  ) async {
    // Note: xAI doesn't support tools yet, but we include them for API compatibility
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing xAI API key');
    }

    final requestBody = _buildRequestBody(messages, tools, false);
    final responseData = await client.postJson(chatEndpoint, requestBody);
    return _parseResponse(responseData);
  }

  @override
  Stream<ChatStreamEvent> chatStream(
    List<ChatMessage> messages, {
    List<Tool>? tools,
  }) async* {
    if (config.apiKey.isEmpty) {
      yield ErrorEvent(const AuthError('Missing xAI API key'));
      return;
    }

    try {
      final effectiveTools = tools ?? config.tools;
      final requestBody = _buildRequestBody(messages, effectiveTools, true);

      // Create SSE stream
      final stream = client.postStreamRaw(chatEndpoint, requestBody);

      await for (final chunk in stream) {
        final events = _parseStreamEvents(chunk);
        for (final event in events) {
          yield event;
        }
      }
    } catch (e) {
      yield ErrorEvent(GenericError('Unexpected error: $e'));
    }
  }

  @override
  Future<ChatResponse> chat(List<ChatMessage> messages) async {
    return chatWithTools(messages, null);
  }

  @override
  Future<List<ChatMessage>?> memoryContents() async => null;

  @override
  Future<String> summarizeHistory(List<ChatMessage> messages) async {
    final prompt =
        'Summarize in 2-3 sentences:\n${messages.map((m) => '${m.role.name}: ${m.content}').join('\n')}';
    final request = [ChatMessage.user(prompt)];
    final response = await chat(request);
    final text = response.text;
    if (text == null) {
      throw const GenericError('no text in summary response');
    }
    return text;
  }

  /// Parse response from xAI API
  XAIChatResponse _parseResponse(Map<String, dynamic> responseData) {
    return XAIChatResponse(responseData);
  }

  /// Parse stream events from SSE chunks
  List<ChatStreamEvent> _parseStreamEvents(String chunk) {
    final events = <ChatStreamEvent>[];
    final lines = chunk.split('\n');

    for (final line in lines) {
      if (line.startsWith('data: ')) {
        final data = line.substring(6).trim();
        if (data == '[DONE]') {
          break;
        }

        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final event = _parseStreamEvent(json);
          if (event != null) {
            events.add(event);
          }
        } catch (e) {
          // Skip malformed JSON chunks
          client.logger
              .warning('Failed to parse stream JSON: $data, error: $e');
          continue;
        }
      }
    }

    return events;
  }

  /// Parse individual stream event
  ChatStreamEvent? _parseStreamEvent(Map<String, dynamic> json) {
    final choices = json['choices'] as List?;
    if (choices == null || choices.isEmpty) return null;

    final delta = choices.first['delta'] as Map<String, dynamic>?;
    if (delta == null) return null;

    final content = delta['content'] as String?;
    if (content != null) {
      return TextDeltaEvent(content);
    }

    // xAI doesn't support tool calls yet, so we don't parse them
    return null;
  }

  /// Build request body for xAI API
  Map<String, dynamic> _buildRequestBody(
    List<ChatMessage> messages,
    List<Tool>? tools,
    bool stream,
  ) {
    final apiMessages = <Map<String, dynamic>>[];

    // Add system message if configured
    if (config.systemPrompt != null) {
      apiMessages.add({'role': 'system', 'content': config.systemPrompt});
    }

    // Convert messages to xAI format
    for (final message in messages) {
      apiMessages.add(_convertMessage(message));
    }

    final body = <String, dynamic>{
      'model': config.model,
      'messages': apiMessages,
      'stream': stream,
    };

    // Add optional parameters
    if (config.maxTokens != null) body['max_tokens'] = config.maxTokens;
    if (config.temperature != null) body['temperature'] = config.temperature;
    if (config.topP != null) body['top_p'] = config.topP;
    if (config.topK != null) body['top_k'] = config.topK;

    // Add tools if provided (Note: xAI doesn't support tools yet, but keeping for compatibility)
    final effectiveTools = tools ?? config.tools;
    if (effectiveTools != null && effectiveTools.isNotEmpty) {
      body['tools'] = effectiveTools.map((t) => t.toJson()).toList();

      final effectiveToolChoice = config.toolChoice;
      if (effectiveToolChoice != null) {
        body['tool_choice'] = effectiveToolChoice.toJson();
      }
    }

    // Add structured output if configured
    if (config.jsonSchema != null) {
      body['response_format'] = {
        'type': 'json_schema',
        'json_schema': config.jsonSchema!.toJson(),
      };
    }

    // Add search parameters if configured
    if (config.searchParameters != null) {
      final searchParams = _buildSearchParameters();
      if (searchParams != null) {
        body['search_parameters'] = searchParams.toJson();
      }
    }

    return body;
  }

  /// Convert ChatMessage to xAI format
  Map<String, dynamic> _convertMessage(ChatMessage message) {
    final result = <String, dynamic>{'role': message.role.name};

    // Note: xAI API only supports role and content fields based on their specification
    // Name field is not supported in pure xAI API (use OpenAI provider for OpenAI compatibility)

    switch (message.messageType) {
      case TextMessage():
        result['content'] = message.content;
        break;
      case ToolUseMessage():
        // xAI doesn't support tool calls yet, fallback to content
        result['content'] = message.content;
        break;
      case ToolResultMessage():
        // Tool results are handled as separate messages in xAI
        result['content'] = message.content;
        break;
      default:
        result['content'] = message.content;
    }

    return result;
  }

  /// Build search parameters dynamically following xAI specification
  SearchParameters? _buildSearchParameters() {
    final configParams = config.searchParameters;
    if (configParams == null) return null;

    final sources = configParams.sources?.isNotEmpty == true
        ? configParams.sources
        : [const SearchSource(sourceType: 'web')];

    return SearchParameters(
      mode: configParams.mode,
      sources: sources,
      maxSearchResults: configParams.maxSearchResults,
      fromDate: configParams.fromDate,
      toDate: configParams.toDate,
    );
  }
}

/// xAI chat response implementation
class XAIChatResponse implements ChatResponse {
  final Map<String, dynamic> _rawResponse;

  XAIChatResponse(this._rawResponse);

  @override
  String? get text {
    final choices = _rawResponse['choices'] as List?;
    if (choices == null || choices.isEmpty) return null;

    final message = choices.first['message'] as Map<String, dynamic>?;
    return message?['content'] as String?;
  }

  @override
  List<ToolCall>? get toolCalls {
    // xAI doesn't support tool calls yet
    return null;
  }

  @override
  UsageInfo? get usage {
    final usageData = _rawResponse['usage'] as Map<String, dynamic>?;
    if (usageData == null) return null;

    return UsageInfo.fromJson(usageData);
  }

  @override
  String? get thinking =>
      null; // xAI doesn't support thinking/reasoning content

  @override
  String toString() {
    final textContent = text;
    final calls = toolCalls;

    if (textContent != null && calls != null) {
      return '${calls.map((c) => c.toString()).join('\n')}\n$textContent';
    } else if (textContent != null) {
      return textContent;
    } else if (calls != null) {
      return calls.map((c) => c.toString()).join('\n');
    } else {
      return '';
    }
  }
}
