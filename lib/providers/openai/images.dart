import 'dart:convert';

import '../../core/chat_provider.dart';
import '../../core/llm_error.dart';
import '../../models/image_models.dart';
import 'client.dart';
import 'config.dart';

/// OpenAI Image Generation capability implementation
/// 
/// This module handles image generation functionality for OpenAI providers.
class OpenAIImages implements ImageGenerationCapability {
  final OpenAIClient client;
  final ModularOpenAIConfig config;

  OpenAIImages(this.client, this.config);

  @override
  Future<ImageGenerationResponse> generateImages(
    ImageGenerationRequest request,
  ) async {
    final requestBody = <String, dynamic>{
      'model': request.model ?? config.model,
      'prompt': request.prompt,
      if (request.negativePrompt != null)
        'negative_prompt': request.negativePrompt,
      if (request.size != null) 'size': request.size,
      if (request.count != null) 'n': request.count,
      if (request.seed != null) 'seed': request.seed,
      if (request.steps != null) 'num_inference_steps': request.steps,
      if (request.guidanceScale != null)
        'guidance_scale': request.guidanceScale,
      if (request.enhancePrompt != null)
        'prompt_enhancement': request.enhancePrompt,
      if (request.style != null) 'style': request.style,
      if (request.quality != null) 'quality': request.quality,
    };

    final responseData = await client.postJson('images/generations', requestBody);
    
    final data = responseData['data'] as List?;
    if (data == null) {
      throw const ResponseFormatError(
        'Invalid response format from OpenAI image generation API',
        'Missing data field',
      );
    }

    // Extract images from response
    final images = data.map((item) {
      final itemMap = item as Map<String, dynamic>;
      return GeneratedImage(
        url: itemMap['url'] as String?,
        data: itemMap['b64_json'] != null
            ? base64Decode(itemMap['b64_json'] as String)
            : null,
        revisedPrompt: itemMap['revised_prompt'] as String?,
        format: 'png', // OpenAI DALL-E generates PNG images
      );
    }).toList();

    return ImageGenerationResponse(
      images: images,
      model: request.model ?? config.model,
      revisedPrompt: images.isNotEmpty ? images.first.revisedPrompt : null,
      usage: null, // OpenAI doesn't provide usage info for image generation
    );
  }

  @override
  List<String> getSupportedSizes() {
    return ['256x256', '512x512', '1024x1024', '1792x1024', '1024x1792'];
  }

  @override
  List<String> getSupportedFormats() {
    return ['png', 'b64_json'];
  }

  @override
  Future<List<String>> generateImage({
    required String prompt,
    String? model,
    String? negativePrompt,
    String? imageSize,
    int? batchSize,
    String? seed,
    int? numInferenceSteps,
    double? guidanceScale,
    bool? promptEnhancement,
  }) async {
    final response = await generateImages(
      ImageGenerationRequest(
        prompt: prompt,
        model: model,
        negativePrompt: negativePrompt,
        size: imageSize,
        count: batchSize,
        seed: seed != null ? int.tryParse(seed) : null,
        steps: numInferenceSteps,
        guidanceScale: guidanceScale,
        enhancePrompt: promptEnhancement,
      ),
    );

    return response.images
        .map((img) => img.url)
        .where((url) => url != null)
        .cast<String>()
        .toList();
  }

  /// Generate images using OpenAI's DALL-E models (legacy method)
  Future<List<String>> generateImageLegacy({
    String? model,
    required String prompt,
    String? negativePrompt,
    String? imageSize,
    int? batchSize,
    String? seed,
    int? numInferenceSteps,
    double? guidanceScale,
    bool? promptEnhancement,
  }) async {
    final requestBody = <String, dynamic>{
      'model': model ?? config.model,
      'prompt': prompt,
      if (negativePrompt != null) 'negative_prompt': negativePrompt,
      if (imageSize != null) 'image_size': imageSize,
      if (batchSize != null) 'batch_size': batchSize,
      if (seed != null) 'seed': int.tryParse(seed),
      if (numInferenceSteps != null) 'num_inference_steps': numInferenceSteps,
      if (guidanceScale != null) 'guidance_scale': guidanceScale,
      if (promptEnhancement != null) 'prompt_enhancement': promptEnhancement,
    };

    final responseData = await client.postJson('images/generations', requestBody);
    
    final data = responseData['data'] as List?;
    if (data == null) {
      throw const ResponseFormatError(
        'Invalid response format from OpenAI image generation API',
        'Missing data field',
      );
    }

    // Extract URLs from response
    final urls = data
        .map((item) => (item as Map<String, dynamic>)['url'] as String?)
        .where((url) => url != null)
        .cast<String>()
        .toList();

    return urls;
  }
}
