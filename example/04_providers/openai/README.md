# 🔵 OpenAI Provider Examples

OpenAI is the industry leader in AI with comprehensive features and robust APIs. These examples showcase OpenAI-specific capabilities and best practices.

## 📚 Available Examples

### 🚀 Basic Usage
**[basic_usage.dart](basic_usage.dart)** - Getting started with OpenAI
- GPT model selection
- Basic chat functionality
- Configuration options
- Error handling

### ⚡ Advanced Features
**[advanced_features.dart](advanced_features.dart)** - Advanced OpenAI capabilities
- Reasoning models (o1 series)
- Function calling
- Structured outputs
- Batch processing

### 🖼️ Vision and Images
**[vision_example.dart](vision_example.dart)** - Image processing with GPT-4o
- Image analysis and description
- Visual question answering
- Image generation with DALL-E
- Multi-modal conversations

### 🎵 Audio Capabilities
**[audio_capabilities.dart](audio_capabilities.dart)** - Speech and audio features
- Speech-to-text with Whisper
- Text-to-speech generation
- Audio file processing
- Audio translation

### 🎨 Image Generation
**[image_generation.dart](image_generation.dart)** - DALL-E image generation
- DALL-E 2 and DALL-E 3 generation
- Image editing and variations
- Advanced configuration options
- Quality and style settings

### 🤖 Assistants API
**[assistants.dart](assistants.dart)** - OpenAI Assistants
- Creating and managing assistants
- File uploads and retrieval
- Code interpreter
- Function calling with assistants

## 🎯 OpenAI Model Guide

### GPT Models

| Model | Best For | Speed | Cost | Context |
|-------|----------|-------|------|---------|
| **gpt-4o** | General purpose, vision | Fast | Medium | 128K |
| **gpt-4o-mini** | Cost-effective, fast | Very Fast | Low | 128K |
| **gpt-4-turbo** | Complex tasks | Medium | High | 128K |
| **o1-preview** | Complex reasoning | Slow | Very High | 128K |
| **o1-mini** | Fast reasoning | Medium | High | 128K |

### Specialized Models

| Model | Purpose | Use Cases |
|-------|---------|-----------|
| **DALL-E 3** | Image generation | Art, illustrations, designs |
| **Whisper** | Speech-to-text | Transcription, voice commands |
| **TTS** | Text-to-speech | Voice synthesis, accessibility |

## 🚀 Quick Start

```bash
# Set your OpenAI API key
export OPENAI_API_KEY="your-openai-api-key"

# Run basic example
dart run basic_usage.dart

# Try advanced features
dart run advanced_features.dart

# Test audio capabilities
dart run audio_capabilities.dart

# Test image generation
dart run image_generation.dart
```

## 💡 Best Practices

### Model Selection
- **gpt-4o-mini**: Default choice for most applications
- **gpt-4o**: When you need vision or higher quality
- **o1-mini**: For reasoning tasks that need step-by-step thinking
- **o1-preview**: For the most complex reasoning problems

### Cost Optimization
- Use **gpt-4o-mini** for simple tasks
- Implement **caching** for repeated queries
- Use **streaming** for better user experience
- Monitor **token usage** and optimize prompts

### Performance Tips
- Use **parallel requests** for independent tasks
- Implement **retry logic** with exponential backoff
- Cache responses when appropriate
- Use **function calling** instead of prompt engineering

### Error Handling
- Handle **rate limits** with proper backoff
- Implement **timeout** handling
- Provide **fallback responses**
- Log errors for monitoring

## 🔧 Configuration Examples

### Basic Configuration
```dart
final provider = await ai()
    .openai()
    .apiKey(apiKey)
    .model('gpt-4o-mini')
    .temperature(0.7)
    .maxTokens(1000)
    .build();
```

### Advanced Configuration
```dart
final provider = await ai()
    .openai()
    .apiKey(apiKey)
    .model('gpt-4o')
    .temperature(0.3)
    .maxTokens(2000)
    .topP(0.9)
    .frequencyPenalty(0.1)
    .presencePenalty(0.1)
    .systemPrompt('You are a helpful assistant.')
    .timeout(Duration(seconds: 30))
    .build();
```

### Reasoning Model Configuration
```dart
final reasoningProvider = await ai()
    .openai()
    .apiKey(apiKey)
    .model('o1-mini')
    .build(); // Temperature is fixed for reasoning models
```

## 📊 Feature Support Matrix

| Feature | gpt-4o | gpt-4o-mini | o1-mini | o1-preview |
|---------|--------|-------------|---------|------------|
| Text Generation | ✅ | ✅ | ✅ | ✅ |
| Function Calling | ✅ | ✅ | ❌ | ❌ |
| Vision | ✅ | ✅ | ❌ | ❌ |
| Reasoning | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Speed | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ |
| Cost | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ |

## 🔗 Related Examples

- **Core Features**: [Chat Basics](../../02_core_features/chat_basics.dart)
- **Advanced**: [Reasoning Models](../../03_advanced_features/reasoning_models.dart)
- **Comparison**: [Provider Comparison](../../01_getting_started/provider_comparison.dart)

## 📖 External Resources

- [OpenAI API Documentation](https://platform.openai.com/docs)
- [OpenAI Cookbook](https://cookbook.openai.com/)
- [Model Pricing](https://openai.com/pricing)
- [Rate Limits](https://platform.openai.com/docs/guides/rate-limits)

---

**💡 Tip**: OpenAI models are constantly evolving. Check the official documentation for the latest features and model capabilities!
