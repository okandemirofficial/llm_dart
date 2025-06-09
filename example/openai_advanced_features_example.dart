// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:typed_data';
import 'package:llm_dart/llm_dart.dart';

/// Capability checking helper method - Approach 1: Interface type checking
/// Pros: Compile-time type safety, direct interface implementation check
/// Cons: Requires knowledge of specific interface types
bool _checkCapability<T>(dynamic provider, String capabilityName) {
  if (provider is! T) {
    print('❌ Provider does not support $capabilityName');
    return false;
  }
  return true;
}

/// Capability checking helper method - Approach 2: Enum capability checking (Recommended)
/// Pros: Unified capability management, supports dynamic queries, more flexible
/// Cons: Requires provider to implement ProviderCapabilities interface
bool _checkCapabilityByEnum(
    dynamic provider, LLMCapability capability, String capabilityName) {
  if (provider is ProviderCapabilities) {
    if (!provider.supports(capability)) {
      print('❌ Provider does not support $capabilityName');
      return false;
    }
    return true;
  }
  print('❌ Provider does not implement capability checking');
  return false;
}

/// Example demonstrating advanced OpenAI features:
/// - Files API for file management
/// - Moderation API for content safety
/// - Assistants API for AI assistants
void main() async {
  // Get OpenAI API key from environment variable
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';

  // Create OpenAI provider with new capabilities
  final provider = await ai().openai().apiKey(apiKey).model('gpt-4').build();

  print('🚀 OpenAI Advanced Features Demo\n');

  // Demonstrate Files API
  await demonstrateFilesAPI(provider);

  // Demonstrate Moderation API
  await demonstrateModerationAPI(provider);

  // Demonstrate Assistants API
  await demonstrateAssistantsAPI(provider);
}

/// Demonstrate Files API functionality
Future<void> demonstrateFilesAPI(dynamic provider) async {
  print('📁 Files API Demo');
  print('=' * 50);

  // Use unified capability checking method
  if (!_checkCapability<FileManagementCapability>(
      provider, 'File Management')) {
    return;
  }

  try {
    // Create a sample file
    final sampleContent = '''
{
  "messages": [
    {"role": "user", "content": "Hello, world!"},
    {"role": "assistant", "content": "Hi there! How can I help you today?"}
  ]
}
''';

    final fileData = Uint8List.fromList(sampleContent.codeUnits);

    // Upload file
    print('📤 Uploading file...');
    final uploadRequest = CreateFileRequest(
      file: fileData,
      filename: 'sample_conversation.jsonl',
      purpose: FilePurpose.assistants,
    );

    final uploadedFile = await provider.uploadFile(uploadRequest);
    print('✅ File uploaded: ${uploadedFile.id} (${uploadedFile.filename})');
    print('   Size: ${uploadedFile.bytes} bytes');
    print('   Purpose: ${uploadedFile.purpose.value}');
    print('   Status: ${uploadedFile.status?.value ?? 'unknown'}');

    // List files
    print('\n📋 Listing files...');
    final filesResponse = await provider.listFiles(
      ListFilesQuery(purpose: FilePurpose.assistants, limit: 10),
    );
    print('✅ Found ${filesResponse.data.length} files:');
    for (final file in filesResponse.data.take(3)) {
      print('   - ${file.filename} (${file.id})');
    }

    // Retrieve specific file
    print('\n🔍 Retrieving file details...');
    final retrievedFile = await provider.retrieveFile(uploadedFile.id);
    print('✅ Retrieved file: ${retrievedFile.filename}');
    print(
        '   Created: ${DateTime.fromMillisecondsSinceEpoch(retrievedFile.createdAt * 1000)}');

    // Get file content
    print('\n📖 Getting file content...');
    final content = await provider.getFileContent(uploadedFile.id);
    final contentString = String.fromCharCodes(content);
    print('✅ File content (${content.length} bytes):');
    print('   ${contentString.substring(0, 100)}...');

    // Delete file
    print('\n🗑️ Deleting file...');
    final deleteResponse = await provider.deleteFile(uploadedFile.id);
    print('✅ File deleted: ${deleteResponse.deleted}');
  } catch (e) {
    print('❌ Files API error: $e');
  }

  print('\n');
}

/// Demonstrate Moderation API functionality
Future<void> demonstrateModerationAPI(dynamic provider) async {
  print('🛡️ Moderation API Demo');
  print('=' * 50);

  // Use capability enum checking (recommended approach)
  if (!_checkCapabilityByEnum(
      provider, LLMCapability.moderation, 'Moderation')) {
    return;
  }

  try {
    // Test various content types
    final testInputs = [
      'Hello, how are you today?',
      'I love programming and building cool applications!',
      'This is a normal conversation about technology.',
    ];

    for (final input in testInputs) {
      print('🔍 Moderating: "$input"');

      final moderationRequest = ModerationRequest(
        input: input,
        model: 'text-moderation-latest',
      );

      final response = await provider.moderate(moderationRequest);

      print('✅ Moderation result:');
      print('   Model: ${response.model}');
      print('   ID: ${response.id}');

      for (final result in response.results) {
        print('   Flagged: ${result.flagged}');
        if (result.flagged) {
          final categories = result.categories;
          print('   Categories flagged:');
          if (categories.hate) print('     - Hate');
          if (categories.harassment) print('     - Harassment');
          if (categories.selfHarm) print('     - Self-harm');
          if (categories.sexual) print('     - Sexual');
          if (categories.violence) print('     - Violence');
        } else {
          print('   ✅ Content is safe');
        }
      }
      print('');
    }
  } catch (e) {
    print('❌ Moderation API error: $e');
  }

  print('\n');
}

/// Demonstrate Assistants API functionality
Future<void> demonstrateAssistantsAPI(dynamic provider) async {
  print('🤖 Assistants API Demo');
  print('=' * 50);

  // Mixed usage of both checking approaches as example
  if (!_checkCapability<AssistantCapability>(provider, 'Assistants')) {
    return;
  }

  try {
    // Create an assistant
    print('🔨 Creating assistant...');
    final createRequest = CreateAssistantRequest(
      model: 'gpt-4',
      name: 'Code Helper',
      description: 'An assistant that helps with programming questions',
      instructions:
          'You are a helpful programming assistant. Provide clear, concise answers about coding concepts and help debug issues.',
      tools: [
        const CodeInterpreterTool(),
      ],
      metadata: {
        'created_by': 'llm_dart_example',
        'version': '1.0',
      },
    );

    final assistant = await provider.createAssistant(createRequest);
    print('✅ Assistant created: ${assistant.id}');
    print('   Name: ${assistant.name}');
    print('   Model: ${assistant.model}');
    print('   Tools: ${assistant.tools.length}');

    // List assistants
    print('\n📋 Listing assistants...');
    final assistantsResponse = await provider.listAssistants(
      ListAssistantsQuery(limit: 5, order: 'desc'),
    );
    print('✅ Found ${assistantsResponse.data.length} assistants:');
    for (final asst in assistantsResponse.data.take(3)) {
      print('   - ${asst.name ?? 'Unnamed'} (${asst.id})');
    }

    // Retrieve assistant
    print('\n🔍 Retrieving assistant...');
    final retrievedAssistant = await provider.retrieveAssistant(assistant.id);
    print('✅ Retrieved assistant: ${retrievedAssistant.name}');
    print(
        '   Instructions: ${retrievedAssistant.instructions?.substring(0, 50)}...');

    // Modify assistant
    print('\n✏️ Modifying assistant...');
    final modifyRequest = ModifyAssistantRequest(
      name: 'Advanced Code Helper',
      description: 'An enhanced assistant for complex programming tasks',
    );

    final modifiedAssistant =
        await provider.modifyAssistant(assistant.id, modifyRequest);
    print('✅ Assistant modified: ${modifiedAssistant.name}');

    // Delete assistant
    print('\n🗑️ Deleting assistant...');
    final deleteResponse = await provider.deleteAssistant(assistant.id);
    print('✅ Assistant deleted: ${deleteResponse.deleted}');
  } catch (e) {
    print('❌ Assistants API error: $e');
  }

  print('\n');
}
