// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:typed_data';
import 'package:llm_dart/llm_dart.dart' hide OpenAIProvider, OpenAIConfig;
import 'package:llm_dart/providers/openai/openai.dart';

/// Comprehensive example demonstrating the OpenAI provider
///
/// This example showcases the modular architecture inspired by async-openai,
/// demonstrating how each capability is implemented in focused modules while
/// maintaining a clean, unified external API.
void main() async {
  // Get OpenAI API key from environment variable
  final apiKey = Platform.environment['OPENAI_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    print('❌ Please set OPENAI_API_KEY environment variable');
    print('   Example: export OPENAI_API_KEY="your-api-key"');
    exit(1);
  }

  print('=== OpenAI Provider Example ===\n');

  // Create OpenAI provider
  final config = OpenAIConfig(
    apiKey: apiKey,
    model: 'gpt-4o',
    baseUrl: 'https://api.openai.com/v1/',
    temperature: 0.7,
    maxTokens: 1000,
    systemPrompt: 'You are a helpful AI assistant.',
  );

  final provider = OpenAIProvider(config);

  print('✓ Modular OpenAI provider created');
  print('  Model: ${config.model}');
  print('  Base URL: ${config.baseUrl}');
  print('  Supported capabilities: ${provider.supportedCapabilities.length}\n');

  // Demonstrate each capability module
  await demonstrateChatCapability(provider);
  await demonstrateEmbeddingCapability(provider);
  await demonstrateAudioCapabilities(provider);
  await demonstrateImageGeneration(provider);
  await demonstrateFileManagement(provider);
  await demonstrateModeration(provider);
  await demonstrateModelListing(provider);
  await demonstrateAssistants(provider);
  await demonstrateCompletion(provider);

  // Demonstrate convenience functions
  await demonstrateConvenienceFunctions(apiKey);

  print('\n=== Modular Architecture Benefits ===');
  print('✓ Single Responsibility: Each module handles one capability');
  print('✓ Easier Testing: Modules can be tested independently');
  print('✓ Better Maintainability: Changes isolated to specific modules');
  print(
      '✓ Cleaner Code: Smaller, focused classes instead of monolithic provider');
  print('✓ Reusability: Modules can be reused across different providers');
}

/// Demonstrate chat capability (chat.dart module)
Future<void> demonstrateChatCapability(OpenAIProvider provider) async {
  print('📝 Chat Capability (chat.dart module):');

  try {
    final messages = [
      ChatMessage.user('What is the capital of France?'),
    ];

    final response = await provider.chat(messages);
    print('   Response: ${response.text}');

    // Demonstrate streaming
    print('   Streaming response:');
    await for (final event in provider.chatStream(messages)) {
      print('   Stream: ${event.toString()}');
      break; // Just show first chunk
    }

    print('   ✓ Chat module working correctly\n');
  } catch (e) {
    print('   ✗ Chat error: $e\n');
  }
}

/// Demonstrate embedding capability (embeddings.dart module)
Future<void> demonstrateEmbeddingCapability(OpenAIProvider provider) async {
  print('🔢 Embedding Capability (embeddings.dart module):');

  try {
    final embeddings = await provider.embed(['Hello world', 'AI is amazing']);
    print('   Generated ${embeddings.length} embeddings');
    print('   First embedding dimensions: ${embeddings.first.length}');

    final dimensions = await provider.getEmbeddingDimensions();
    print('   Model embedding dimensions: $dimensions');

    print('   ✓ Embeddings module working correctly\n');
  } catch (e) {
    print('   ✗ Embeddings error: $e\n');
  }
}

/// Demonstrate audio capabilities (audio.dart module)
Future<void> demonstrateAudioCapabilities(OpenAIProvider provider) async {
  print('🎵 Audio Capabilities (audio.dart module):');

  try {
    // Text-to-Speech
    final audioData = await provider.speech('Hello from modular OpenAI!');
    print('   Generated TTS audio: ${audioData.length} bytes');

    final voices = await provider.getVoices();
    print('   Available voices: ${voices.map((v) => v.name).join(', ')}');

    final formats = provider.getSupportedAudioFormats();
    print('   Supported formats: ${formats.join(', ')}');
    print('   ✓ Audio module working correctly\n');
  } catch (e) {
    print('   ✗ Audio error: $e\n');
  }
}

/// Demonstrate image generation (images.dart module)
Future<void> demonstrateImageGeneration(OpenAIProvider provider) async {
  print('🎨 Image Generation (images.dart module):');

  try {
    final images = await provider.generateImage(
      prompt: 'A beautiful sunset over mountains',
      imageSize: '1024x1024',
      batchSize: 1,
    );
    print('   Generated ${images.length} image(s)');

    final sizes = provider.getSupportedSizes();
    final formats = provider.getSupportedFormats();
    print('   Supported sizes: ${sizes.join(', ')}');
    print('   Supported formats: ${formats.join(', ')}');
    print('   ✓ Images module working correctly\n');
  } catch (e) {
    print('   ✗ Images error: $e\n');
  }
}

/// Demonstrate file management (files.dart module)
Future<void> demonstrateFileManagement(OpenAIProvider provider) async {
  print('📁 File Management (files.dart module):');

  try {
    // Upload a sample file
    final sampleData =
        Uint8List.fromList('Hello, this is a test file!'.codeUnits);
    final uploadedFile = await provider.uploadFile(CreateFileRequest(
      file: sampleData,
      filename: 'test.txt',
      purpose: FilePurpose.assistants,
    ));

    print('   Uploaded file: ${uploadedFile.id} (${uploadedFile.filename})');
    print('   File size: ${uploadedFile.bytes} bytes');

    // List files
    final filesResponse = await provider.listFiles();
    print('   Total files: ${filesResponse.data.length}');

    // Clean up
    await provider.deleteFile(uploadedFile.id);
    print('   File deleted successfully');

    print('   ✓ Files module working correctly\n');
  } catch (e) {
    print('   ✗ Files error: $e\n');
  }
}

/// Demonstrate moderation capability (moderation.dart module)
Future<void> demonstrateModeration(OpenAIProvider provider) async {
  print('🛡️  Moderation Capability (moderation.dart module):');

  try {
    final response = await provider.moderate(ModerationRequest(
      input: 'This is a safe message about AI technology.',
    ));

    final result = response.results.first;
    print('   Content flagged: ${result.flagged}');
    print('   Categories checked: ${result.categories.toJson().keys.length}');

    print('   ✓ Moderation module working correctly\n');
  } catch (e) {
    print('   ✗ Moderation error: $e\n');
  }
}

/// Demonstrate model listing (models.dart module)
Future<void> demonstrateModelListing(OpenAIProvider provider) async {
  print('🤖 Model Listing (models.dart module):');

  try {
    final models = await provider.models();
    print('   Available models: ${models.length}');

    final gptModels = models.where((m) => m.id.contains('gpt')).toList();
    print('   GPT models: ${gptModels.length}');

    if (gptModels.isNotEmpty) {
      print('   Example: ${gptModels.first.id}');
    }

    print('   ✓ Models module working correctly\n');
  } catch (e) {
    print('   ✗ Models error: $e\n');
  }
}

/// Demonstrate assistants capability (assistants.dart module)
Future<void> demonstrateAssistants(OpenAIProvider provider) async {
  print('🤖 Assistants Capability (assistants.dart module):');

  try {
    // Create an assistant
    final assistant = await provider.createAssistant(CreateAssistantRequest(
      model: 'gpt-4o',
      name: 'Math Tutor',
      description: 'A helpful math tutor assistant',
      instructions:
          'You are a patient math tutor. Help students understand mathematical concepts.',
      tools: [const CodeInterpreterTool()],
    ));

    print('   Created assistant: ${assistant.id} (${assistant.name})');
    print('   Tools: ${assistant.tools.length}');

    // List assistants
    final assistantsResponse = await provider.listAssistants();
    print('   Total assistants: ${assistantsResponse.data.length}');

    // Clean up
    await provider.deleteAssistant(assistant.id);
    print('   Assistant deleted successfully');

    print('   ✓ Assistants module working correctly\n');
  } catch (e) {
    print('   ✗ Assistants error: $e\n');
  }
}

/// Demonstrate completion capability (completion.dart module)
Future<void> demonstrateCompletion(OpenAIProvider provider) async {
  print('📝 Completion Capability (completion.dart module):');

  try {
    final response = await provider.complete(CompletionRequest(
      prompt: 'The future of artificial intelligence is',
      maxTokens: 50,
      temperature: 0.7,
    ));

    print('   Completion: ${response.text}');
    print('   Tokens used: ${response.usage?.totalTokens ?? 'unknown'}');

    print('   ✓ Completion module working correctly\n');
  } catch (e) {
    print('   ✗ Completion error: $e\n');
  }
}

/// Demonstrate convenience functions
Future<void> demonstrateConvenienceFunctions(String apiKey) async {
  print('🛠️  Convenience Functions:');

  try {
    // Using convenience function
    createOpenAIProvider(
      apiKey: apiKey,
      model: 'gpt-4o',
      temperature: 0.8,
    );
    print('   ✓ createOpenAIProvider() - Standard OpenAI');

    // Using OpenRouter
    createOpenRouterProvider(
      apiKey: apiKey,
      model: 'openai/gpt-4o',
    );
    print('   ✓ createOpenRouterProvider() - OpenRouter compatibility');

    // Using Groq (from modular provider)
    GroqProvider(GroqConfig(
      apiKey: apiKey,
      model: 'llama-3.1-70b-versatile',
    ));
    print('   ✓ GroqProvider() - Groq compatibility');

    // Using DeepSeek (from modular provider)
    DeepSeekProvider(DeepSeekConfig(
      apiKey: apiKey,
      model: 'deepseek-chat',
    ));
    print('   ✓ DeepSeekProvider() - DeepSeek compatibility');

    print('   ✓ All convenience functions working correctly\n');
  } catch (e) {
    print('   ✗ Convenience functions error: $e\n');
  }
}
