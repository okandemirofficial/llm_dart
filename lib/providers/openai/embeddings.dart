import '../../core/chat_provider.dart';
import '../../core/llm_error.dart';
import 'client.dart';
import 'config.dart';

/// OpenAI Embeddings capability implementation
///
/// This module handles vector embedding generation for OpenAI providers.
class OpenAIEmbeddings implements EmbeddingCapability {
  final OpenAIClient client;
  final OpenAIConfig config;

  OpenAIEmbeddings(this.client, this.config);

  @override
  Future<List<List<double>>> embed(List<String> input) async {
    final requestBody = {
      'model': config.model,
      'input': input,
      'encoding_format': config.embeddingEncodingFormat ?? 'float',
      if (config.embeddingDimensions != null)
        'dimensions': config.embeddingDimensions,
    };

    final responseData = await client.postJson('embeddings', requestBody);

    final data = responseData['data'] as List?;
    if (data == null) {
      throw const ResponseFormatError(
        'Invalid embedding response format',
        'Missing data field',
      );
    }

    final embeddings =
        data.map((item) => (item['embedding'] as List).cast<double>()).toList();

    return embeddings;
  }

  /// Get embedding dimensions for a model
  Future<int> getEmbeddingDimensions() async {
    final requestBody = {
      'model': config.model,
      'input': 'hi', // Simple test input
    };

    final responseData = await client.postJson('embeddings', requestBody);

    final data = responseData['data'] as List?;
    if (data == null || data.isEmpty) {
      throw const ResponseFormatError(
        'Invalid embedding response format',
        'Missing data field',
      );
    }

    final embedding =
        (data.first as Map<String, dynamic>)['embedding'] as List?;
    if (embedding == null) {
      throw const ResponseFormatError(
        'Invalid embedding response format',
        'Missing embedding field',
      );
    }

    return embedding.length;
  }
}
