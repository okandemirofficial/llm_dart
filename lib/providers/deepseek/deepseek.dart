/// Modular DeepSeek Provider
///
/// This library provides a modular implementation of the DeepSeek provider
///
/// **Key Benefits:**
/// - Single Responsibility: Each module handles one capability
/// - Easier Testing: Modules can be tested independently
/// - Better Maintainability: Changes isolated to specific modules
/// - Cleaner Code: Smaller, focused classes
/// - Reusability: Modules can be reused across providers
///
/// **Usage:**
/// ```dart
/// import 'package:llm_dart/providers/deepseek/deepseek.dart';
///
/// final provider = DeepSeekProvider(DeepSeekConfig(
///   apiKey: 'your-api-key',
///   model: 'deepseek-chat',
/// ));
///
/// // Use chat capability
/// final response = await provider.chat(messages);
/// ```

import 'config.dart';
import 'provider.dart';

// Core exports
export 'config.dart';
export 'client.dart';
export 'provider.dart';

// Capability modules
export 'chat.dart';

/// Create a DeepSeek provider with default configuration
DeepSeekProvider createDeepSeekProvider({
  required String apiKey,
  String? model,
  String? baseUrl,
  int? maxTokens,
  double? temperature,
  String? systemPrompt,
  Duration? timeout,
  bool? stream,
  double? topP,
  int? topK,
}) {
  final config = DeepSeekConfig(
    apiKey: apiKey,
    model: model ?? 'deepseek-chat',
    baseUrl: baseUrl ?? 'https://api.deepseek.com/v1/',
    maxTokens: maxTokens,
    temperature: temperature,
    systemPrompt: systemPrompt,
    timeout: timeout,
    stream: stream ?? false,
    topP: topP,
    topK: topK,
  );

  return DeepSeekProvider(config);
}

/// Create a DeepSeek provider for chat
DeepSeekProvider createDeepSeekChatProvider({
  required String apiKey,
  String model = 'deepseek-chat',
  String? systemPrompt,
  double? temperature,
  int? maxTokens,
}) {
  return createDeepSeekProvider(
    apiKey: apiKey,
    model: model,
    systemPrompt: systemPrompt,
    temperature: temperature,
    maxTokens: maxTokens,
  );
}

/// Create a DeepSeek provider for reasoning tasks
DeepSeekProvider createDeepSeekReasoningProvider({
  required String apiKey,
  String model = 'deepseek-r1',
  String? systemPrompt,
  double? temperature,
  int? maxTokens,
}) {
  return createDeepSeekProvider(
    apiKey: apiKey,
    model: model,
    systemPrompt: systemPrompt,
    temperature: temperature,
    maxTokens: maxTokens,
  );
}

/// Create a DeepSeek provider for code generation
DeepSeekProvider createDeepSeekCoderProvider({
  required String apiKey,
  String model = 'deepseek-coder',
  String? systemPrompt,
  double? temperature,
  int? maxTokens,
}) {
  return createDeepSeekProvider(
    apiKey: apiKey,
    model: model,
    systemPrompt: systemPrompt,
    temperature: temperature,
    maxTokens: maxTokens,
  );
}

/// Create a DeepSeek provider for vision tasks
DeepSeekProvider createDeepSeekVisionProvider({
  required String apiKey,
  String model = 'deepseek-vl-chat',
  String? systemPrompt,
  double? temperature,
  int? maxTokens,
}) {
  return createDeepSeekProvider(
    apiKey: apiKey,
    model: model,
    systemPrompt: systemPrompt,
    temperature: temperature,
    maxTokens: maxTokens,
  );
}
