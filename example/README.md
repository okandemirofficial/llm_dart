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
| **CLI Tool** | [05_use_cases/cli_tool.dart](05_use_cases/cli_tool.dart) |
| **Web Service** | [05_use_cases/web_service.dart](05_use_cases/web_service.dart) |
| **MCP Integration** | [06_mcp_integration/mcp_concept_demo.dart](06_mcp_integration/mcp_concept_demo.dart) |
| **Real-World App** | [Yumcha](https://github.com/Latias94/yumcha) - Production Flutter app |

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
- **[enhanced_tool_calling.dart](02_core_features/enhanced_tool_calling.dart)** - Advanced tool calling patterns
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
| **DeepSeek** | Reasoning models, cost-effective | [deepseek/](04_providers/deepseek/) |
| **Groq** | Ultra-fast inference | [groq/](04_providers/groq/) |
| **Ollama** | Local models, privacy-focused | [ollama/](04_providers/ollama/) |
| **ElevenLabs** | Voice synthesis/recognition | [elevenlabs/](04_providers/elevenlabs/) |
| **Others** | XAI Grok and more | [others/](04_providers/others/) |

### 🎪 Real-world Use Cases
**For: Users looking for specific application solutions**

- **[chatbot.dart](05_use_cases/chatbot.dart)** - Complete chatbot implementation
- **[cli_tool.dart](05_use_cases/cli_tool.dart)** - Command-line AI assistant
- **[web_service.dart](05_use_cases/web_service.dart)** - HTTP API with AI capabilities

### 🌟 Production Application
**Real-world example built with LLM Dart**

- **[Yumcha](https://github.com/Latias94/yumcha)** - Cross-platform AI chat application actively developed by the creator of LLM Dart, showcasing real-world integration with multiple providers, real-time streaming, and advanced features

### 🔗 MCP Integration ✅ **FULLY TESTED**
**For: Users who want to connect LLMs with external tools via Model Context Protocol**

- **[mcp_concept_demo.dart](06_mcp_integration/mcp_concept_demo.dart)** - 🎯 **START HERE** - Core MCP concepts
- **[simple_mcp_demo.dart](06_mcp_integration/simple_mcp_demo.dart)** - Working MCP + LLM integration example
- **[test_all_examples.dart](06_mcp_integration/test_all_examples.dart)** - 🧪 **ONE-CLICK TEST** - Test all examples
- **[basic_mcp_client.dart](06_mcp_integration/basic_mcp_client.dart)** - Basic MCP client connection
- **[custom_mcp_server.dart](06_mcp_integration/custom_mcp_server.dart)** - Custom MCP server implementation
- **[mcp_tool_bridge.dart](06_mcp_integration/mcp_tool_bridge.dart)** - Bridge between MCP and llm_dart tools
- **[mcp_with_llm.dart](06_mcp_integration/mcp_with_llm.dart)** - Advanced MCP + LLM integration

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
dart run 01_getting_started/quick_start.dart

# Experienced - jump to core features
dart run 02_core_features/chat_basics.dart

# Specific needs - jump to corresponding scenario
dart run 05_use_cases/chatbot.dart

# MCP integration - connect LLMs with external tools
dart run 06_mcp_integration/mcp_concept_demo.dart
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
cd new_example
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
4. Explore [Yumcha](https://github.com/Latias94/yumcha) for real-world architecture patterns and active development practices
5. Integrate into production environments with MCP protocol support

## 🔗 Related Links

- [Main Project README](../README.md) - Complete library documentation
- [API Documentation](https://pub.dev/documentation/llm_dart/) - Detailed API reference
- [GitHub Issues](https://github.com/your-repo/llm_dart/issues) - Bug reports and feature requests
- [Discussions](https://github.com/your-repo/llm_dart/discussions) - Community discussions

---

**💡 Tip**: If you can't find the example you need, check [GitHub Issues](https://github.com/your-repo/llm_dart/issues) or create a new issue to tell us your requirements!
