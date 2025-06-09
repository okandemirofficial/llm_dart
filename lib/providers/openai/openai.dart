/// Modular OpenAI Provider
///
/// This library provides a modular implementation of the OpenAI provider
/// inspired by the async-openai Rust library architecture.
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
/// import 'package:llm_dart/providers/openai/openai.dart';
///
/// final provider = ModularOpenAIProvider(ModularOpenAIConfig(
///   apiKey: 'your-api-key',
///   model: 'gpt-4',
/// ));
///
/// // Use any capability - same external API
/// final response = await provider.chat(messages);
/// final embeddings = await provider.embed(['text']);
/// final audio = await provider.speech('Hello world');
/// ```

import 'config.dart';
import 'provider.dart';

// Core exports
export 'config.dart';
export 'client.dart';
export 'provider.dart';

// Capability modules
export 'chat.dart';
export 'embeddings.dart';
export 'audio.dart';
export 'images.dart';
export 'files.dart';
export 'models.dart';
export 'moderation.dart';
export 'assistants.dart';
export 'completion.dart';

/// Create an OpenAI provider with default settings
OpenAIProvider createOpenAIProvider({
  required String apiKey,
  String model = 'gpt-4',
  String baseUrl = 'https://api.openai.com/v1/',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: model,
    baseUrl: baseUrl,
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return OpenAIProvider(config);
}

/// Create an OpenAI provider for OpenRouter
OpenAIProvider createOpenRouterProvider({
  required String apiKey,
  String model = 'openai/gpt-4',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: model,
    baseUrl: 'https://openrouter.ai/api/v1/',
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return OpenAIProvider(config);
}

/// Create an OpenAI provider for Groq
OpenAIProvider createGroqProvider({
  required String apiKey,
  String model = 'llama-3.1-70b-versatile',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: model,
    baseUrl: 'https://api.groq.com/openai/v1/',
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return OpenAIProvider(config);
}

/// Create an OpenAI provider for DeepSeek
OpenAIProvider createDeepSeekProvider({
  required String apiKey,
  String model = 'deepseek-chat',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: model,
    baseUrl: 'https://api.deepseek.com/v1/',
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return OpenAIProvider(config);
}

/// Create an OpenAI provider for Azure OpenAI
OpenAIProvider createAzureOpenAIProvider({
  required String apiKey,
  required String endpoint,
  required String deploymentName,
  String apiVersion = '2024-02-15-preview',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: deploymentName,
    baseUrl: '$endpoint/openai/deployments/$deploymentName/',
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return OpenAIProvider(config);
}

/// Create an OpenAI provider for GitHub Copilot
OpenAIProvider createCopilotProvider({
  required String apiKey,
  String model = 'gpt-4',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: model,
    baseUrl: 'https://api.githubcopilot.com/chat/completions',
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return OpenAIProvider(config);
}

/// Create an OpenAI provider for Together AI
OpenAIProvider createTogetherProvider({
  required String apiKey,
  String model = 'meta-llama/Llama-3-70b-chat-hf',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: model,
    baseUrl: 'https://api.together.xyz/v1/',
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return OpenAIProvider(config);
}
