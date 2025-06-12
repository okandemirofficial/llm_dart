# Ollama Unique Features

Local AI model deployment for privacy and offline capabilities.

## Examples

### [advanced_features.dart](advanced_features.dart)
Local model deployment, performance optimization, and custom configurations.

## Setup

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Download a model
ollama pull llama3.2

# Start Ollama server
ollama serve

# Run Ollama example
dart run advanced_features.dart
```

## Unique Capabilities

### Local Deployment
- **Complete Privacy**: No data sent to external servers
- **Offline Operation**: Works without internet connection
- **Cost-Free**: No API charges after initial setup

### Performance Control
- **Hardware Optimization**: GPU acceleration and CPU tuning
- **Custom Models**: Import and fine-tune your own models
- **Resource Management**: Control memory and processing allocation

## Usage Examples

### Local Model Configuration
```dart
final provider = await ai().ollama()
    .baseUrl('http://localhost:11434')
    .model('llama3.2')
    .numGpu(1)           // GPU acceleration
    .numThread(8)        // CPU threads
    .build();

final response = await provider.chat([
  ChatMessage.user('Explain quantum computing'),
]);

// All processing happens locally
print('Local response: ${response.text}');
```

### Privacy-Focused Setup
```dart
// Completely offline operation
final provider = await ai().ollama()
    .baseUrl('http://localhost:11434')
    .model('phi3')       // Lightweight model
    .build();

// No data leaves your machine
final response = await provider.chat([
  ChatMessage.user('Analyze this sensitive document'),
]);
```

## Next Steps

- [Core Features](../../02_core_features/) - Basic chat and streaming
- [Advanced Features](../../03_advanced_features/) - Custom provider setup
