import '../../models/tool_models.dart';
import '../../models/chat_models.dart';
import '../../core/config.dart';
import '../../core/provider_defaults.dart';

/// Anthropic provider configuration
///
/// This class contains all configuration options for the Anthropic providers.
/// It's extracted from the main provider to improve modularity and reusability.
///
/// **API Documentation:**
/// - Models Overview: https://docs.anthropic.com/en/docs/models-overview
/// - Extended Thinking: https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking
/// - Vision: https://docs.anthropic.com/en/docs/build-with-claude/vision
/// - Tool Use: https://docs.anthropic.com/en/docs/tool-use
/// - PDF Support: https://docs.anthropic.com/en/docs/build-with-claude/pdf-support
/// - System Prompt Caching: https://docs.anthropic.com/en/docs/build-with-claude/system-prompt-caching
class AnthropicConfig {
  final String apiKey;
  final String baseUrl;
  final String model;
  final int? maxTokens;
  final double? temperature;
  final String? systemPrompt;
  final String? cachedSystemPrompt;
  final Duration? timeout;
  final bool stream;
  final double? topP;
  final int? topK;
  final List<Tool>? tools;
  final ToolChoice? toolChoice;
  final bool reasoning;
  final int? thinkingBudgetTokens;
  final bool interleavedThinking;
  final List<String>? stopSequences;
  final String? user;
  final ServiceTier? serviceTier;

  /// Reference to original LLMConfig for accessing extensions
  final LLMConfig? _originalConfig;

  const AnthropicConfig({
    required this.apiKey,
    this.baseUrl = ProviderDefaults.anthropicBaseUrl,
    this.model = ProviderDefaults.anthropicDefaultModel,
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.cachedSystemPrompt,
    this.timeout,
    this.stream = false,
    this.topP,
    this.topK,
    this.tools,
    this.toolChoice,
    this.reasoning = false,
    this.thinkingBudgetTokens,
    this.interleavedThinking = false,
    this.stopSequences,
    this.user,
    this.serviceTier,
    LLMConfig? originalConfig,
  }) : _originalConfig = originalConfig;

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

      topP: config.topP,
      topK: config.topK,
      tools: config.tools,
      toolChoice: config.toolChoice,
      // Common parameters
      stopSequences: config.stopSequences,
      user: config.user,
      serviceTier: config.serviceTier,
      // Anthropic-specific extensions
      cachedSystemPrompt: config.getExtension<String>('cachedSystemPrompt'),
      reasoning: config.getExtension<bool>('reasoning') ?? false,
      thinkingBudgetTokens: config.getExtension<int>('thinkingBudgetTokens'),
      interleavedThinking:
          config.getExtension<bool>('interleavedThinking') ?? false,
      originalConfig: config,
    );
  }

  /// Get extension value from original config
  T? getExtension<T>(String key) => _originalConfig?.getExtension<T>(key);

  /// Check if this model supports reasoning/thinking
  ///
  /// **Reference:** https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking
  ///
  /// Based on official Anthropic documentation, extended thinking is supported in:
  /// - Claude Opus 4 (claude-opus-4-20250514)
  /// - Claude Sonnet 4 (claude-sonnet-4-20250514)
  /// - Claude Sonnet 3.7 (claude-3-7-sonnet-20250219)
  ///
  /// Note: The exact model names may vary, so we check patterns
  bool get supportsReasoning {
    return model == 'claude-opus-4-20250514' ||
        model == 'claude-sonnet-4-20250514' ||
        model == 'claude-3-7-sonnet-20250219' ||
        model.contains('claude-3-7-sonnet') ||
        model.contains('claude-4') ||
        model.contains('claude-opus-4') ||
        model.contains('claude-sonnet-4') ||
        reasoning; // Allow explicit override
  }

  /// Check if this model supports vision
  ///
  /// **Reference:** https://docs.anthropic.com/en/docs/build-with-claude/vision
  bool get supportsVision {
    // Most Claude 3+ models support vision
    return model.contains('claude-3') || model.contains('claude-4');
  }

  /// Check if this model supports tool calling
  ///
  /// **Reference:** https://docs.anthropic.com/en/docs/tool-use
  bool get supportsToolCalling {
    // All modern Claude models support tool calling
    return !model.contains('claude-1') && !model.contains('claude-2');
  }

  /// Check if this model supports interleaved thinking
  ///
  /// **Reference:** https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking
  bool get supportsInterleavedThinking {
    // Only Claude 4 models support interleaved thinking
    return model.contains('claude-4');
  }

  /// Check if this model supports PDF documents
  ///
  /// **Reference:** https://docs.anthropic.com/en/docs/build-with-claude/pdf-support
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
    String? cachedSystemPrompt,
    Duration? timeout,
    bool? stream,
    double? topP,
    int? topK,
    List<Tool>? tools,
    ToolChoice? toolChoice,
    bool? reasoning,
    int? thinkingBudgetTokens,
    bool? interleavedThinking,
    List<String>? stopSequences,
    String? user,
    ServiceTier? serviceTier,
  }) =>
      AnthropicConfig(
        apiKey: apiKey ?? this.apiKey,
        baseUrl: baseUrl ?? this.baseUrl,
        model: model ?? this.model,
        maxTokens: maxTokens ?? this.maxTokens,
        temperature: temperature ?? this.temperature,
        systemPrompt: systemPrompt ?? this.systemPrompt,
        cachedSystemPrompt: cachedSystemPrompt ?? this.cachedSystemPrompt,
        timeout: timeout ?? this.timeout,
        stream: stream ?? this.stream,
        topP: topP ?? this.topP,
        topK: topK ?? this.topK,
        tools: tools ?? this.tools,
        toolChoice: toolChoice ?? this.toolChoice,
        reasoning: reasoning ?? this.reasoning,
        thinkingBudgetTokens: thinkingBudgetTokens ?? this.thinkingBudgetTokens,
        interleavedThinking: interleavedThinking ?? this.interleavedThinking,
        stopSequences: stopSequences ?? this.stopSequences,
        user: user ?? this.user,
        serviceTier: serviceTier ?? this.serviceTier,
      );
}
