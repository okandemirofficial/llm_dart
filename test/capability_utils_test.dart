import 'package:test/test.dart';
import 'package:llm_dart/llm_dart.dart';

void main() {
  group('CapabilityUtils Tests', () {
    late OpenAIProvider provider;
    late _MockProvider mockProvider;

    setUp(() {
      provider = OpenAIProvider(
        OpenAIConfig(
          apiKey: 'test-key',
          baseUrl: 'https://api.openai.com/v1',
        ),
      );
      
      mockProvider = _MockProvider();
    });

    group('Basic Capability Checking', () {
      test('hasCapability should work correctly', () {
        expect(CapabilityUtils.hasCapability<FileManagementCapability>(provider), isTrue);
        expect(CapabilityUtils.hasCapability<ModerationCapability>(provider), isTrue);
        expect(CapabilityUtils.hasCapability<AssistantCapability>(provider), isTrue);
        expect(CapabilityUtils.hasCapability<FileManagementCapability>(mockProvider), isFalse);
      });

      test('supportsCapability should work correctly', () {
        expect(CapabilityUtils.supportsCapability(provider, LLMCapability.fileManagement), isTrue);
        expect(CapabilityUtils.supportsCapability(provider, LLMCapability.moderation), isTrue);
        expect(CapabilityUtils.supportsCapability(provider, LLMCapability.assistants), isTrue);
        expect(CapabilityUtils.supportsCapability(mockProvider, LLMCapability.fileManagement), isFalse);
      });

      test('supportsAllCapabilities should work correctly', () {
        final capabilities = {LLMCapability.chat, LLMCapability.fileManagement};
        expect(CapabilityUtils.supportsAllCapabilities(provider, capabilities), isTrue);
        expect(CapabilityUtils.supportsAllCapabilities(mockProvider, capabilities), isFalse);
      });

      test('supportsAnyCapability should work correctly', () {
        final capabilities = {LLMCapability.fileManagement, LLMCapability.moderation};
        expect(CapabilityUtils.supportsAnyCapability(provider, capabilities), isTrue);
        expect(CapabilityUtils.supportsAnyCapability(mockProvider, capabilities), isFalse);
      });
    });

    group('Safe Execution Patterns', () {
      test('withCapability should return result when supported', () async {
        final result = await CapabilityUtils.withCapability<ChatCapability, String>(
          provider,
          (chatProvider) async => 'success',
        );
        expect(result, equals('success'));
      });

      test('withCapability should return null when not supported', () async {
        final result = await CapabilityUtils.withCapability<FileManagementCapability, String>(
          mockProvider,
          (fileProvider) async => 'success',
        );
        expect(result, isNull);
      });

      test('requireCapability should work when supported', () async {
        final result = await CapabilityUtils.requireCapability<ChatCapability, String>(
          provider,
          (chatProvider) async => 'success',
        );
        expect(result, equals('success'));
      });

      test('requireCapability should throw when not supported', () async {
        expect(
          () => CapabilityUtils.requireCapability<FileManagementCapability, String>(
            mockProvider,
            (fileProvider) async => 'success',
          ),
          throwsA(isA<CapabilityError>()),
        );
      });

      test('withFallback should use primary when supported', () async {
        final result = await CapabilityUtils.withFallback<ChatCapability, String>(
          provider,
          (chatProvider) async => 'primary',
          () async => 'fallback',
        );
        expect(result, equals('primary'));
      });

      test('withFallback should use fallback when not supported', () async {
        final result = await CapabilityUtils.withFallback<FileManagementCapability, String>(
          mockProvider,
          (fileProvider) async => 'primary',
          () async => 'fallback',
        );
        expect(result, equals('fallback'));
      });
    });

    group('Capability Discovery', () {
      test('getCapabilities should return correct capabilities', () {
        final capabilities = CapabilityUtils.getCapabilities(provider);
        expect(capabilities.contains(LLMCapability.chat), isTrue);
        expect(capabilities.contains(LLMCapability.fileManagement), isTrue);
        expect(capabilities.contains(LLMCapability.moderation), isTrue);
        expect(capabilities.contains(LLMCapability.assistants), isTrue);
      });

      test('getCapabilitySummary should return correct summary', () {
        final summary = CapabilityUtils.getCapabilitySummary(provider);
        expect(summary['chat'], isTrue);
        expect(summary['fileManagement'], isTrue);
        expect(summary['moderation'], isTrue);
        expect(summary['assistants'], isTrue);
      });

      test('getMissingCapabilities should work correctly', () {
        final required = {LLMCapability.chat, LLMCapability.fileManagement};
        final missing = CapabilityUtils.getMissingCapabilities(mockProvider, required);
        expect(missing.contains(LLMCapability.fileManagement), isTrue);
      });
    });

    group('Validation', () {
      test('validateRequirements should work correctly', () {
        final required = {LLMCapability.chat};
        expect(CapabilityUtils.validateRequirements(provider, required), isTrue);
        expect(CapabilityUtils.validateRequirements(mockProvider, {LLMCapability.fileManagement}), isFalse);
      });

      test('validateProvider should return correct report', () {
        final required = {LLMCapability.chat, LLMCapability.fileManagement};
        final report = CapabilityUtils.validateProvider(provider, required);
        
        expect(report.isValid, isTrue);
        expect(report.required, equals(required));
        expect(report.missing.isEmpty, isTrue);
      });
    });
  });

  group('ProviderRegistry Tests', () {
    late ProviderRegistry registry;
    late OpenAIProvider provider;
    late _MockProvider mockProvider;

    setUp(() {
      registry = ProviderRegistry();
      provider = OpenAIProvider(
        OpenAIConfig(
          apiKey: 'test-key',
          baseUrl: 'https://api.openai.com/v1',
        ),
      );
      mockProvider = _MockProvider();
    });

    test('registerProvider should work correctly', () {
      registry.registerProvider('openai', provider);
      expect(registry.providerCount, equals(1));
      expect(registry.getProviderIds(), contains('openai'));
    });

    test('getProvider should return correct provider', () {
      registry.registerProvider('openai', provider);
      final retrieved = registry.getProvider<OpenAIProvider>('openai');
      expect(retrieved, equals(provider));
    });

    test('hasCapability should work correctly', () {
      registry.registerProvider('openai', provider);
      expect(registry.hasCapability('openai', LLMCapability.chat), isTrue);
      expect(registry.hasCapability('openai', LLMCapability.fileManagement), isTrue);
    });

    test('findProvidersWithCapability should work correctly', () {
      registry.registerProvider('openai', provider);
      registry.registerProvider('mock', mockProvider);
      
      final chatProviders = registry.findProvidersWithCapability(LLMCapability.chat);
      expect(chatProviders, contains('openai'));
      expect(chatProviders, contains('mock'));
      
      final fileProviders = registry.findProvidersWithCapability(LLMCapability.fileManagement);
      expect(fileProviders, contains('openai'));
      expect(fileProviders, isNot(contains('mock')));
    });

    test('findBestProvider should work correctly', () {
      registry.registerProvider('openai', provider);
      registry.registerProvider('mock', mockProvider);
      
      final best = registry.findBestProvider({LLMCapability.chat});
      expect(best, isNotNull);
      
      final bestForFiles = registry.findBestProvider({LLMCapability.fileManagement});
      expect(bestForFiles, equals('openai'));
    });

    test('unregisterProvider should work correctly', () {
      registry.registerProvider('openai', provider);
      expect(registry.providerCount, equals(1));
      
      final removed = registry.unregisterProvider('openai');
      expect(removed, isTrue);
      expect(registry.providerCount, equals(0));
    });

    test('getStats should return correct statistics', () {
      registry.registerProvider('openai', provider);
      registry.registerProvider('mock', mockProvider);
      
      final stats = registry.getStats();
      expect(stats.totalProviders, equals(2));
      expect(stats.totalCapabilities, greaterThan(0));
      expect(stats.averageCapabilitiesPerProvider, greaterThan(0));
    });
  });

  group('Error Handling', () {
    test('CapabilityError should work correctly', () {
      final error = CapabilityError('Test error message');
      expect(error.message, equals('Test error message'));
      expect(error.toString(), contains('Test error message'));
    });
  });
}

/// Mock provider for testing
class _MockProvider implements ChatCapability {
  @override
  Future<ChatResponse> chat(ChatRequest request) async {
    throw UnimplementedError('Mock provider - not implemented');
  }

  @override
  Stream<ChatResponse> chatStream(ChatRequest request) {
    throw UnimplementedError('Mock provider - not implemented');
  }
}
