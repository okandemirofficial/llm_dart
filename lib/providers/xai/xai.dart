/// Modular xAI Provider
///
/// This library provides a modular implementation of the xAI provider
/// following the same architecture pattern as the OpenAI provider.
///
/// **Key Features:**
/// - Grok models with real-time search capabilities
/// - Reasoning and thinking support
/// - Modular architecture for easy maintenance
/// - Support for structured outputs
/// - Search parameters for web and news sources
///
/// **Usage:**
/// ```dart
/// import 'package:llm_dart/providers/xai/xai.dart';
///
/// final provider = XAIProvider(XAIConfig(
///   apiKey: 'your-api-key',
///   model: 'grok-2-latest',
/// ));
///
/// // Use chat capability
/// final response = await provider.chat(messages);
///
/// // Use search with Grok
/// final searchConfig = XAIConfig(
///   apiKey: 'your-api-key',
///   model: 'grok-2-latest',
///   searchParameters: SearchParameters(
///     mode: 'auto',
///     sources: [SearchSource(sourceType: 'web')],
///   ),
/// );
/// final searchProvider = XAIProvider(searchConfig);
/// final searchResponse = await searchProvider.chat([
///   ChatMessage.user('What are the latest developments in AI?')
/// ]);
/// ```

import 'config.dart';
import 'provider.dart';

// Core exports
export 'config.dart';
export 'client.dart';
export 'provider.dart';

// Capability modules
export 'chat.dart';
export 'embedding.dart';

/// Create an xAI provider with default settings
XAIProvider createXAIProvider({
  required String apiKey,
  String model = 'grok-2-latest',
  String baseUrl = 'https://api.x.ai/v1/',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
  SearchParameters? searchParameters,
}) {
  final config = XAIConfig(
    apiKey: apiKey,
    model: model,
    baseUrl: baseUrl,
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
    searchParameters: searchParameters,
  );

  return XAIProvider(config);
}

/// Create an xAI provider with search capabilities
XAIProvider createXAISearchProvider({
  required String apiKey,
  String model = 'grok-2-latest',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
  String searchMode = 'auto',
  List<SearchSource>? sources,
  int? maxSearchResults,
  String? fromDate,
  String? toDate,
}) {
  final searchParams = SearchParameters(
    mode: searchMode,
    sources: sources ?? [const SearchSource(sourceType: 'web')],
    maxSearchResults: maxSearchResults,
    fromDate: fromDate,
    toDate: toDate,
  );

  final config = XAIConfig(
    apiKey: apiKey,
    model: model,
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
    searchParameters: searchParams,
  );

  return XAIProvider(config);
}

/// Create an xAI provider for Grok Vision
XAIProvider createGrokVisionProvider({
  required String apiKey,
  String model = 'grok-vision-beta',
  double? temperature,
  int? maxTokens,
  String? systemPrompt,
}) {
  final config = XAIConfig(
    apiKey: apiKey,
    model: model,
    temperature: temperature,
    maxTokens: maxTokens,
    systemPrompt: systemPrompt,
  );

  return XAIProvider(config);
}
