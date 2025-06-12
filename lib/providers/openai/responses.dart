import 'dart:async';

import '../../core/capability.dart';
import '../../core/llm_error.dart';
import '../../models/chat_models.dart';
import '../../models/tool_models.dart';
import '../../utils/reasoning_utils.dart';
import 'client.dart';
import 'config.dart';

/// OpenAI Responses API capability implementation
///
/// This module handles the new Responses API which combines the simplicity
/// of Chat Completions with the tool-use capabilities of the Assistants API.
/// It supports built-in tools like web search, file search, and computer use.
class OpenAIResponses implements ChatCapability {
  final OpenAIClient client;
  final OpenAIConfig config;

  // State tracking for stream processing
  bool _hasReasoningContent = false;
  String _lastChunk = '';
  final StringBuffer _thinkingBuffer = StringBuffer();

  OpenAIResponses(this.client, this.config);

  String get responsesEndpoint => 'responses';

  @override
  Future<ChatResponse> chatWithTools(
    List<ChatMessage> messages,
    List<Tool>? tools,
  ) async {
    final requestBody = _buildRequestBody(messages, tools, false);
    final responseData = await client.postJson(responsesEndpoint, requestBody);
    return _parseResponse(responseData);
  }

  @override
  Stream<ChatStreamEvent> chatStream(
    List<ChatMessage> messages, {
    List<Tool>? tools,
  }) async* {
    final effectiveTools = tools ?? config.tools;
    final requestBody = _buildRequestBody(messages, effectiveTools, true);

    // Reset stream state
    _resetStreamState();

    try {
      // Create SSE stream
      final stream = client.postStreamRaw(responsesEndpoint, requestBody);

      await for (final chunk in stream) {
        try {
          final events = _parseStreamEvents(chunk);
          for (final event in events) {
            yield event;
          }
        } catch (e) {
          // Log parsing errors but continue processing
          client.logger.warning('Failed to parse stream chunk: $e');
        }
      }
    } catch (e) {
      // Handle stream creation or connection errors
      if (e is LLMError) {
        rethrow;
      } else {
        throw GenericError('Stream error: $e');
      }
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

    // Filter out thinking content for reasoning models
    return ReasoningUtils.filterThinkingContent(text);
  }

  /// Build request body for Responses API
  Map<String, dynamic> _buildRequestBody(
    List<ChatMessage> messages,
    List<Tool>? tools,
    bool stream,
  ) {
    // Convert messages to API format
    final apiMessages = client.buildApiMessages(messages);

    // Handle system prompt: prefer explicit system messages over config
    final hasSystemMessage = messages.any((m) => m.role == ChatRole.system);

    // Only add config system prompt if no explicit system message exists
    if (!hasSystemMessage && config.systemPrompt != null) {
      apiMessages.insert(0, {'role': 'system', 'content': config.systemPrompt});
    }

    final body = <String, dynamic>{
      'model': config.model,
      'input':
          apiMessages.length == 1 ? apiMessages.first['content'] : apiMessages,
      'stream': stream,
    };

    // Add previous response ID for chaining
    if (config.previousResponseId != null) {
      body['previous_response_id'] = config.previousResponseId;
    }

    // Add optional parameters using reasoning utils
    body.addAll(
      ReasoningUtils.getMaxTokensParams(
        model: config.model,
        maxTokens: config.maxTokens,
      ),
    );

    // Add temperature if not disabled for reasoning models
    if (config.temperature != null &&
        !ReasoningUtils.shouldDisableTemperature(config.model)) {
      body['temperature'] = config.temperature;
    }

    // Add top_p if not disabled for reasoning models
    if (config.topP != null &&
        !ReasoningUtils.shouldDisableTopP(config.model)) {
      body['top_p'] = config.topP;
    }
    if (config.topK != null) body['top_k'] = config.topK;

    // Add reasoning effort parameters
    body.addAll(
      ReasoningUtils.getReasoningEffortParams(
        providerId: client.providerId,
        model: config.model,
        reasoningEffort: config.reasoningEffort,
        maxTokens: config.maxTokens,
      ),
    );

    // Build tools array combining function tools and built-in tools
    final allTools = <Map<String, dynamic>>[];

    // Add function tools
    final effectiveTools = tools ?? config.tools;
    if (effectiveTools != null && effectiveTools.isNotEmpty) {
      allTools.addAll(effectiveTools.map((t) => t.toJson()));
    }

    // Add built-in tools
    if (config.builtInTools != null && config.builtInTools!.isNotEmpty) {
      allTools.addAll(config.builtInTools!.map((t) => t.toJson()));
    }

    if (allTools.isNotEmpty) {
      body['tools'] = allTools;

      // Add tool choice if configured (only for function tools)
      final effectiveToolChoice = config.toolChoice;
      if (effectiveToolChoice != null &&
          effectiveTools != null &&
          effectiveTools.isNotEmpty) {
        body['tool_choice'] = effectiveToolChoice.toJson();
      }
    }

    // Add structured output if configured
    if (config.jsonSchema != null) {
      final schema = config.jsonSchema!;
      final responseFormat = <String, dynamic>{
        'type': 'json_schema',
        'json_schema': schema.toJson(),
      };

      // Ensure additionalProperties is set to false for OpenAI compliance
      if (schema.schema != null) {
        final schemaMap = Map<String, dynamic>.from(schema.schema!);
        if (!schemaMap.containsKey('additionalProperties')) {
          schemaMap['additionalProperties'] = false;
        }
        responseFormat['json_schema'] = {
          'name': schema.name,
          if (schema.description != null) 'description': schema.description,
          'schema': schemaMap,
          if (schema.strict != null) 'strict': schema.strict,
        };
      }

      body['response_format'] = responseFormat;
    }

    // Add common parameters
    if (config.stopSequences != null && config.stopSequences!.isNotEmpty) {
      body['stop'] = config.stopSequences;
    }

    if (config.user != null) {
      body['user'] = config.user;
    }

    if (config.serviceTier != null) {
      body['service_tier'] = config.serviceTier!.value;
    }

    // Add OpenAI-specific extension parameters
    final frequencyPenalty = config.getExtension<double>('frequencyPenalty');
    if (frequencyPenalty != null) {
      body['frequency_penalty'] = frequencyPenalty;
    }

    final presencePenalty = config.getExtension<double>('presencePenalty');
    if (presencePenalty != null) {
      body['presence_penalty'] = presencePenalty;
    }

    final logitBias = config.getExtension<Map<String, double>>('logitBias');
    if (logitBias != null && logitBias.isNotEmpty) {
      body['logit_bias'] = logitBias;
    }

    final seed = config.getExtension<int>('seed');
    if (seed != null) {
      body['seed'] = seed;
    }

    final parallelToolCalls = config.getExtension<bool>('parallelToolCalls');
    if (parallelToolCalls != null) {
      body['parallel_tool_calls'] = parallelToolCalls;
    }

    final logprobs = config.getExtension<bool>('logprobs');
    if (logprobs != null) {
      body['logprobs'] = logprobs;
    }

    final topLogprobs = config.getExtension<int>('topLogprobs');
    if (topLogprobs != null) {
      body['top_logprobs'] = topLogprobs;
    }

    return body;
  }

  /// Parse non-streaming response
  ChatResponse _parseResponse(Map<String, dynamic> responseData) {
    // Extract thinking/reasoning content from non-streaming response
    String? thinkingContent;

    // Check for reasoning content in the response
    thinkingContent = responseData['reasoning'] as String? ??
        responseData['thinking'] as String? ??
        responseData['reasoning_content'] as String?;

    // Check in output_text for thinking tags
    final outputText = responseData['output_text'] as String?;
    if (outputText != null && ReasoningUtils.containsThinkingTags(outputText)) {
      final thinkMatch = RegExp(
        r'<think>(.*?)</think>',
        dotAll: true,
      ).firstMatch(outputText);
      if (thinkMatch != null) {
        thinkingContent = thinkMatch.group(1)?.trim();
        // Update the response to remove thinking tags
        responseData['output_text'] =
            ReasoningUtils.filterThinkingContent(outputText);
      }
    }

    return OpenAIResponsesResponse(responseData, thinkingContent);
  }

  /// Parse streaming events
  List<ChatStreamEvent> _parseStreamEvents(String chunk) {
    final events = <ChatStreamEvent>[];

    // Parse SSE chunk
    final json = client.parseSSEChunk(chunk);
    if (json == null) return events;

    // Use existing stream parsing logic with proper state tracking
    final parsedEvents = _parseStreamEventWithReasoning(
      json,
      _hasReasoningContent,
      _lastChunk,
      _thinkingBuffer,
    );

    events.addAll(parsedEvents);
    return events;
  }

  /// Reset stream state (call this when starting a new stream)
  void _resetStreamState() {
    _hasReasoningContent = false;
    _lastChunk = '';
    _thinkingBuffer.clear();
  }

  /// Parse stream events with reasoning support
  List<ChatStreamEvent> _parseStreamEventWithReasoning(
    Map<String, dynamic> json,
    bool hasReasoningContent,
    String lastChunk,
    StringBuffer thinkingBuffer,
  ) {
    final events = <ChatStreamEvent>[];

    // Handle reasoning content using reasoning utils
    final reasoningContent = ReasoningUtils.extractReasoningContent(json);

    if (reasoningContent != null && reasoningContent.isNotEmpty) {
      thinkingBuffer.write(reasoningContent);
      _hasReasoningContent = true; // Update state
      events.add(ThinkingDeltaEvent(reasoningContent));
      return events;
    }

    // Handle regular content from output_text_delta
    final content = json['output_text_delta'] as String?;
    if (content != null && content.isNotEmpty) {
      // Update last chunk for reasoning detection
      _lastChunk = content;

      // Check reasoning status using utils
      final reasoningResult = ReasoningUtils.checkReasoningStatus(
        delta: {'content': content}, // Adapt to reasoning utils format
        hasReasoningContent: _hasReasoningContent,
        lastChunk: lastChunk,
      );

      // Update state based on reasoning detection
      _hasReasoningContent = reasoningResult.hasReasoningContent;

      // Filter out thinking tags for models that use <think> tags
      if (ReasoningUtils.containsThinkingTags(content)) {
        // Extract thinking content and add to buffer
        final thinkMatch = RegExp(
          r'<think>(.*?)</think>',
          dotAll: true,
        ).firstMatch(content);
        if (thinkMatch != null) {
          final thinkingText = thinkMatch.group(1)?.trim();
          if (thinkingText != null && thinkingText.isNotEmpty) {
            thinkingBuffer.write(thinkingText);
            events.add(ThinkingDeltaEvent(thinkingText));
          }
        }
        // Don't emit content that contains thinking tags
        return events;
      }

      events.add(TextDeltaEvent(content));
    }

    // Handle tool calls (if supported in Responses API)
    final toolCalls = json['tool_calls'] as List?;
    if (toolCalls != null && toolCalls.isNotEmpty) {
      final toolCall = toolCalls.first as Map<String, dynamic>;
      if (toolCall.containsKey('id') && toolCall.containsKey('function')) {
        try {
          events.add(ToolCallDeltaEvent(ToolCall.fromJson(toolCall)));
        } catch (e) {
          // Skip malformed tool calls
          client.logger.warning('Failed to parse tool call: $e');
        }
      }
    }

    // Check for finish reason
    final finishReason = json['finish_reason'] as String?;
    if (finishReason != null) {
      final usage = json['usage'] as Map<String, dynamic>?;
      final thinkingContent =
          thinkingBuffer.isNotEmpty ? thinkingBuffer.toString() : null;

      final response = OpenAIResponsesResponse({
        'output_text': '',
        if (usage != null) 'usage': usage,
      }, thinkingContent);

      events.add(CompletionEvent(response));

      // Reset state after completion
      _resetStreamState();
    }

    return events;
  }
}

/// OpenAI Responses API response implementation
class OpenAIResponsesResponse implements ChatResponse {
  final Map<String, dynamic> _rawResponse;
  final String? _thinkingContent;

  OpenAIResponsesResponse(this._rawResponse, [this._thinkingContent]);

  @override
  String? get text {
    return _rawResponse['output_text'] as String?;
  }

  @override
  List<ToolCall>? get toolCalls {
    final toolCalls = _rawResponse['tool_calls'] as List?;
    if (toolCalls == null) return null;

    return toolCalls
        .map((tc) => ToolCall.fromJson(tc as Map<String, dynamic>))
        .toList();
  }

  @override
  UsageInfo? get usage {
    final usageData = _rawResponse['usage'] as Map<String, dynamic>?;
    if (usageData == null) return null;

    return UsageInfo.fromJson(usageData);
  }

  @override
  String? get thinking => _thinkingContent;

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
