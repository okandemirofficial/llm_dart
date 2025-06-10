# LLM Dart Library

[![pub package](https://img.shields.io/pub/v/llm_dart.svg)](https://pub.dev/packages/llm_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/Dart-3.5.0+-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.8.0+-blue.svg)](https://flutter.dev)

A modular Dart library for AI provider interactions. This library provides a unified interface for interacting with different AI providers using Dio for HTTP requests.

**🧠 Full access to model thinking processes** - llm_dart provides direct access to the internal reasoning and thought processes of supported AI models (Claude, OpenAI o1, DeepSeek, Gemini), giving you unprecedented insight into how AI models arrive at their conclusions.

## 🚀 Quick Navigation

| I want to... | Go to |
|--------------|-------|
| **Get started in 5 minutes** | [Quick Start](#quick-start) → [5-minute example](example/01_getting_started/quick_start.dart) |
| **Build a chatbot** | [Chatbot example](example/05_use_cases/chatbot.dart) |
| **Add voice capabilities** | [ElevenLabs examples](example/04_providers/elevenlabs/) |
| **Access AI thinking processes** | [Reasoning examples](example/03_advanced_features/reasoning_models.dart) |
| **Create a web API** | [Web service example](example/05_use_cases/web_service.dart) |
| **Use local AI models** | [Ollama examples](example/04_providers/ollama/) |
| **Connect external tools** | [MCP integration](example/06_mcp_integration/) |
| **See a real app** | [Yumcha](https://github.com/Latias94/yumcha) - Actively developed Flutter app |
| **Compare providers** | [Provider comparison](example/01_getting_started/provider_comparison.dart) |
| **Learn advanced features** | [Advanced examples](example/03_advanced_features/) |

## Features

- **Multi-provider support**: OpenAI, Anthropic (Claude), Google (Gemini), DeepSeek, Groq, Ollama, xAI (Grok), ElevenLabs
- **🧠 Thinking process support**: Access to model reasoning and thought processes (Claude, DeepSeek, Gemini)
- **🎵 Unified audio capabilities**: Text-to-speech, speech-to-text, and audio processing with feature discovery
- **🖼️ Image generation & processing**: DALL-E integration, image editing, variations, and multi-modal support
- **📁 File management**: Unified file operations across providers (OpenAI, Anthropic)
- **Unified API**: Consistent interface across all providers with capability-based design
- **Builder pattern**: Fluent API for easy configuration and provider setup
- **Streaming support**: Real-time response streaming with thinking process access
- **Tool calling**: Advanced function calling with enhanced patterns
- **Structured output**: JSON schema support with validation
- **Error handling**: Comprehensive error types with graceful degradation
- **Type safety**: Full Dart type safety with modular architecture
- **MCP Integration**: Model Context Protocol support for external tool connections

## Supported Providers

| Provider | Chat | Streaming | Tools | Thinking | Audio | Image | Files | Notes |
|----------|------|-----------|-------|----------|-------|-------|-------|-------|
| OpenAI | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | GPT models, DALL-E, o1 reasoning |
| Anthropic | ✅ | ✅ | ✅ | 🧠 | ❌ | ✅ | ✅ | Claude models with thinking |
| Google | ✅ | ✅ | ✅ | 🧠 | ❌ | ❌ | ❌ | Gemini models with reasoning |
| DeepSeek | ✅ | ✅ | ✅ | 🧠 | ❌ | ❌ | ❌ | DeepSeek reasoning models |
| Groq | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | Ultra-fast inference |
| Ollama | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | Local models, privacy-focused |
| xAI | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | Grok models with personality |
| ElevenLabs | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | Advanced voice synthesis |

**🧠 Thinking Process Support**: Access to model's internal reasoning and thought processes
**🎵 Audio Support**: Text-to-speech, speech-to-text, and audio processing
**🖼️ Image Support**: Image generation, editing, and multi-modal processing
**📁 File Support**: File upload, management, and processing capabilities

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  llm_dart: ^0.2.0
```

Then run:

```bash
dart pub get
```

Or install directly using:

```bash
dart pub add llm_dart
```

## Quick Start

### Basic Usage

```dart
import 'package:llm_dart/llm_dart.dart';

void main() async {
  // Method 1: Using the new ai() builder with provider methods
  final provider = await ai()
      .openai()
      .apiKey('your-api-key')
      .model('gpt-4')
      .temperature(0.7)
      .build();

  // Method 2: Using provider() with string ID (extensible)
  final provider2 = await ai()
      .provider('openai')
      .apiKey('your-api-key')
      .model('gpt-4')
      .temperature(0.7)
      .build();

  // Method 3: Using convenience function
  final directProvider = await createProvider(
    providerId: 'openai',
    apiKey: 'your-api-key',
    model: 'gpt-4',
    temperature: 0.7,
  );

  // Simple chat
  final messages = [ChatMessage.user('Hello, world!')];
  final response = await provider.chat(messages);
  print(response.text);

  // Access thinking process (for supported models)
  if (response.thinking != null) {
    print('Model thinking: ${response.thinking}');
  }
}
```

### Streaming with DeepSeek Reasoning

```dart
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

// Create DeepSeek provider for streaming with thinking
final provider = await ai()
    .deepseek()
    .apiKey('your-deepseek-key')
    .model('deepseek-reasoner')
    .temperature(0.7)
    .build();

final messages = [ChatMessage.user('What is 15 + 27? Show your work.')];

// Stream with real-time thinking process
await for (final event in provider.chatStream(messages)) {
  switch (event) {
    case ThinkingDeltaEvent(delta: final delta):
      // Show AI's thinking process in gray
      stdout.write('\x1B[90m$delta\x1B[0m');
      break;
    case TextDeltaEvent(delta: final delta):
      // Show final answer
      stdout.write(delta);
      break;
    case CompletionEvent(response: final response):
      print('\n✅ Completed');
      if (response.usage != null) {
        print('Tokens: ${response.usage!.totalTokens}');
      }
      break;
    case ErrorEvent(error: final error):
      print('Error: $error');
      break;
  }
}
```

### 🧠 Thinking Process Access

Access the model's internal reasoning and thought processes:

```dart
// Claude with thinking
final claudeProvider = await ai()
    .anthropic()
    .apiKey('your-anthropic-key')
    .model('claude-3-5-sonnet-20241022')
    .build();

final messages = [
  ChatMessage.user('Solve this step by step: What is 15% of 240?')
];

final response = await claudeProvider.chat(messages);

// Access the final answer
print('Answer: ${response.text}');

// Access the thinking process
if (response.thinking != null) {
  print('Claude\'s thinking process:');
  print(response.thinking);
}

// DeepSeek with reasoning
final deepseekProvider = await ai()
    .deepseek()
    .apiKey('your-deepseek-key')
    .model('deepseek-reasoner')
    .temperature(0.7)
    .build();

final reasoningResponse = await deepseekProvider.chat(messages);
print('DeepSeek reasoning: ${reasoningResponse.thinking}');
```

### Tool Calling

```dart
final tools = [
  Tool.function(
    name: 'get_weather',
    description: 'Get weather for a location',
    parameters: ParametersSchema(
      schemaType: 'object',
      properties: {
        'location': ParameterProperty(
          propertyType: 'string',
          description: 'City name',
        ),
      },
      required: ['location'],
    ),
  ),
];

final response = await provider.chatWithTools(messages, tools);
if (response.toolCalls != null) {
  for (final call in response.toolCalls!) {
    print('Tool: ${call.function.name}');
    print('Args: ${call.function.arguments}');
  }
}
```

## Provider Examples

### OpenAI

```dart
final provider = await createProvider(
  providerId: 'openai',
  apiKey: 'sk-...',
  model: 'gpt-4',
  temperature: 0.7,
  extensions: {'reasoningEffort': 'medium'}, // For reasoning models
);
```

### Anthropic (with Thinking Process)

```dart
final provider = await ai()
    .anthropic()
    .apiKey('sk-ant-...')
    .model('claude-3-5-sonnet-20241022')
    .build();

final response = await provider.chat([
  ChatMessage.user('Explain quantum computing step by step')
]);

// Access Claude's thinking process
print('Final answer: ${response.text}');
if (response.thinking != null) {
  print('Claude\'s reasoning: ${response.thinking}');
}
```

### DeepSeek (with Reasoning)

```dart
final provider = await ai()
    .deepseek()
    .apiKey('your-deepseek-key')
    .model('deepseek-reasoner')
    .build();

final response = await provider.chat([
  ChatMessage.user('Solve this logic puzzle step by step')
]);

// Access DeepSeek's reasoning process
print('Solution: ${response.text}');
if (response.thinking != null) {
  print('DeepSeek\'s reasoning: ${response.thinking}');
}
```

### Ollama

```dart
final provider = ollama(
  baseUrl: 'http://localhost:11434',
  model: 'llama3.2',
  // No API key needed for local Ollama
);
```

### ElevenLabs (Audio Processing)

```dart
final provider = await ai()
    .elevenlabs()
    .apiKey('your-elevenlabs-key')
    .voiceId('JBFqnCBsd6RMkjVDRZzb') // George voice
    .stability(0.7)
    .similarityBoost(0.9)
    .style(0.1)
    .build();

// Check supported audio features
final audioCapability = provider as AudioCapability;
final features = audioCapability.supportedFeatures;
print('Supports TTS: ${features.contains(AudioFeature.textToSpeech)}');

// Text to speech with advanced options
final ttsResponse = await audioCapability.textToSpeech(TTSRequest(
  text: 'Hello world! This is ElevenLabs speaking.',
  voice: 'JBFqnCBsd6RMkjVDRZzb',
  model: 'eleven_multilingual_v2',
  format: 'mp3_44100_128',
  includeTimestamps: true,
));
await File('output.mp3').writeAsBytes(ttsResponse.audioData);

// Speech to text (if supported)
if (features.contains(AudioFeature.speechToText)) {
  final audioData = await File('input.mp3').readAsBytes();
  final sttResponse = await audioCapability.speechToText(
    STTRequest.fromAudio(audioData, model: 'scribe_v1')
  );
  print(sttResponse.text);
}

// Convenience methods
final quickSpeech = await audioCapability.speech('Quick TTS');
final quickTranscription = await audioCapability.transcribeFile('audio.mp3');
```

## Error Handling

```dart
try {
  final response = await provider.chatWithTools(messages, null);
  print(response.text);
} on AuthError catch (e) {
  print('Authentication failed: $e');
} on ProviderError catch (e) {
  print('Provider error: $e');
} on HttpError catch (e) {
  print('Network error: $e');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Architecture

### Capability-Based Design

The library uses a capability-based interface design instead of monolithic "god interfaces":

```dart
// Core capabilities
abstract class ChatCapability {
  Future<ChatResponse> chat(List<ChatMessage> messages);
  Stream<ChatStreamEvent> chatStream(List<ChatMessage> messages);
}

abstract class EmbeddingCapability {
  Future<List<List<double>>> embed(List<String> input);
}

// Providers implement only the capabilities they support
class OpenAIProvider implements ChatCapability, EmbeddingCapability {
  // Implementation
}
```

### Provider Registry

The library includes an extensible provider registry system:

```dart
// Check available providers
final providers = LLMProviderRegistry.getRegisteredProviders();
print('Available: $providers'); // ['openai', 'anthropic', ...]

// Check capabilities
final supportsChat = LLMProviderRegistry.supportsCapability('openai', LLMCapability.chat);
print('OpenAI supports chat: $supportsChat'); // true

// Create providers dynamically
final provider = LLMProviderRegistry.createProvider('openai', config);
```

### Custom Providers

You can register custom providers:

```dart
// Create a custom provider factory
class MyCustomProviderFactory implements LLMProviderFactory<ChatCapability> {
  @override
  String get providerId => 'my_custom';

  @override
  Set<LLMCapability> get supportedCapabilities => {LLMCapability.chat};

  @override
  ChatCapability create(LLMConfig config) => MyCustomProvider(config);

  // ... other methods
}

// Register it
LLMProviderRegistry.register(MyCustomProviderFactory());

// Use it
final provider = await ai().provider('my_custom').build();
```

## Configuration

All providers support common configuration options:

- `apiKey`: API key for authentication
- `baseUrl`: Custom API endpoint
- `model`: Model name to use
- `temperature`: Sampling temperature (0.0-1.0)
- `maxTokens`: Maximum tokens to generate
- `systemPrompt`: System message
- `timeout`: Request timeout
- `topP`, `topK`: Sampling parameters

### Provider-Specific Extensions

Use the extension system for provider-specific features:

```dart
final provider = await ai()
    .openai()
    .apiKey('your-key')
    .model('gpt-4')
    .reasoningEffort(ReasoningEffort.high)  // OpenAI-specific
    .extension('voice', 'alloy')           // OpenAI TTS voice
    .build();
```

## Examples

See the **[example directory](example)** for comprehensive usage examples organized by learning path:

### 🟢 Getting Started (5-30 minutes)
**Perfect for first-time users**

- **[quick_start.dart](example/01_getting_started/quick_start.dart)** - 5-minute quick experience with multiple providers
- **[provider_comparison.dart](example/01_getting_started/provider_comparison.dart)** - Compare providers and choose the right one
- **[basic_configuration.dart](example/01_getting_started/basic_configuration.dart)** - Essential configuration patterns

### 🟡 Core Features (30-60 minutes)
**Master the essential functionality**

- **[chat_basics.dart](example/02_core_features/chat_basics.dart)** - Foundation of all AI interactions
- **[streaming_chat.dart](example/02_core_features/streaming_chat.dart)** - Real-time streaming responses
- **[tool_calling.dart](example/02_core_features/tool_calling.dart)** - Function calling capabilities
- **[enhanced_tool_calling.dart](example/02_core_features/enhanced_tool_calling.dart)** - Advanced tool calling patterns
- **[structured_output.dart](example/02_core_features/structured_output.dart)** - JSON schema and validation
- **[error_handling.dart](example/02_core_features/error_handling.dart)** - Production-ready error handling

### 🔴 Advanced Features (1-2 hours)
**Cutting-edge AI capabilities**

- **[reasoning_models.dart](example/03_advanced_features/reasoning_models.dart)** - 🧠 AI thinking processes and reasoning
- **[multi_modal.dart](example/03_advanced_features/multi_modal.dart)** - Images, audio, and file processing
- **[custom_providers.dart](example/03_advanced_features/custom_providers.dart)** - Build your own AI provider
- **[performance_optimization.dart](example/03_advanced_features/performance_optimization.dart)** - Production optimization techniques

### 🎯 Provider-Specific Examples
**Deep dive into specific providers**

- **[OpenAI](example/04_providers/openai/)** - GPT models, DALL-E, reasoning, assistants
- **[Anthropic](example/04_providers/anthropic/)** - Claude models, extended thinking, file handling
- **[Google](example/04_providers/google/)** - Gemini models and multi-modal capabilities
- **[DeepSeek](example/04_providers/deepseek/)** - Cost-effective reasoning models
- **[Groq](example/04_providers/groq/)** - Ultra-fast inference
- **[Ollama](example/04_providers/ollama/)** - Local models and privacy-focused AI
- **[ElevenLabs](example/04_providers/elevenlabs/)** - Advanced voice synthesis and recognition
- **[Others](example/04_providers/others/)** - XAI Grok and emerging providers

### 🎪 Real-World Use Cases
**Complete application examples**

- **[chatbot.dart](example/05_use_cases/chatbot.dart)** - Complete chatbot with personality and context management
- **[cli_tool.dart](example/05_use_cases/cli_tool.dart)** - Command-line AI assistant with multiple providers
- **[web_service.dart](example/05_use_cases/web_service.dart)** - HTTP API with AI capabilities, authentication, and rate limiting

### 🌟 Real-World Application
**Actively developed application built with LLM Dart**

- **[Yumcha](https://github.com/Latias94/yumcha)** - Cross-platform AI chat application actively developed by the creator of LLM Dart, showcasing real-world integration with multiple providers, real-time streaming, and advanced features

### 🔗 MCP Integration
**Connect LLMs with external tools**

- **[mcp_concept_demo.dart](example/06_mcp_integration/mcp_concept_demo.dart)** - 🎯 **START HERE** - Core MCP concepts
- **[simple_mcp_demo.dart](example/06_mcp_integration/simple_mcp_demo.dart)** - Working MCP + LLM integration
- **[test_all_examples.dart](example/06_mcp_integration/test_all_examples.dart)** - 🧪 **ONE-CLICK TEST** - Test all examples
- **[Advanced MCP examples](example/06_mcp_integration/)** - Custom servers, tool bridges, and more

📖 **[Complete Examples Guide](example)** - Organized learning paths, detailed documentation, and best practices.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

This library is inspired by the Rust [graniet/llm](https://github.com/graniet/llm) library and follows similar patterns adapted for Dart.
