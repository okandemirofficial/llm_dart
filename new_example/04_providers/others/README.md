# 🔧 Other Providers Examples

Additional AI providers and specialized integrations for extended functionality.

## 📁 Examples

### 🚀 [xai_grok.dart](xai_grok.dart)
**X.AI Grok Integration**
- Grok model access and configuration
- Real-time information capabilities
- Social media integration features
- Conversational AI with personality

### 🌐 [openrouter.dart](openrouter.dart)
**OpenRouter Multi-Provider Access**
- Access to multiple models through one API
- Model comparison and selection
- Cost optimization across providers
- Unified interface for diverse models

### 🔧 [custom_providers.dart](custom_providers.dart)
**Building Custom Provider Integrations**
- Creating custom provider implementations
- API wrapper development
- Integration patterns and best practices
- Extending the llm_dart ecosystem

### 🔄 [provider_switching.dart](provider_switching.dart)
**Dynamic Provider Switching**
- Runtime provider selection
- Fallback mechanisms
- Load balancing strategies
- Multi-provider applications

## 🎯 Key Features

### X.AI Grok
- **Real-Time**: Access to current information
- **Personality**: Conversational and engaging
- **Social Integration**: Twitter/X platform integration
- **Humor**: Witty and entertaining responses

### OpenRouter
- **Multi-Model**: Access to 100+ models
- **Cost Optimization**: Compare prices across providers
- **Unified API**: Single interface for all models
- **Model Discovery**: Explore new and emerging models

### Custom Providers
- **Extensibility**: Add any API-based AI service
- **Standardization**: Consistent interface patterns
- **Integration**: Seamless ecosystem integration
- **Flexibility**: Adapt to unique requirements

## 🚀 Quick Start

```dart
// X.AI Grok usage
final grokProvider = await ai()
    .xai()
    .apiKey('your-xai-api-key')
    .model('grok-beta')
    .build();

// OpenRouter usage
final openRouterProvider = await ai()
    .openRouter()
    .apiKey('your-openrouter-api-key')
    .model('anthropic/claude-3-sonnet')
    .build();

// Custom provider
final customProvider = CustomProvider(
  config: CustomConfig(
    apiKey: 'your-api-key',
    baseUrl: 'https://api.example.com',
  ),
);
```

## 💡 Best Practices

1. **Provider Selection**: Choose based on specific capabilities needed
2. **Cost Management**: Compare pricing across different providers
3. **Fallback Strategy**: Implement provider switching for reliability
4. **Custom Integration**: Follow established patterns for consistency
5. **Testing**: Thoroughly test custom implementations

## 🔗 Related Examples

- [Core Features](../../02_core_features/) - Basic functionality
- [Advanced Features](../../03_advanced_features/) - Custom providers
- [Integration](../../06_integration/) - Service integration patterns

---

**🔧 Extend llm_dart with additional providers and custom integrations!**
