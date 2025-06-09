import '../../models/tool_models.dart';
import '../../core/config.dart';

/// Anthropic provider configuration
///
/// This class contains all configuration options for the Anthropic providers.
/// It's extracted from the main provider to improve modularity and reusability.
class AnthropicConfig {
  final String apiKey;
  final String baseUrl;
  final String model;
  final int? maxTokens;
  final double? temperature;
  final String? systemPrompt;
  final Duration? timeout;
  final bool stream;
  final double? topP;
  final int? topK;
  final List<Tool>? tools;
  final ToolChoice? toolChoice;
  final bool reasoning;
  final int? thinkingBudgetTokens;
  final bool interleavedThinking;

  const AnthropicConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.anthropic.com/v1/',
    this.model = 'claude-3-5-sonnet-20241022',
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.timeout,
    this.stream = false,
    this.topP,
    this.topK,
    this.tools,
    this.toolChoice,
    this.reasoning = false,
    this.thinkingBudgetTokens,
    this.interleavedThinking = false,
  });

  /// Create AnthropicConfig from unified LLMConfig
  factory AnthropicConfig.fromLLMConfig(LLMConfig config) {
    return AnthropicConfig(
      apiKey: config.apiKey!,
      baseUrl: config.baseUrl,
      model: config.model,
      maxTokens: config.maxTokens,
      temperature: config.temperature,
      systemPrompt: config.systemPrompt,
      timeout: config.timeout,
      stream: config.stream,
      topP: config.topP,
      topK: config.topK,
      tools: config.tools,
      toolChoice: config.toolChoice,
      // Anthropic-specific extensions
      reasoning: config.getExtension<bool>('reasoning') ?? false,
      thinkingBudgetTokens: config.getExtension<int>('thinkingBudgetTokens'),
      interleavedThinking:
          config.getExtension<bool>('interleavedThinking') ?? false,
    );
  }

  /// Check if this model supports reasoning/thinking
  /// Based on official Anthropic documentation
  bool get supportsReasoning {
    // According to official docs, extended thinking is supported in:
    // - Claude Opus 4 (claude-opus-4-20250514)
    // - Claude Sonnet 4 (claude-sonnet-4-20250514)
    // - Claude Sonnet 3.7 (claude-3-7-sonnet-20250219)
    return model == 'claude-opus-4-20250514' ||
        model == 'claude-sonnet-4-20250514' ||
        model == 'claude-3-7-sonnet-20250219' ||
        model.contains('claude-3-7-sonnet') ||
        model.contains('claude-4') ||
        reasoning; // Allow explicit override
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // Most Claude 3+ models support vision
    return model.contains('claude-3') || model.contains('claude-4');
  }

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // All modern Claude models support tool calling
    return !model.contains('claude-1') && !model.contains('claude-2');
  }

  /// Check if this model supports interleaved thinking
  bool get supportsInterleavedThinking {
    // Only Claude 4 models support interleaved thinking
    return model.contains('claude-4');
  }

  /// Check if this model supports PDF documents
  bool get supportsPDF {
    // Claude 3+ models support PDF documents
    return model.contains('claude-3') || model.contains('claude-4');
  }

  /// Get the maximum thinking budget tokens for this model
  int get maxThinkingBudgetTokens {
    // Based on official documentation, thinking budget can be quite large
    // but should be less than max_tokens
    if (supportsReasoning) {
      return 32000; // Conservative upper limit
    }
    return 0;
  }

  /// Validate thinking configuration
  String? validateThinkingConfig() {
    if (reasoning && !supportsReasoning) {
      return 'Model $model does not support extended thinking. '
          'Supported models: claude-opus-4-20250514, claude-sonnet-4-20250514, claude-3-7-sonnet-20250219';
    }

    if (interleavedThinking && !supportsInterleavedThinking) {
      return 'Model $model does not support interleaved thinking. '
          'Only Claude 4 models support this feature.';
    }

    if (thinkingBudgetTokens != null) {
      if (thinkingBudgetTokens! < 1024) {
        return 'Thinking budget tokens must be at least 1024, got $thinkingBudgetTokens';
      }

      if (thinkingBudgetTokens! > maxThinkingBudgetTokens) {
        return 'Thinking budget tokens ($thinkingBudgetTokens) exceeds maximum ($maxThinkingBudgetTokens) for model $model';
      }
    }

    return null; // Valid
  }

  AnthropicConfig copyWith({
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
    bool? reasoning,
    int? thinkingBudgetTokens,
    bool? interleavedThinking,
  }) =>
      AnthropicConfig(
        apiKey: apiKey ?? this.apiKey,
        baseUrl: baseUrl ?? this.baseUrl,
        model: model ?? this.model,
        maxTokens: maxTokens ?? this.maxTokens,
        temperature: temperature ?? this.temperature,
        systemPrompt: systemPrompt ?? this.systemPrompt,
        timeout: timeout ?? this.timeout,
        stream: stream ?? this.stream,
        topP: topP ?? this.topP,
        topK: topK ?? this.topK,
        tools: tools ?? this.tools,
        toolChoice: toolChoice ?? this.toolChoice,
        reasoning: reasoning ?? this.reasoning,
        thinkingBudgetTokens: thinkingBudgetTokens ?? this.thinkingBudgetTokens,
        interleavedThinking: interleavedThinking ?? this.interleavedThinking,
      );
}
