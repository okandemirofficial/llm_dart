# 🔴 Google (Gemini) Provider Examples

Google's Gemini models offer powerful multi-modal capabilities, large context windows, and advanced reasoning features.

## 📁 Examples

### 🚀 [basic_usage.dart](basic_usage.dart)
**Getting Started with Google Gemini**
- Model selection (Flash, Pro, Ultra)
- Basic configuration and chat
- Reasoning capabilities
- Performance comparison
- Best practices for Gemini

## 🎯 Key Features

### Model Variants
- **Gemini 2.5 Flash**: Fast, cost-effective for most tasks
- **Gemini 2.5 Pro**: Balanced performance and capability
- **Gemini Ultra**: Highest quality for complex tasks

### Unique Capabilities
- **Large Context**: Up to 2M tokens context window
- **Multi-Modal**: Native text, image, video, audio processing
- **Real-Time**: Search integration for current information
- **Reasoning**: Advanced thinking and analysis capabilities

### Configuration Options
- Temperature control for creativity
- Safety settings customization
- Response format specification
- Thinking budget allocation

## 🚀 Quick Start

```dart
// Basic Gemini usage
final provider = await ai()
    .google()
    .apiKey('your-google-api-key')
    .model('gemini-2.5-flash-preview-05-20')
    .temperature(0.7)
    .maxTokens(1000)
    .build();

final response = await provider.chat([
  ChatMessage.user('Explain quantum computing')
]);
```

## 💡 Best Practices

1. **Model Selection**: Use Flash for speed, Pro for balance, Ultra for quality
2. **Context Management**: Leverage large context for complex tasks
3. **Multi-Modal**: Combine text and images for richer interactions
4. **Safety Settings**: Configure appropriate content filtering
5. **Reasoning**: Enable thinking for complex problem solving

## 🔗 Related Examples

- [Core Features](../../02_core_features/) - Basic chat and streaming
- [Advanced Features](../../03_advanced_features/) - Multi-modal and reasoning
- [Use Cases](../../05_use_cases/) - Real-world applications

---

**🌟 Google Gemini excels at multi-modal tasks and complex reasoning with large context windows!**
