# Anthropic Unique Features

Claude's advanced reasoning capabilities and safety-focused design.

## Examples

### [extended_thinking.dart](extended_thinking.dart)
Access Claude's step-by-step reasoning process.

### [file_handling.dart](file_handling.dart)
Advanced document processing and analysis.

## Setup

```bash
export ANTHROPIC_API_KEY="your-anthropic-api-key"

# Run Anthropic-specific examples
dart run extended_thinking.dart
dart run file_handling.dart
```

## Unique Capabilities

### Extended Thinking
- **Reasoning Process**: Access Claude's step-by-step thinking
- **Problem Solving**: Complex logical analysis and decomposition
- **Transparency**: See how Claude arrives at conclusions

### Advanced File Processing
- **Document Analysis**: Deep understanding of complex documents
- **Content Extraction**: Intelligent text and data extraction
- **Summarization**: Comprehensive document summarization

## Usage Examples

### Extended Thinking
```dart
final provider = await ai().anthropic().apiKey('your-key')
    .model('claude-sonnet-4-20250514').build();

final response = await provider.chat([
  ChatMessage.user('Solve this logic puzzle step by step'),
]);

// Access Claude's thinking process
if (response.thinking != null) {
  print('Claude\'s reasoning: ${response.thinking}');
}
```

### File Processing
```dart
final provider = await ai().anthropic().apiKey('your-key')
    .buildFileManagement();

// Upload and analyze document
final fileObject = await provider.uploadFile(FileUploadRequest(
  file: documentBytes,
  purpose: FilePurpose.assistants,
));

final analysis = await provider.chat([
  ChatMessage.user('Analyze this document: ${fileObject.id}'),
]);
```

## Next Steps

- [Core Features](../../02_core_features/) - Basic chat and streaming
- [Advanced Features](../../03_advanced_features/) - Cross-provider capabilities
