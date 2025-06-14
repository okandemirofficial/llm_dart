# Google Provider Examples

This directory contains specific usage examples for the Google (Gemini) provider, showcasing Google-specific features and best practices.

## 📁 File Structure

- `embeddings.dart` - Google text embedding model usage examples
- `image_generation.dart` - Google image generation functionality examples

## 🔢 Embeddings

Google provides high-quality text embedding models accessible through the Gemini API.

### Supported Models

- `text-embedding-004` - Latest embedding model supporting multiple task types
- `text-embedding-003` - Previous version embedding model

### Basic Usage

```dart
import 'package:llm_dart/llm_dart.dart';

// Create embedding provider
final provider = await ai()
    .google()
    .apiKey('your-google-api-key')
    .model('text-embedding-004')
    .buildEmbedding();

// Generate embeddings
final embeddings = await provider.embed([
  'Hello, world!',
  'This is a test sentence.',
]);

print('Generated ${embeddings.length} embeddings');
print('Dimensions: ${embeddings.first.length}');
```

### Google-Specific Parameters

Google embedding API supports various task-specific parameters:

#### Task Type

```dart
final provider = await ai()
    .google((google) => google
        .embeddingTaskType('SEMANTIC_SIMILARITY'))
    .apiKey(apiKey)
    .model('text-embedding-004')
    .buildEmbedding();
```

Supported task types:

- `SEMANTIC_SIMILARITY` - Semantic similarity computation
- `RETRIEVAL_QUERY` - Retrieval queries
- `RETRIEVAL_DOCUMENT` - Retrieval documents
- `CLASSIFICATION` - Classification tasks
- `CLUSTERING` - Clustering tasks
- `QUESTION_ANSWERING` - Question answering tasks
- `FACT_VERIFICATION` - Fact verification
- `CODE_RETRIEVAL_QUERY` - Code retrieval queries

#### Document Title (for RETRIEVAL_DOCUMENT only)

```dart
final provider = await ai()
    .google((google) => google
        .embeddingTaskType('RETRIEVAL_DOCUMENT')
        .embeddingTitle('Technical Documentation'))
    .apiKey(apiKey)
    .model('text-embedding-004')
    .buildEmbedding();
```

#### Output Dimensions

```dart
final provider = await ai()
    .google((google) => google
        .embeddingDimensions(512))  // Reduce dimensions
    .apiKey(apiKey)
    .model('text-embedding-004')
    .buildEmbedding();
```

### Convenience Factory Functions

```dart
// Create embedding provider with default settings
final provider = createGoogleEmbeddingProvider(
  apiKey: 'your-api-key',
);

// Use custom parameters and Google configuration
final customProvider = await ai()
    .google((google) => google
        .embeddingTaskType('SEMANTIC_SIMILARITY')
        .embeddingDimensions(768))
    .apiKey('your-api-key')
    .model('text-embedding-004')
    .buildEmbedding();
```

### Batch Processing

Google API automatically handles single and batch requests:

```dart
// Single text - uses embedContent endpoint
final singleEmbedding = await provider.embed(['Single text']);

// Multiple texts - uses batchEmbedContents endpoint
final batchEmbeddings = await provider.embed([
  'First text',
  'Second text',
  'Third text',
]);
```

### Semantic Search Example

```dart
// Document collection
final documents = [
  'Machine learning algorithms learn from data',
  'Deep learning uses neural networks',
  'Natural language processing handles text',
];

// Create document embeddings
final docEmbeddings = await provider.embed(documents);

// Search query
final queryEmbedding = await provider.embed(['neural networks']);

// Calculate similarities and sort
final similarities = <double>[];
for (final docEmb in docEmbeddings) {
  final similarity = cosineSimilarity(queryEmbedding.first, docEmb);
  similarities.add(similarity);
}

// Find the most similar document
final bestMatch = similarities.indexOf(similarities.reduce(math.max));
print('Best match: ${documents[bestMatch]}');
```

### Error Handling

```dart
try {
  final embeddings = await provider.embed(['test text']);
  print('Success: ${embeddings.length} embeddings generated');
} on AuthError catch (e) {
  print('Authentication failed: ${e.message}');
} on ResponseFormatError catch (e) {
  print('Invalid response format: ${e.message}');
} on LLMError catch (e) {
  print('LLM error: ${e.message}');
}
```

### Best Practices

1. **Choose appropriate task type**: Select the most suitable `embeddingTaskType` for your use case
2. **Batch processing**: For multiple texts, processing all at once is more efficient than individual processing
3. **Dimension optimization**: If full dimensions aren't needed, use `embeddingDimensions` to reduce dimensions
4. **Document titles**: For retrieval tasks, providing document titles can improve embedding quality
5. **Error handling**: Always include appropriate error handling logic

### Performance Considerations

- Google's embedding API supports batch processing, which can significantly improve throughput
- `text-embedding-004` is the latest model providing the best quality
- Consider using caching to avoid recomputing embeddings for the same text

## 🔗 Related Links

- [Google AI Embeddings API Documentation](https://ai.google.dev/api/embeddings)
- [Gemini API Reference](https://ai.google.dev/api)
- [Core Features Examples](../../02_core_features/embeddings.dart)

## 📖 Next Steps

Try running the example:

```bash
dart run example/04_providers/google/embeddings.dart
```

## 🎨 Image Generation

Google provides two image generation approaches accessible through the Gemini API.

### Supported Models

- `gemini-2.0-flash-preview-image-generation` - Gemini conversational image generation
- `imagen-3.0-generate-002` - Imagen 3 dedicated image generation model

### Gemini Image Generation

Gemini 2.0 Flash Preview supports conversational image generation, capable of generating and editing images.

```dart
import 'package:llm_dart/llm_dart.dart';

// Create Gemini image generation provider
final imageProvider = await ai()
    .google((google) => google
        .enableImageGeneration(true)
        .responseModalities(['TEXT', 'IMAGE']))
    .apiKey('your-google-api-key')
    .model('gemini-2.0-flash-preview-image-generation')
    .buildImageGeneration();

// Generate images
final images = await imageProvider.generateImage(
  prompt: 'A futuristic robot in a modern kitchen',
  batchSize: 1,
);

// Images are returned as base64 data URLs
for (final imageData in images) {
  if (imageData.startsWith('data:image/')) {
    final base64Data = imageData.split(',')[1];
    final bytes = base64Decode(base64Data);
    await File('generated_image.png').writeAsBytes(bytes);
  }
}
```

### Imagen 3 Image Generation

Imagen 3 is a dedicated image generation model providing higher quality image generation.

```dart
// Create Imagen 3 provider
final imageProvider = await ai()
    .google()
    .apiKey('your-google-api-key')
    .model('imagen-3.0-generate-002')
    .buildImageGeneration();

// Generate images
final response = await imageProvider.generateImages(
  ImageGenerationRequest(
    prompt: 'A serene mountain landscape at sunset',
    count: 2,
    size: '1:1', // Supported aspect ratio
  ),
);

// Save images
for (int i = 0; i < response.images.length; i++) {
  final image = response.images[i];
  if (image.data != null) {
    await File('imagen_${i + 1}.png').writeAsBytes(image.data!);
  }
}
```

### Image Editing

Gemini supports conversational image editing.

```dart
// Edit existing image
final editResponse = await imageProvider.editImage(
  ImageEditRequest(
    image: ImageInput.fromBytes(originalImageBytes, format: 'png'),
    prompt: 'Add a red hat to the cat and change the chair to blue',
    count: 1,
  ),
);
```

### Supported Features

- **Text-to-image generation** - Generate images from text descriptions
- **Image editing** - Edit existing images through text instructions
- **Image variations** - Create variations with similar style
- **Multiple aspect ratios** - Supports 1:1, 3:4, 4:3, 9:16, 16:9
- **Base64 output** - Images returned as base64 data

### Important Notes

- Gemini image generation requires setting `responseModalities: ['TEXT', 'IMAGE']`
- Imagen 3 only supports English prompts and requires a paid account
- All generated images include SynthID watermarks
- Image generation may not be available in all regions
- Recommend using Gemini 2.0 Flash Preview for image generation

Explore other features:

- [Semantic Search](../../03_advanced_features/semantic_search.dart)
- [Core Features](../../02_core_features/)
