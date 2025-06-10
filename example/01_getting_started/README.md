# 🟢 Getting Started

Welcome to the LLM Dart getting started guide! This contains the most basic and important examples to help you get up and running quickly.

## 📚 Learning Path

### Step 1: Quick Experience (5 minutes)
**[quick_start.dart](quick_start.dart)** - Simplest usage example
- Create your first AI conversation
- Understand basic API calling methods
- Experience responses from different providers

### Step 2: Choose Provider (10 minutes)
**[provider_comparison.dart](provider_comparison.dart)** - Provider comparison
- Learn about each provider's characteristics
- Compare response quality and speed
- Choose the provider that best fits your needs

### Step 3: Configuration Optimization (15 minutes)
**[basic_configuration.dart](basic_configuration.dart)** - Basic configuration
- Learn important configuration parameters
- Understand how to tune model behavior
- Master basic error handling

## 🎯 What You'll Master After Completion

- ✅ How to create and use LLM providers
- ✅ Characteristics and selection criteria of different providers
- ✅ The role of basic configuration parameters
- ✅ Simple error handling

## 🚀 Running Examples

```bash
# Set API keys (choose the providers you want to use)
export OPENAI_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"
export GROQ_API_KEY="your-key"

# Run examples
dart run quick_start.dart
dart run provider_comparison.dart
dart run basic_configuration.dart
```

## 📖 Next Steps

After completing the getting started guide, we recommend continuing with:

1. **[Core Features](../02_core_features/)** - Master main functionality
2. **[Real-world Use Cases](../05_use_cases/)** - See specific application scenarios
3. **[Provider Specific](../04_providers/)** - Deep dive into specific provider features

## 💡 Frequently Asked Questions

**Q: Which provider should I choose?**
A: Run `provider_comparison.dart` to see comparisons. Generally recommended:
- Beginners: OpenAI (stable and reliable)
- Local deployment: Ollama (free local)
- High performance: Groq (fastest speed)
- Reasoning tasks: Anthropic Claude (thinking process)

**Q: Why is my API call failing?**
A: Check:
1. Is the API key set correctly
2. Is the network connection normal
3. Do you have sufficient API quota
4. Run `basic_configuration.dart` to see error handling examples

**Q: How do I get API keys?**
A: Visit the corresponding provider websites:
- OpenAI: https://platform.openai.com/api-keys
- Anthropic: https://console.anthropic.com/
- Groq: https://console.groq.com/keys
