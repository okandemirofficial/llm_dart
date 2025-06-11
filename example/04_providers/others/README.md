# 🔧 Other Providers Examples

Additional AI providers and specialized integrations.

## 📁 Examples

### 🚀 [xai_grok.dart](xai_grok.dart)

**X.AI Grok Integration**
- Grok model access and configuration

### 🔗 [openai_compatible.dart](openai_compatible.dart)

**OpenAI-Compatible Providers Demo**
- All OpenAI-compatible providers in one example
- DeepSeek, Groq, xAI, OpenRouter, GitHub Copilot, Together AI
- Provider comparison and selection
- Unified interface demonstration
- Fallback strategies and best practices

## 🚀 Quick Start

### X.AI Grok

```dart
// X.AI Grok usage
final grokProvider = await ai()
    .xai()
    .apiKey('your-xai-api-key')
    .model('grok-beta')
    .temperature(0.7)
    .build();

final response = await grokProvider.chat([
  ChatMessage.user('Tell me something interesting about AI!')
]);
```

### OpenAI-Compatible Providers

```dart
// DeepSeek (OpenAI-compatible)
final deepseek = await ai()
    .deepseekOpenAI()
    .apiKey('your-deepseek-key')
    .model('deepseek-chat')
    .build();

// Groq (OpenAI-compatible)
final groq = await ai()
    .groqOpenAI()
    .apiKey('your-groq-key')
    .model('llama-3.3-70b-versatile')
    .build();

// OpenRouter
final openrouter = await ai()
    .openRouter()
    .apiKey('your-openrouter-key')
    .model('openai/gpt-4')
    .build();
```

## � Run Examples

```bash
# X.AI Grok example
dart run xai_grok.dart

# All OpenAI-compatible providers demo
dart run openai_compatible.dart
```

## �🔗 Related Examples

- [Core Features](../../02_core_features/) - Basic functionality
- [Advanced Features](../../03_advanced_features/) - Custom providers
- [Main Providers](../) - Core provider examples
