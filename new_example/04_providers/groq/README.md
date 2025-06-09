# 🟢 Groq Provider Examples

Groq specializes in ultra-fast AI inference with their custom hardware. These examples showcase Groq's speed advantages and best practices.

## 📚 Available Examples

### 🚀 Basic Usage
**[basic_usage.dart](basic_usage.dart)** - Getting started with Groq
- Model selection and configuration
- Speed optimization techniques
- Cost-effective usage patterns
- Performance benchmarking

### ⚡ Speed Optimization
**[speed_optimization.dart](speed_optimization.dart)** - Maximizing Groq's speed
- Real-time applications
- Streaming optimization
- Latency minimization
- Throughput maximization

## 🎯 Groq Model Guide

### Available Models

| Model | Provider | Speed | Quality | Use Case |
|-------|----------|-------|---------|----------|
| **llama-3.1-8b-instant** | Meta | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | General purpose, fast |
| **llama-3.1-70b-versatile** | Meta | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | High quality, versatile |
| **mixtral-8x7b-32768** | Mistral | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Large context, multilingual |
| **gemma-7b-it** | Google | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Instruction following |

## 🚀 Quick Start

```bash
# Set your Groq API key
export GROQ_API_KEY="your-groq-api-key"

# Run basic example
dart run basic_usage.dart

# Test speed optimization
dart run speed_optimization.dart
```

## 💡 Best Practices

### Speed Optimization
- Use **llama-3.1-8b-instant** for maximum speed
- Implement **streaming** for real-time feel
- Keep **prompts concise** for faster processing
- Use **parallel requests** for batch operations

### Cost Efficiency
- Groq offers **competitive pricing**
- **Free tier** available for development
- **Pay-per-use** model with no minimums
- **High throughput** reduces per-request costs

### Model Selection
- **8B models**: Fastest, good for simple tasks
- **70B models**: Higher quality, complex reasoning
- **Mixtral**: Best for multilingual applications
- **Gemma**: Good instruction following

## 🔧 Configuration Examples

### Speed-Optimized Configuration
```dart
final provider = await ai()
    .groq()
    .apiKey(apiKey)
    .model('llama-3.1-8b-instant')
    .temperature(0.7)
    .maxTokens(500)  // Keep reasonable for speed
    .build();
```

### Quality-Optimized Configuration
```dart
final provider = await ai()
    .groq()
    .apiKey(apiKey)
    .model('llama-3.1-70b-versatile')
    .temperature(0.3)
    .maxTokens(2000)
    .build();
```

### Streaming Configuration
```dart
final provider = await ai()
    .groq()
    .apiKey(apiKey)
    .model('llama-3.1-8b-instant')
    .temperature(0.7)
    .build();

// Use chatStream for real-time responses
await for (final event in provider.chatStream(messages)) {
  // Handle streaming events
}
```

## 📊 Performance Characteristics

### Speed Benchmarks
- **Time to first token**: ~50-100ms
- **Tokens per second**: 500-1000+ tokens/sec
- **Latency**: Ultra-low for real-time apps
- **Throughput**: High concurrent request handling

### Use Case Recommendations

| Use Case | Recommended Model | Why |
|----------|------------------|-----|
| **Chatbots** | llama-3.1-8b-instant | Speed + good quality |
| **Real-time apps** | llama-3.1-8b-instant | Lowest latency |
| **Content generation** | llama-3.1-70b-versatile | Higher quality |
| **Code assistance** | llama-3.1-70b-versatile | Better reasoning |
| **Multilingual** | mixtral-8x7b-32768 | Language support |

## 🎯 Unique Strengths

### Ultra-Fast Inference
- Custom hardware acceleration
- Optimized model serving
- Minimal latency overhead
- High throughput capabilities

### Real-Time Applications
- Live chat and messaging
- Interactive assistants
- Gaming and entertainment
- Voice applications

### Cost-Effective Scaling
- Competitive pricing
- High performance per dollar
- Efficient resource utilization
- Predictable costs

### Developer Experience
- Simple API integration
- Consistent performance
- Reliable uptime
- Good documentation

## 🔗 Related Examples

- **Core Features**: [Streaming Chat](../../02_core_features/streaming_chat.dart)
- **Advanced**: [Performance Optimization](../../03_advanced_features/performance_optimization.dart)
- **Comparison**: [Provider Comparison](../../01_getting_started/provider_comparison.dart)

## 📖 External Resources

- [Groq Documentation](https://console.groq.com/docs)
- [Model Specifications](https://console.groq.com/docs/models)
- [API Reference](https://console.groq.com/docs/api-reference)
- [Pricing Information](https://groq.com/pricing/)

---

**💡 Tip**: Groq excels at speed. Use it when you need the fastest possible responses for real-time applications!
