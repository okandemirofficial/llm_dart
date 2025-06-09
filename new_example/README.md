# LLM Dart Examples - Redesigned

A comprehensive collection of examples for the LLM Dart library, reorganized by user needs and learning paths to help you find the functionality and information you need more easily.

## 🚀 Quick Navigation

### Choose by Skill Level

| Skill Level | Recommended Path | Estimated Time |
|-------------|------------------|----------------|
| **🟢 Beginner** | [Getting Started](#-getting-started) → [Core Features](#-core-features) | 30 minutes |
| **🟡 Intermediate** | [Core Features](#-core-features) → [Advanced Features](#-advanced-features) | 1 hour |
| **🔴 Advanced** | [Advanced Features](#-advanced-features) → [Provider Specific](#-provider-specific) | 2+ hours |

### Choose by Use Case

| Use Case | Direct Link |
|----------|-------------|
| **Chatbot** | [05_use_cases/chatbot.dart](05_use_cases/chatbot.dart) |
| **Content Generation** | [05_use_cases/content_generation.dart](05_use_cases/content_generation.dart) |
| **Code Assistant** | [05_use_cases/code_assistant.dart](05_use_cases/code_assistant.dart) |
| **Voice Assistant** | [05_use_cases/voice_assistant.dart](05_use_cases/voice_assistant.dart) |
| **Flutter Integration** | [06_integration/flutter_app.dart](06_integration/flutter_app.dart) |

## 📁 Directory Structure

### 🟢 Getting Started
**For: First-time users of LLM Dart**

- **[quick_start.dart](01_getting_started/quick_start.dart)** - 5-minute quick start
- **[provider_comparison.dart](01_getting_started/provider_comparison.dart)** - Provider comparison and selection
- **[basic_configuration.dart](01_getting_started/basic_configuration.dart)** - Basic configuration guide

### 🟡 Core Features
**For: Users who need to understand main functionality**

- **[chat_basics.dart](02_core_features/chat_basics.dart)** - Basic chat functionality
- **[streaming_chat.dart](02_core_features/streaming_chat.dart)** - Real-time streaming chat
- **[tool_calling.dart](02_core_features/tool_calling.dart)** - Tool calling and function execution
- **[structured_output.dart](02_core_features/structured_output.dart)** - Structured data output
- **[error_handling.dart](02_core_features/error_handling.dart)** - Error handling best practices

### 🔴 Advanced Features
**For: Users who need deep customization**

- **[reasoning_models.dart](03_advanced_features/reasoning_models.dart)** - 🧠 Reasoning models and thinking processes
- **[multi_modal.dart](03_advanced_features/multi_modal.dart)** - Multi-modal processing (images/audio)
- **[custom_providers.dart](03_advanced_features/custom_providers.dart)** - Custom provider development
- **[performance_optimization.dart](03_advanced_features/performance_optimization.dart)** - Performance optimization techniques

### 🎯 Provider Specific
**For: Users who need specific provider functionality**

| Provider | Key Features | Example Files |
|----------|--------------|---------------|
| **OpenAI** | GPT models, image generation, assistants | [openai/](04_providers/openai/) |
| **Anthropic** | Claude, extended thinking | [anthropic/](04_providers/anthropic/) |
| **Google** | Gemini, multi-modal | [google/](04_providers/google/) |
| **DeepSeek** | Reasoning models | [deepseek/](04_providers/deepseek/) |
| **Ollama** | Local models | [ollama/](04_providers/ollama/) |
| **ElevenLabs** | Voice synthesis/recognition | [elevenlabs/](04_providers/elevenlabs/) |

### 🎪 Real-world Use Cases
**For: Users looking for specific application solutions**

- **[chatbot.dart](05_use_cases/chatbot.dart)** - Complete chatbot implementation
- **[content_generation.dart](05_use_cases/content_generation.dart)** - Content creation tools
- **[code_assistant.dart](05_use_cases/code_assistant.dart)** - Code assistance tools
- **[data_analysis.dart](05_use_cases/data_analysis.dart)** - Data analysis assistant
- **[voice_assistant.dart](05_use_cases/voice_assistant.dart)** - Voice interaction system

### 🔧 Integration Examples
**For: Users who need to integrate into existing projects**

- **[flutter_app.dart](06_integration/flutter_app.dart)** - Flutter app integration
- **[web_service.dart](06_integration/web_service.dart)** - Web service integration
- **[cli_tool.dart](06_integration/cli_tool.dart)** - Command-line tool development
- **[batch_processing.dart](06_integration/batch_processing.dart)** - Batch processing tasks

## 🎯 Feature Support Matrix

| Feature | OpenAI | Anthropic | Google | DeepSeek | Ollama | Groq | ElevenLabs |
|---------|--------|-----------|--------|----------|--------|------|------------|
| 💬 Basic Chat | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| 🌊 Streaming | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| 🔧 Tool Calling | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| 🧠 Thinking Process | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| 🖼️ Image Processing | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| 🎵 Audio Processing | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| 📊 Structured Output | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

## 🚀 Quick Start

### 1. Choose Your First Example

```bash
# Complete beginner - 5-minute quick experience
dart run examples/01_getting_started/quick_start.dart

# Experienced - jump to core features
dart run examples/02_core_features/chat_basics.dart

# Specific needs - jump to corresponding scenario
dart run examples/05_use_cases/chatbot.dart
```

### 2. Set Environment Variables

```bash
# Set API keys for the providers you want to use
export OPENAI_API_KEY="your-openai-key"
export ANTHROPIC_API_KEY="your-anthropic-key"
export GOOGLE_API_KEY="your-google-key"
export DEEPSEEK_API_KEY="your-deepseek-key"
export GROQ_API_KEY="your-groq-key"
export ELEVENLABS_API_KEY="your-elevenlabs-key"
```

### 3. Run Examples

```bash
cd examples
dart run 01_getting_started/quick_start.dart
```

## 💡 Learning Recommendations

### 🟢 Beginner Users
1. Start with `quick_start.dart`
2. Read `provider_comparison.dart` to choose the right provider
3. Learn `chat_basics.dart` to master basic conversations
4. Try `streaming_chat.dart` to experience real-time responses

### 🟡 Intermediate Users
1. Master `tool_calling.dart` for tool calling
2. Learn `structured_output.dart` for structured output
3. Explore `reasoning_models.dart` for reasoning functionality
4. Choose specific use case examples based on your needs

### 🔴 Advanced Users
1. Study `custom_providers.dart` for custom development
2. Optimize performance with `performance_optimization.dart`
3. Deep dive into specific provider advanced features
4. Integrate into production environments

## 🔗 Related Links

- [Main Project README](../README.md) - Complete library documentation
- [API Documentation](https://pub.dev/documentation/llm_dart/) - Detailed API reference
- [GitHub Issues](https://github.com/your-repo/llm_dart/issues) - Bug reports and feature requests
- [Discussions](https://github.com/your-repo/llm_dart/discussions) - Community discussions

---

**💡 Tip**: If you can't find the example you need, check [GitHub Issues](https://github.com/your-repo/llm_dart/issues) or create a new issue to tell us your requirements!
