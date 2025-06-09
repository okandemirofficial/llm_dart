// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:typed_data';
import 'package:llm_dart/llm_dart.dart';

/// Comprehensive capability usage example
/// Shows all capability checking patterns and utility usage in one place
void main() async {
  print('🛠️ Capability Usage Guide\n');

  // Part A: Provider Factory Capabilities (compile-time)
  await demonstrateFactoryCapabilities();

  // Part B: Runtime Provider Capabilities (runtime)
  await demonstrateRuntimeCapabilities();
}

/// Part A: Provider Factory Capabilities (compile-time checking)
Future<void> demonstrateFactoryCapabilities() async {
  print('🏭 Part A: Provider Factory Capabilities');
  print('   Query capabilities before creating providers\n');

  // Print capability matrix for all registered providers
  _printCapabilityMatrix();

  // Find providers with specific capabilities
  print('\n   🔍 Finding providers by capability:');
  final embeddingProviders =
      _getProvidersWithCapability(LLMCapability.embedding);
  print('      📊 Embedding: ${embeddingProviders.join(', ')}');

  final fileProviders =
      _getProvidersWithCapability(LLMCapability.fileManagement);
  print('      📁 File Management: ${fileProviders.join(', ')}');

  // Find best provider for requirements
  final requirements = {LLMCapability.chat, LLMCapability.fileManagement};
  final bestProvider = _getBestProviderFor(requirements);
  print('      🎯 Best for chat + files: ${bestProvider ?? 'None'}');

  print(
      '\n   💡 Use factory capabilities to choose providers before creation\n');
}

/// Part B: Runtime Provider Capabilities (after creation)
Future<void> demonstrateRuntimeCapabilities() async {
  print('⚡ Part B: Runtime Provider Capabilities');
  print('   Work with created provider instances\n');

  // Get OpenAI API key from environment variable
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';

  // Create OpenAI provider
  final provider = await ai().openai().apiKey(apiKey).model('gpt-4').build();

  print('📋 Available Runtime Patterns:\n');

  // Pattern 1: Basic checking (simple projects)
  await demonstrateBasicChecking(provider);

  // Pattern 2: Safe execution utilities (recommended)
  await demonstrateSafeExecution(provider);

  // Pattern 3: Provider registry (enterprise)
  await demonstrateProviderRegistry(provider);

  // Pattern 4: Capability discovery and validation
  await demonstrateCapabilityDiscovery(provider);
}

/// Pattern 1: Basic capability checking
Future<void> demonstrateBasicChecking(dynamic provider) async {
  print('1️⃣ Basic Capability Checking');
  print('   Simple interface and enum-based checks\n');

  // Method 1: Interface checking (compile-time safe)
  if (provider is FileManagementCapability) {
    print('   ✅ Provider supports file management (interface check)');
    // Now you can safely call: provider.uploadFile(), provider.listFiles(), etc.
  }

  // Method 2: Enum checking (runtime flexible)
  if (CapabilityUtils.supportsCapability(provider, LLMCapability.moderation)) {
    print('   ✅ Provider supports moderation (enum check)');
  }

  // Method 3: Multiple capability checking
  final requiredCaps = {LLMCapability.fileManagement, LLMCapability.assistants};
  final hasAll =
      CapabilityUtils.supportsAllCapabilities(provider, requiredCaps);
  print('   📊 Has all required capabilities: $hasAll\n');
}

/// Pattern 2: Safe execution utilities (recommended approach)
Future<void> demonstrateSafeExecution(dynamic provider) async {
  print('2️⃣ Safe Execution Utilities (Recommended)');
  print('   Type-safe execution with automatic capability checking\n');

  // File Management Example
  print('   📁 File Management:');
  final fileResult =
      await CapabilityUtils.withCapability<FileManagementCapability, String>(
    provider,
    (fileProvider) async {
      // fileProvider is guaranteed to be FileManagementCapability
      // Available methods:
      // - await fileProvider.uploadFile(CreateFileRequest(...))
      // - await fileProvider.listFiles(ListFilesQuery(...))
      // - await fileProvider.retrieveFile(fileId)
      // - await fileProvider.deleteFile(fileId)
      // - await fileProvider.getFileContent(fileId)

      try {
        // Example: Upload a file
        final sampleData = Uint8List.fromList('Hello, World!'.codeUnits);
        final request = CreateFileRequest(
          file: sampleData,
          filename: 'sample.txt',
          purpose: FilePurpose.assistants,
        );

        final uploadedFile = await fileProvider.uploadFile(request);
        return 'File uploaded: ${uploadedFile.id}';
      } catch (e) {
        return 'File operation failed: ${e.toString().split('\n').first}';
      }
    },
  );
  print('      Result: ${fileResult ?? 'Not supported'}');

  // Moderation Example
  print('\n   🛡️ Content Moderation:');
  final moderationResult =
      await CapabilityUtils.withCapability<ModerationCapability, String>(
    provider,
    (moderationProvider) async {
      // moderationProvider is guaranteed to be ModerationCapability
      // Available methods:
      // - await moderationProvider.moderate(ModerationRequest(...))

      try {
        final request = ModerationRequest(
          input: 'This is a test message for content moderation',
          model: 'text-moderation-latest',
        );

        final response = await moderationProvider.moderate(request);
        final flagged = response.results.any((r) => r.flagged);
        return 'Content ${flagged ? 'flagged' : 'safe'}';
      } catch (e) {
        return 'Moderation failed: ${e.toString().split('\n').first}';
      }
    },
  );
  print('      Result: ${moderationResult ?? 'Not supported'}');

  // Assistant Example
  print('\n   🤖 AI Assistants:');
  final assistantResult =
      await CapabilityUtils.withCapability<AssistantCapability, String>(
    provider,
    (assistantProvider) async {
      // assistantProvider is guaranteed to be AssistantCapability
      // Available methods:
      // - await assistantProvider.createAssistant(CreateAssistantRequest(...))
      // - await assistantProvider.listAssistants(ListAssistantsQuery(...))
      // - await assistantProvider.retrieveAssistant(assistantId)
      // - await assistantProvider.modifyAssistant(assistantId, ModifyAssistantRequest(...))
      // - await assistantProvider.deleteAssistant(assistantId)

      try {
        final request = CreateAssistantRequest(
          model: 'gpt-4',
          name: 'Code Helper',
          description: 'A helpful coding assistant',
          instructions: 'You are a helpful programming assistant.',
          tools: [const CodeInterpreterTool()],
        );

        final assistant = await assistantProvider.createAssistant(request);

        // Clean up - delete the assistant
        await assistantProvider.deleteAssistant(assistant.id);

        return 'Assistant created and deleted: ${assistant.name}';
      } catch (e) {
        return 'Assistant operation failed: ${e.toString().split('\n').first}';
      }
    },
  );
  print('      Result: ${assistantResult ?? 'Not supported'}');

  // Fallback Pattern Example
  print('\n   🔄 Fallback Pattern:');
  final fallbackResult =
      await CapabilityUtils.withFallback<AssistantCapability, String>(
    provider,
    (assistantProvider) async {
      // Primary: Use Assistants API
      // assistantProvider has all AssistantCapability methods available
      return 'Using OpenAI Assistants API';
    },
    () async {
      // Fallback: Use regular chat
      return 'Using fallback: Regular chat instead of assistants';
    },
  );
  print('      Result: $fallbackResult\n');
}

/// Pattern 3: Provider registry for enterprise applications
Future<void> demonstrateProviderRegistry(dynamic provider) async {
  print('3️⃣ Provider Registry (Enterprise)');
  print('   Advanced provider management and selection\n');

  // Create and populate registry
  final registry = ProviderRegistry();
  registry.registerProvider('openai', provider, metadata: {
    'name': 'OpenAI GPT',
    'cost_tier': 'premium',
    'region': 'global',
  });

  // Find providers with specific capabilities
  final fileProviders =
      registry.findProvidersWithCapability(LLMCapability.fileManagement);
  print('   📁 Providers with file management: ${fileProviders.join(', ')}');

  // Execute with best available provider
  final result = await registry.withBestProvider(
    {LLMCapability.chat, LLMCapability.fileManagement},
    (providerId, selectedProvider) async {
      // selectedProvider is guaranteed to have the required capabilities
      // You can safely cast it to the needed interface:
      // final fileProvider = selectedProvider as FileManagementCapability;
      // final chatProvider = selectedProvider as ChatCapability;

      return 'Executed with provider: $providerId';
    },
  );
  print('   ✅ Execution result: ${result ?? 'No suitable provider found'}');

  // Get registry statistics
  final stats = registry.getStats();
  print(
      '   📊 Registry: ${stats.totalProviders} providers, ${stats.totalCapabilities} capabilities\n');
}

/// Pattern 4: Capability discovery and validation
Future<void> demonstrateCapabilityDiscovery(dynamic provider) async {
  print('4️⃣ Capability Discovery & Validation');
  print('   Analyze and validate provider capabilities\n');

  // Get all supported capabilities
  final capabilities = CapabilityUtils.getCapabilities(provider);
  print('   📋 Supported capabilities (${capabilities.length}):');
  for (final cap in capabilities.take(5)) {
    print('      ✅ ${cap.name}');
  }
  if (capabilities.length > 5) {
    print('      ... and ${capabilities.length - 5} more');
  }

  // Validate against requirements
  final requirements = {
    LLMCapability.chat,
    LLMCapability.fileManagement,
    LLMCapability.assistants,
  };

  final report = CapabilityUtils.validateProvider(provider, requirements);
  print('\n   🔍 Validation Report:');
  print('      Status: ${report.isValid ? 'PASSED ✅' : 'FAILED ❌'}');
  print('      Required: ${report.required.length} capabilities');
  print('      Supported: ${report.supported.length} capabilities');

  if (report.missing.isNotEmpty) {
    print('      Missing: ${report.missing.map((c) => c.name).join(', ')}');
  }

  // Execute multiple operations based on available capabilities
  print('\n   🚀 Multi-capability execution:');
  final results = await CapabilityUtils.executeByCapabilities(
    provider,
    {
      LLMCapability.fileManagement: () async {
        // This runs only if file management is supported
        return 'Files: Ready';
      },
      LLMCapability.moderation: () async {
        // This runs only if moderation is supported
        return 'Moderation: Ready';
      },
      LLMCapability.assistants: () async {
        // This runs only if assistants are supported
        return 'Assistants: Ready';
      },
    },
  );

  results.forEach((capability, result) {
    final icon = result == 'Not supported' ? '❌' : '✅';
    print('      $icon $capability: $result');
  });

  print('\n✅ All capability patterns demonstrated!');
  print('\n💡 Choose the pattern that fits your needs:');
  print('   • Basic checking: Simple projects, direct control');
  print('   • Safe execution: Most projects, type-safe and clean');
  print('   • Provider registry: Enterprise apps, multiple providers');
  print('   • Discovery/validation: Dynamic requirements, analysis');
}

// ========== Factory Capability Helper Functions ==========

/// Print capability matrix for all registered providers
void _printCapabilityMatrix() {
  final capabilities = _getAllProviderCapabilities();
  final allCapabilities = LLMCapability.values;

  print('   📊 Provider Capability Matrix:');
  print('');

  // Header
  final header = '   Provider'.padRight(15);
  final capHeaders = allCapabilities
      .take(6) // Show first 6 capabilities to fit in console
      .map((cap) => cap.name.substring(0, 4).padRight(5))
      .join('');
  print('$header $capHeaders ...');
  print('   ${'-' * (header.length + capHeaders.length)}');

  // Rows
  for (final entry in capabilities.entries.take(5)) {
    final provider = '   ${entry.key}'.padRight(15);
    final caps = allCapabilities.take(6).map((cap) {
      final supported = entry.value.contains(cap);
      return (supported ? '✅' : '❌').padRight(5);
    }).join('');
    print('$provider $caps');
  }
}

/// Get all registered providers and their capabilities
Map<String, Set<LLMCapability>> _getAllProviderCapabilities() {
  final capabilities = <String, Set<LLMCapability>>{};
  final factories = LLMProviderRegistry.getAllFactories();

  for (final factory in factories.values) {
    capabilities[factory.providerId] = factory.supportedCapabilities;
  }

  return capabilities;
}

/// Get providers that support a specific capability
List<String> _getProvidersWithCapability(LLMCapability capability) {
  final providers = <String>[];
  final factories = LLMProviderRegistry.getAllFactories();

  for (final factory in factories.values) {
    if (factory.supportedCapabilities.contains(capability)) {
      providers.add(factory.providerId);
    }
  }

  return providers;
}

/// Get the best provider for a set of required capabilities
String? _getBestProviderFor(Set<LLMCapability> requiredCapabilities) {
  final factories = LLMProviderRegistry.getAllFactories();

  for (final factory in factories.values) {
    if (requiredCapabilities
        .every((cap) => factory.supportedCapabilities.contains(cap))) {
      return factory.providerId;
    }
  }

  return null;
}
