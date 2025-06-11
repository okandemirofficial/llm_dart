# DeepSeek Unique Features

Cost-effective reasoning models with transparent thinking process.

## Examples

DeepSeek reasoning capabilities are demonstrated in the [Advanced Features](../../03_advanced_features/reasoning_models.dart) section.

## Setup

```bash
export DEEPSEEK_API_KEY="your-deepseek-api-key"

# DeepSeek reasoning examples are in advanced features
cd ../../03_advanced_features
dart run reasoning_models.dart
```

## Unique Capabilities

### Reasoning Models
- **deepseek-reasoner**: Advanced reasoning with visible thinking process
- **Transparent Thinking**: Access to step-by-step reasoning
- **Cost-Effective**: High performance at low cost

## Usage Examples

### Reasoning with Thinking Process
```dart
final provider = await ai().deepseek().apiKey('your-key')
    .model('deepseek-reasoner').build();

final response = await provider.chat([
  ChatMessage.user('Solve this step by step: 15 + 27 * 3'),
]);

// Access transparent thinking process
if (response.thinking != null) {
  print('AI thinking: ${response.thinking}');
}
print('Final answer: ${response.text}');
```

## Next Steps

- [Core Features](../../02_core_features/) - Basic chat and streaming
- [Advanced Features](../../03_advanced_features/) - Cross-provider reasoning
