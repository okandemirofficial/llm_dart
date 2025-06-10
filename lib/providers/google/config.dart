import '../../models/tool_models.dart';
import '../../models/chat_models.dart';
import '../../core/config.dart';

/// Google AI harm categories
enum HarmCategory {
  harmCategoryUnspecified('HARM_CATEGORY_UNSPECIFIED'),
  harmCategoryDerogatory('HARM_CATEGORY_DEROGATORY'),
  harmCategoryToxicity('HARM_CATEGORY_TOXICITY'),
  harmCategoryViolence('HARM_CATEGORY_VIOLENCE'),
  harmCategorySexual('HARM_CATEGORY_SEXUAL'),
  harmCategoryMedical('HARM_CATEGORY_MEDICAL'),
  harmCategoryDangerous('HARM_CATEGORY_DANGEROUS'),
  harmCategoryHarassment('HARM_CATEGORY_HARASSMENT'),
  harmCategoryHateSpeech('HARM_CATEGORY_HATE_SPEECH'),
  harmCategorySexuallyExplicit('HARM_CATEGORY_SEXUALLY_EXPLICIT'),
  harmCategoryDangerousContent('HARM_CATEGORY_DANGEROUS_CONTENT');

  const HarmCategory(this.value);
  final String value;
}

/// Google AI harm block thresholds
enum HarmBlockThreshold {
  harmBlockThresholdUnspecified('HARM_BLOCK_THRESHOLD_UNSPECIFIED'),
  blockLowAndAbove('BLOCK_LOW_AND_ABOVE'),
  blockMediumAndAbove('BLOCK_MEDIUM_AND_ABOVE'),
  blockOnlyHigh('BLOCK_ONLY_HIGH'),
  blockNone('BLOCK_NONE'),
  off('OFF');

  const HarmBlockThreshold(this.value);
  final String value;
}

/// Google AI safety setting
class SafetySetting {
  final HarmCategory category;
  final HarmBlockThreshold threshold;

  const SafetySetting({
    required this.category,
    required this.threshold,
  });

  Map<String, dynamic> toJson() => {
        'category': category.value,
        'threshold': threshold.value,
      };
}

/// Google (Gemini) provider configuration
///
/// This class contains all configuration options for the Google providers.
/// It's extracted from the main provider to improve modularity and reusability.
class GoogleConfig {
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
  final StructuredOutputFormat? jsonSchema;
  final ReasoningEffort? reasoningEffort;
  final int? thinkingBudgetTokens;
  final bool? includeThoughts;
  final bool? enableImageGeneration;
  final List<String>? responseModalities;
  final List<SafetySetting>? safetySettings;
  final int maxInlineDataSize;
  final int? candidateCount;
  final List<String>? stopSequences;

  /// Reference to original LLMConfig for accessing extensions
  final LLMConfig? _originalConfig;

  const GoogleConfig({
    required this.apiKey,
    this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta/',
    this.model = 'gemini-1.5-flash',
    this.maxTokens,
    this.temperature,
    this.systemPrompt,
    this.timeout,
    this.stream = false,
    this.topP,
    this.topK,
    this.tools,
    this.jsonSchema,
    this.reasoningEffort,
    this.thinkingBudgetTokens,
    this.includeThoughts,
    this.enableImageGeneration,
    this.responseModalities,
    this.safetySettings,
    this.maxInlineDataSize = 20 * 1024 * 1024, // 20MB default
    this.candidateCount,
    this.stopSequences,
    LLMConfig? originalConfig,
  }) : _originalConfig = originalConfig;

  /// Create GoogleConfig from unified LLMConfig
  factory GoogleConfig.fromLLMConfig(LLMConfig config) {
    return GoogleConfig(
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
      // Google-specific extensions
      reasoningEffort: config.getExtension<ReasoningEffort>('reasoningEffort'),
      thinkingBudgetTokens: config.getExtension<int>('thinkingBudgetTokens'),
      includeThoughts: config.getExtension<bool>('includeThoughts'),
      enableImageGeneration: config.getExtension<bool>('enableImageGeneration'),
      responseModalities:
          config.getExtension<List<String>>('responseModalities'),
      safetySettings:
          config.getExtension<List<SafetySetting>>('safetySettings'),
      maxInlineDataSize:
          config.getExtension<int>('maxInlineDataSize') ?? 20 * 1024 * 1024,
      candidateCount: config.getExtension<int>('candidateCount'),
      stopSequences: config.getExtension<List<String>>('stopSequences'),
      originalConfig: config,
    );
  }

  /// Get extension value from original config
  T? getExtension<T>(String key) => _originalConfig?.getExtension<T>(key);

  /// Check if this model supports reasoning/thinking
  bool get supportsReasoning {
    // Gemini 2.0 Flash Thinking models support reasoning
    return model.contains('thinking') ||
        model.contains('gemini-2.0') ||
        model.contains('gemini-exp');
  }

  /// Check if this model supports vision
  bool get supportsVision {
    // Most Gemini models support vision except text-only variants
    return !model.contains('text');
  }

  /// Check if this model supports tool calling
  bool get supportsToolCalling {
    // All modern Gemini models support tool calling
    return true;
  }

  /// Check if this model supports image generation
  bool get supportsImageGeneration {
    // Imagen models and some Gemini models support image generation
    return model.contains('imagen') || enableImageGeneration == true;
  }

  /// Get default safety settings (permissive for development)
  static List<SafetySetting> get defaultSafetySettings => [
        const SafetySetting(
          category: HarmCategory.harmCategoryHarassment,
          threshold: HarmBlockThreshold.blockOnlyHigh,
        ),
        const SafetySetting(
          category: HarmCategory.harmCategoryHateSpeech,
          threshold: HarmBlockThreshold.blockOnlyHigh,
        ),
        const SafetySetting(
          category: HarmCategory.harmCategorySexuallyExplicit,
          threshold: HarmBlockThreshold.blockOnlyHigh,
        ),
        const SafetySetting(
          category: HarmCategory.harmCategoryDangerousContent,
          threshold: HarmBlockThreshold.blockOnlyHigh,
        ),
      ];

  GoogleConfig copyWith({
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
    StructuredOutputFormat? jsonSchema,
    ReasoningEffort? reasoningEffort,
    int? thinkingBudgetTokens,
    bool? includeThoughts,
    bool? enableImageGeneration,
    List<String>? responseModalities,
    List<SafetySetting>? safetySettings,
    int? maxInlineDataSize,
    int? candidateCount,
    List<String>? stopSequences,
  }) =>
      GoogleConfig(
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
        jsonSchema: jsonSchema ?? this.jsonSchema,
        reasoningEffort: reasoningEffort ?? this.reasoningEffort,
        thinkingBudgetTokens: thinkingBudgetTokens ?? this.thinkingBudgetTokens,
        includeThoughts: includeThoughts ?? this.includeThoughts,
        enableImageGeneration:
            enableImageGeneration ?? this.enableImageGeneration,
        responseModalities: responseModalities ?? this.responseModalities,
        safetySettings: safetySettings ?? this.safetySettings,
        maxInlineDataSize: maxInlineDataSize ?? this.maxInlineDataSize,
        candidateCount: candidateCount ?? this.candidateCount,
        stopSequences: stopSequences ?? this.stopSequences,
      );
}
