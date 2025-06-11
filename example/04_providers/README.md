# 🎯 Provider Specific Examples

Examples for specific AI providers, organized by provider type.

## 📚 Available Examples

### 🔵 OpenAI
**[openai/](openai/)**
- **basic_usage.dart** - Model selection, configuration, best practices
- **advanced_features.dart** - Reasoning models (o1), function calling, assistants
- **image_generation.dart** - DALL-E image creation and editing
- **audio_capabilities.dart** - Whisper STT and TTS capabilities

### 🟣 Anthropic
**[anthropic/](anthropic/)**
- **basic_usage.dart** - Claude models, safety features, reasoning
- **extended_thinking.dart** - Access to Claude's thinking process
- **file_handling.dart** - Document processing and analysis

### 🔴 Google
**[google/](google/)**
- **basic_usage.dart** - Gemini models, reasoning, and configuration

### 🟠 DeepSeek
**[deepseek/](deepseek/)**
- **basic_usage.dart** - DeepSeek models, reasoning, and cost-effective usage

### 🟡 Ollama
**[ollama/](ollama/)**
- **basic_usage.dart** - Local model setup and usage
- **advanced_features.dart** - Performance optimization and advanced configuration

### 🟢 Groq
**[groq/](groq/)**
- **basic_usage.dart** - High-speed model configuration and streaming

### 🎵 ElevenLabs
**[elevenlabs/](elevenlabs/)**
- **basic_usage.dart** - Voice generation and configuration
- **audio_capabilities.dart** - Advanced audio features and optimization

### 🔧 Others
**[others/](others/)**
- **xai_grok.dart** - X.AI Grok integration with personality features
- **openai_compatible.dart** - All OpenAI-compatible providers demo (DeepSeek, Groq, xAI, OpenRouter, GitHub Copilot, Together AI)

## 🚀 Quick Start

Run any example directly:
```bash
# Core providers
dart run openai/basic_usage.dart
dart run anthropic/basic_usage.dart
dart run deepseek/basic_usage.dart

# OpenAI-compatible providers (all in one demo)
dart run others/openai_compatible.dart

# Specialized features
dart run openai/image_generation.dart
dart run elevenlabs/audio_capabilities.dart
dart run ollama/advanced_features.dart
```
