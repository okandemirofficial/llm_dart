# OpenAI Unique Features

OpenAI-specific capabilities not available in other providers.

## Examples

### [image_generation.dart](image_generation.dart)
DALL-E image generation with advanced configuration options.

### [audio_capabilities.dart](audio_capabilities.dart)
Whisper speech-to-text and TTS voice synthesis.

### [advanced_features.dart](advanced_features.dart)
Assistants API and specialized model features.

## Setup

```bash
export OPENAI_API_KEY="your-openai-api-key"

# Run OpenAI-specific examples
dart run image_generation.dart
dart run audio_capabilities.dart
dart run advanced_features.dart
```

## Unique Capabilities

### DALL-E Image Generation
- **DALL-E 3**: High-quality single images with prompt enhancement
- **DALL-E 2**: Multiple variations and image editing
- **Advanced controls**: Style, quality, size options

### Whisper Audio Processing
- **Speech-to-text**: Professional transcription accuracy
- **Audio translation**: Translate speech to English
- **Multiple formats**: Support for various audio formats

### Assistants API
- **Persistent assistants**: Stateful conversations
- **Tool integration**: Code interpreter and file search
- **File management**: Upload and process documents

## Usage Examples

### Image Generation
```dart
final imageProvider = await ai().openai().apiKey('your-key')
    .model('dall-e-3').buildImageGeneration();

final images = await imageProvider.generateImage(
  prompt: 'A futuristic cityscape',
  imageSize: '1024x1024',
);
```

### Audio Processing
```dart
final audioProvider = await ai().openai().apiKey('your-key')
    .buildAudio();

// Speech-to-text
final transcription = await audioProvider.transcribeFile('audio.mp3');

// Text-to-speech
final audioData = await audioProvider.speech('Hello world');
```

### Assistants
```dart
final assistantProvider = await ai().openai().apiKey('your-key')
    .buildAssistant();

final assistant = await assistantProvider.createAssistant(
  CreateAssistantRequest(
    model: 'gpt-4',
    name: 'Code Helper',
    tools: [CodeInterpreterTool()],
  ),
);
```

## Next Steps

- [Core Features](../../02_core_features/) - Basic chat and streaming
- [Advanced Features](../../03_advanced_features/) - Cross-provider capabilities
