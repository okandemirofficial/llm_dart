# 🟡 Ollama Provider Examples

Ollama enables running large language models locally on your machine. These examples show how to use local AI models for privacy, cost savings, and offline capabilities.

## 📚 Available Examples

### 🚀 [basic_usage.dart](basic_usage.dart)
**Getting Started with Ollama**
- Local model setup and configuration
- Basic chat functionality
- Model management
- Performance considerations
- Best practices for local AI

### 🔧 [advanced_features.dart](advanced_features.dart)
**Advanced Ollama Features**
- Performance optimization
- Custom parameters
- Model comparison
- Resource management
- Advanced configuration

## 🎯 Ollama Model Guide

### Popular Models

| Model | Size | RAM Required | Use Case |
|-------|------|--------------|----------|
| **llama3.2** | 4.7GB | 8GB | General purpose |
| **llama3.2:70b** | 40GB | 64GB | High quality |
| **codellama** | 3.8GB | 8GB | Code generation |
| **mistral** | 4.1GB | 8GB | Fast inference |
| **phi3** | 2.3GB | 4GB | Lightweight |
| **gemma** | 5.0GB | 8GB | Google's model |

### Model Categories

| Category | Models | Best For |
|----------|--------|----------|
| **General** | llama3.2, mistral | Chat, Q&A, general tasks |
| **Code** | codellama, deepseek-coder | Programming, code review |
| **Lightweight** | phi3, tinyllama | Resource-constrained environments |
| **Specialized** | medllama, mathstral | Domain-specific tasks |

## 🚀 Quick Start

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Download a model
ollama pull llama3.2

# Start Ollama server
ollama serve

# Set up for examples (optional, uses default localhost)
export OLLAMA_BASE_URL="http://localhost:11434"

# Run examples
dart run basic_usage.dart
dart run advanced_features.dart
```

## 💡 Best Practices

### Model Selection
- **llama3.2**: Best overall choice for most tasks
- **phi3**: Use when RAM/storage is limited
- **codellama**: Specialized for programming tasks
- **mistral**: Good balance of speed and quality

### Performance Optimization
- **GPU acceleration**: Use NVIDIA/AMD GPUs when available
- **Memory management**: Ensure sufficient RAM for model
- **CPU optimization**: Use all available cores
- **Storage**: SSD recommended for faster loading

### Privacy and Security
- **Offline operation**: No data sent to external servers
- **Local storage**: All data stays on your machine
- **Network isolation**: Can run completely offline
- **Compliance**: Meets strict privacy requirements

## 🔧 Configuration Examples

### Basic Configuration
```dart
final provider = await ai()
    .ollama()
    .baseUrl('http://localhost:11434')
    .model('llama3.2')
    .temperature(0.7)
    .build();
```

### Performance-Optimized Configuration
```dart
final provider = await ai()
    .ollama()
    .baseUrl('http://localhost:11434')
    .model('llama3.2')
    .temperature(0.7)
    .numCtx(4096)        // Context length
    .numGpu(1)           // GPU layers
    .numThread(8)        // CPU threads
    .build();
```

### Lightweight Configuration
```dart
final provider = await ai()
    .ollama()
    .baseUrl('http://localhost:11434')
    .model('phi3')       // Smaller model
    .temperature(0.7)
    .numCtx(2048)        // Smaller context
    .build();
```

## 📊 Performance Characteristics

### Hardware Requirements

| Model Size | Minimum RAM | Recommended RAM | GPU VRAM |
|------------|-------------|-----------------|----------|
| **7B** | 8GB | 16GB | 6GB |
| **13B** | 16GB | 32GB | 12GB |
| **70B** | 64GB | 128GB | 48GB |

### Performance Factors
- **CPU**: More cores = faster inference
- **RAM**: More RAM = larger models
- **GPU**: Dramatically faster with GPU acceleration
- **Storage**: SSD improves model loading time

## 🎯 Unique Advantages

### Privacy and Security
- **Complete data privacy**: No external API calls
- **Offline capability**: Works without internet
- **Local control**: Full control over AI processing
- **Compliance**: Meets strict regulatory requirements

### Cost Benefits
- **No API costs**: Free after initial setup
- **Unlimited usage**: No per-token charges
- **Predictable costs**: Only hardware and electricity
- **Scalable**: Add more hardware as needed

### Customization
- **Model fine-tuning**: Train on your specific data
- **Custom models**: Import and use custom models
- **Parameter control**: Fine-tune inference parameters
- **Integration**: Easy integration with existing systems

### Development Benefits
- **Fast iteration**: No API rate limits
- **Consistent performance**: Predictable response times
- **Debugging**: Full control over model behavior
- **Testing**: Perfect for development and testing

## 🔗 Related Examples

- **Core Features**: [Chat Basics](../../02_core_features/chat_basics.dart)
- **Advanced**: [Custom Providers](../../03_advanced_features/custom_providers.dart)
- **Comparison**: [Provider Comparison](../../01_getting_started/provider_comparison.dart)

## 📖 External Resources

- [Ollama Documentation](https://ollama.ai/docs)
- [Model Library](https://ollama.ai/library)
- [Installation Guide](https://ollama.ai/download)
- [GitHub Repository](https://github.com/ollama/ollama)

---

**💡 Tip**: Ollama is perfect when you need complete privacy, want to avoid API costs, or need to work offline. Start with llama3.2 for the best balance of quality and performance!
