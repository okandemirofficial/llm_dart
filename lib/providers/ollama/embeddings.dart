import 'package:dio/dio.dart';

import '../../core/chat_provider.dart';
import '../../core/llm_error.dart';
import 'client.dart';
import 'config.dart';

/// Ollama Embeddings capability implementation
///
/// This module handles embedding functionality for Ollama providers.
/// Ollama supports embeddings through the /api/embed endpoint.
class OllamaEmbeddings implements EmbeddingCapability {
  final OllamaClient client;
  final OllamaConfig config;

  OllamaEmbeddings(this.client, this.config);

  String get embeddingEndpoint => '/api/embed';

  @override
  Future<List<List<double>>> embed(List<String> input) async {
    if (config.baseUrl.isEmpty) {
      throw const InvalidRequestError('Missing Ollama base URL');
    }

    try {
      final requestBody = _buildRequestBody(input);
      final responseData =
          await client.postJson(embeddingEndpoint, requestBody);
      return _parseResponse(responseData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw GenericError('Unexpected error: $e');
    }
  }

  /// Build request body for Ollama embedding API
  Map<String, dynamic> _buildRequestBody(List<String> input) {
    return {
      'model': config.model,
      'input': input,
    };
  }

  /// Parse embedding response
  List<List<double>> _parseResponse(Map<String, dynamic> responseData) {
    final embeddings = responseData['embeddings'] as List?;

    if (embeddings == null) {
      throw const ProviderError('No embeddings returned by Ollama');
    }

    return embeddings.map((e) => List<double>.from(e as List)).toList();
  }

  /// Handle Dio errors and convert to appropriate LLM errors
  LLMError _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return HttpError('Request timeout: ${e.message}');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (statusCode != null) {
          return HttpErrorMapper.mapStatusCode(
            statusCode,
            'Ollama API error: $data',
            data is Map<String, dynamic> ? data : null,
          );
        }
        return ProviderError('HTTP error: $data');
      case DioExceptionType.cancel:
        return const GenericError('Request was cancelled');
      case DioExceptionType.connectionError:
        return HttpError('Connection error: ${e.message}');
      default:
        return HttpError('Network error: ${e.message}');
    }
  }
}
