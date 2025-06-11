# 🟣 Anthropic Provider Examples

Anthropic's Claude models are known for advanced reasoning, safety, and extended thinking processes. These examples showcase Anthropic-specific capabilities.

## 📚 Available Examples

### 🚀 Basic Usage
**[basic_usage.dart](basic_usage.dart)** - Getting started with Claude
- Claude model selection
- Basic chat functionality
- Configuration options
- Safety features

### 🧠 Extended Thinking
**[extended_thinking.dart](extended_thinking.dart)** - Claude's reasoning process
- Accessing thinking processes
- Complex problem solving
- Step-by-step reasoning
- Thought analysis

### 📄 File Handling
**[file_handling.dart](file_handling.dart)** - Document processing
- File upload and analysis
- Document understanding
- Text extraction
- Content summarization

## 🎯 Claude Model Guide

### Available Models

| Model | Best For | Speed | Cost | Context |
|-------|----------|-------|------|---------|
| **claude-3-5-sonnet** | General purpose, reasoning | Medium | Medium | 200K |
| **claude-3-5-haiku** | Fast responses | Fast | Low | 200K |
| **claude-3-opus** | Complex tasks | Slow | High | 200K |

### Model Characteristics

| Feature | Sonnet | Haiku | Opus |
|---------|--------|-------|------|
| **Reasoning** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Speed** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| **Cost** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ |
| **Creativity** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Analysis** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## 🚀 Quick Start

```bash
# Set your Anthropic API key
export ANTHROPIC_API_KEY="your-anthropic-api-key"

# Run basic example
dart run basic_usage.dart

# Try extended thinking
dart run extended_thinking.dart

# Test file handling
dart run file_handling.dart
```

## 💡 Best Practices

### Model Selection
- **claude-3-5-haiku-20241022**: Fast responses, cost-effective
- **claude-sonnet-4-20250514**: Balanced performance and quality
- **claude-opus-4-20250514**: Highest quality for complex tasks

### Prompt Engineering
- Be specific and detailed in requests
- Use structured prompts for complex tasks
- Leverage Claude's reasoning capabilities
- Ask for step-by-step explanations

### Safety and Ethics
- Claude has built-in safety measures
- Refuses harmful or inappropriate requests
- Provides balanced, thoughtful responses
- Good for sensitive or ethical topics

### Performance Optimization
- Use appropriate model for task complexity
- Implement caching for repeated queries
- Monitor token usage
- Use streaming for better UX

## 🔧 Configuration Examples

### Basic Configuration
```dart
final provider = await ai()
    .anthropic()
    .apiKey(apiKey)
    .model('claude-3-5-haiku-20241022')
    .temperature(0.7)
    .maxTokens(1000)
    .build();
```

### Advanced Configuration
```dart
final provider = await ai()
    .anthropic()
    .apiKey(apiKey)
    .model('claude-sonnet-4-20250514')
    .temperature(0.3)
    .maxTokens(4000)
    .systemPrompt('You are an expert analyst.')
    .timeout(Duration(seconds: 60))
    .build();
```

## 📊 Feature Support Matrix

| Feature | Haiku | Sonnet | Opus |
|---------|-------|--------|------|
| Text Generation | ✅ | ✅ | ✅ |
| Function Calling | ✅ | ✅ | ✅ |
| Vision | ✅ | ✅ | ✅ |
| File Processing | ✅ | ✅ | ✅ |
| Extended Thinking | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Complex Reasoning | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## 🎯 Unique Strengths

### Advanced Reasoning
- Step-by-step problem solving
- Complex logical analysis
- Mathematical reasoning
- Ethical considerations

### Safety Focus
- Refuses harmful requests
- Balanced perspectives
- Ethical guidelines
- Responsible AI behavior

### Extended Context
- Large context windows (200K tokens)
- Long document processing
- Conversation memory
- Complex multi-turn dialogues

### Thinking Process
- Access to reasoning steps
- Transparent decision making
- Problem decomposition
- Verification and checking

## 🔗 Related Examples

- **Core Features**: [Chat Basics](../../02_core_features/chat_basics.dart)
- **Advanced**: [Reasoning Models](../../03_advanced_features/reasoning_models.dart)
- **Comparison**: [Provider Comparison](../../01_getting_started/provider_comparison.dart)

## 📖 External Resources

- [Anthropic API Documentation](https://docs.anthropic.com/)
- [Claude Model Guide](https://docs.anthropic.com/claude/docs/models-overview)
- [Prompt Engineering Guide](https://docs.anthropic.com/claude/docs/prompt-engineering)
- [Safety Guidelines](https://www.anthropic.com/safety)

---

**💡 Tip**: Claude excels at reasoning and analysis. Use it for complex problems that require step-by-step thinking!
