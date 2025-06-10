# 🔧 Other Providers Examples

Additional AI providers and specialized integrations for extended functionality.

## 📁 Examples

### 🚀 [xai_grok.dart](xai_grok.dart)
**X.AI Grok Integration**
- Grok model access and configuration
- Real-time information capabilities
- Conversational AI with personality
- Witty and engaging responses
- Best practices for Grok usage

## 🎯 Key Features

### X.AI Grok
- **Real-Time**: Access to current information
- **Personality**: Conversational and engaging
- **Social Integration**: Twitter/X platform integration
- **Humor**: Witty and entertaining responses
- **Streaming**: Real-time response generation

## 🚀 Quick Start

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

## 💡 Best Practices

1. **Personality Leverage**: Use Grok's wit and humor for engaging interactions
2. **Real-Time Info**: Take advantage of current information access
3. **Temperature Settings**: Adjust for personality vs factual responses
4. **Error Handling**: Implement proper error handling for API calls
5. **Streaming**: Use streaming for better user experience

## 🔗 Related Examples

- [Core Features](../../02_core_features/) - Basic functionality
- [Advanced Features](../../03_advanced_features/) - Custom providers
- [Integration](../../06_integration/) - Service integration patterns

---

**🔧 Extend llm_dart with additional providers and custom integrations!**
