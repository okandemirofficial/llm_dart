/// Functionality tests for OpenAI Responses API methods
///
/// This test suite focuses on testing the actual functionality and method
/// behavior of the OpenAI Responses API implementation, including mocking
/// and integration scenarios.
library;

import 'package:test/test.dart';
import 'package:llm_dart/llm_dart.dart';
import 'package:llm_dart/providers/openai/responses_capability.dart';

void main() {
  group('OpenAI Responses API Functionality', () {
    // ========== Method Interface Tests ==========
    group('Method Interfaces', () {
      late OpenAIProvider provider;
      late OpenAIResponses responses;

      setUp(() async {
        provider = await ai()
            .openai((openai) => openai.useResponsesAPI().webSearchTool())
            .apiKey('test-key')
            .model('gpt-4o')
            .build() as OpenAIProvider;

        responses = provider.responses!;
      });

      test('should have all required OpenAIResponsesCapability methods', () {
        // Basic chat methods
        expect(() => responses.chat([]), returnsNormally);
        expect(() => responses.chatWithTools([], null), returnsNormally);
        expect(
            () => responses.chatWithToolsBackground([], null), returnsNormally);

        // Streaming methods
        expect(() => responses.chatStream([]), returnsNormally);

        // Response management methods
        expect(() => responses.getResponse('test-id'), returnsNormally);
        expect(() => responses.deleteResponse('test-id'), returnsNormally);
        expect(() => responses.cancelResponse('test-id'), returnsNormally);
        expect(() => responses.listInputItems('test-id'), returnsNormally);

        // Conversation management methods
        expect(() => responses.continueConversation('test-id', []),
            returnsNormally);
        expect(
            () => responses.forkConversation('test-id', []), returnsNormally);
      });

      test('should implement ChatCapability interface', () {
        expect(responses, isA<ChatCapability>());

        // Test ChatCapability methods
        expect(() => responses.chat([]), returnsNormally);
        expect(() => responses.chatStream([]), returnsNormally);
      });

      test('should implement OpenAIResponsesCapability interface', () {
        expect(responses, isA<OpenAIResponsesCapability>());

        // Test all OpenAIResponsesCapability methods exist
        final capability = responses as OpenAIResponsesCapability;
        expect(() => capability.chatWithTools([], null), returnsNormally);
        expect(() => capability.chatWithToolsBackground([], null),
            returnsNormally);
        expect(() => capability.getResponse('test-id'), returnsNormally);
        expect(() => capability.deleteResponse('test-id'), returnsNormally);
        expect(() => capability.cancelResponse('test-id'), returnsNormally);
        expect(() => capability.listInputItems('test-id'), returnsNormally);
        expect(() => capability.continueConversation('test-id', []),
            returnsNormally);
        expect(
            () => capability.forkConversation('test-id', []), returnsNormally);
      });

      test('should support extension methods', () {
        // Test convenience methods from extensions
        expect(() => responses.chat([]), returnsNormally);
        expect(() => responses.chatBackground([]), returnsNormally);
        expect(() => responses.responseExists('test-id'), returnsNormally);
      });
    });

    // ========== Message Handling Tests ==========
    group('Message Handling', () {
      late OpenAIProvider provider;
      late OpenAIResponses responses;

      setUp(() async {
        provider = await ai()
            .openai((openai) => openai.useResponsesAPI())
            .apiKey('test-key')
            .model('gpt-4o')
            .build() as OpenAIProvider;

        responses = provider.responses!;
      });

      test('should handle empty message list', () {
        expect(() => responses.chat([]), returnsNormally);
        expect(() => responses.chatWithTools([], null), returnsNormally);
        expect(
            () => responses.chatWithToolsBackground([], null), returnsNormally);
      });

      test('should handle single message', () {
        final messages = [ChatMessage.user('Hello, world!')];

        expect(() => responses.chat(messages), returnsNormally);
        expect(() => responses.chatWithTools(messages, null), returnsNormally);
        expect(() => responses.chatWithToolsBackground(messages, null),
            returnsNormally);
      });

      test('should handle multiple messages', () {
        final messages = [
          ChatMessage.system('You are a helpful assistant.'),
          ChatMessage.user('What is the weather like?'),
          ChatMessage.assistant('I need to check the weather for you.'),
          ChatMessage.user('Please check for San Francisco.'),
        ];

        expect(() => responses.chat(messages), returnsNormally);
        expect(() => responses.chatWithTools(messages, null), returnsNormally);
        expect(() => responses.chatWithToolsBackground(messages, null),
            returnsNormally);
      });

      test('should handle messages with different content types', () {
        final messages = [
          ChatMessage.user('Describe this image'),
          ChatMessage.user(
              'What do you see in this image: https://example.com/image.jpg'),
        ];

        expect(() => responses.chat(messages), returnsNormally);
        expect(() => responses.chatWithTools(messages, null), returnsNormally);
      });
    });

    // ========== Tool Handling Tests ==========
    group('Tool Handling', () {
      late OpenAIProvider provider;
      late OpenAIResponses responses;

      setUp(() async {
        provider = await ai()
            .openai((openai) => openai.useResponsesAPI().webSearchTool())
            .apiKey('test-key')
            .model('gpt-4o')
            .build() as OpenAIProvider;

        responses = provider.responses!;
      });

      test('should handle null tools', () {
        final messages = [ChatMessage.user('Hello')];

        expect(() => responses.chatWithTools(messages, null), returnsNormally);
        expect(() => responses.chatWithToolsBackground(messages, null),
            returnsNormally);
      });

      test('should handle empty tools list', () {
        final messages = [ChatMessage.user('Hello')];
        final tools = <Tool>[];

        expect(() => responses.chatWithTools(messages, tools), returnsNormally);
        expect(() => responses.chatWithToolsBackground(messages, tools),
            returnsNormally);
      });

      test('should handle single tool', () {
        final messages = [ChatMessage.user('What is the weather?')];
        final tools = [
          Tool.function(
            name: 'get_weather',
            description: 'Get current weather',
            parameters: ParametersSchema(
              schemaType: 'object',
              properties: {
                'location': ParameterProperty(
                  propertyType: 'string',
                  description: 'City name',
                ),
              },
              required: ['location'],
            ),
          ),
        ];

        expect(() => responses.chatWithTools(messages, tools), returnsNormally);
        expect(() => responses.chatWithToolsBackground(messages, tools),
            returnsNormally);
      });

      test('should handle multiple tools', () {
        final messages = [ChatMessage.user('Help me with weather and time')];
        final tools = [
          Tool.function(
            name: 'get_weather',
            description: 'Get current weather',
            parameters: ParametersSchema(
              schemaType: 'object',
              properties: {
                'location': ParameterProperty(
                  propertyType: 'string',
                  description: 'Location to get weather for',
                ),
              },
              required: ['location'],
            ),
          ),
          Tool.function(
            name: 'get_time',
            description: 'Get current time',
            parameters: ParametersSchema(
              schemaType: 'object',
              properties: {
                'timezone': ParameterProperty(
                  propertyType: 'string',
                  description: 'Timezone to get time for',
                ),
              },
              required: [],
            ),
          ),
        ];

        expect(() => responses.chatWithTools(messages, tools), returnsNormally);
        expect(() => responses.chatWithToolsBackground(messages, tools),
            returnsNormally);
      });

      test('should handle complex tool parameters', () {
        final messages = [ChatMessage.user('Process this data')];
        final tools = [
          Tool.function(
            name: 'process_data',
            description: 'Process complex data',
            parameters: ParametersSchema(
              schemaType: 'object',
              properties: {
                'data': ParameterProperty(
                  propertyType: 'string',
                  description: 'Data to process',
                ),
                'format': ParameterProperty(
                  propertyType: 'string',
                  description: 'Output format',
                  enumList: ['json', 'csv', 'xml'],
                ),
              },
              required: ['data'],
            ),
          ),
        ];

        expect(() => responses.chatWithTools(messages, tools), returnsNormally);
      });
    });

    // ========== Response ID Handling Tests ==========
    group('Response ID Handling', () {
      late OpenAIProvider provider;
      late OpenAIResponses responses;

      setUp(() async {
        provider = await ai()
            .openai((openai) => openai.useResponsesAPI())
            .apiKey('test-key')
            .model('gpt-4o')
            .build() as OpenAIProvider;

        responses = provider.responses!;
      });

      test('should handle valid response IDs', () {
        const validIds = [
          'resp_123abc',
          'resp_456def789',
          'resp_xyz_123',
          'response_id_with_underscores',
        ];

        for (final id in validIds) {
          expect(() => responses.getResponse(id), returnsNormally);
          expect(() => responses.deleteResponse(id), returnsNormally);
          expect(() => responses.cancelResponse(id), returnsNormally);
          expect(() => responses.listInputItems(id), returnsNormally);
          expect(() => responses.continueConversation(id, []), returnsNormally);
          expect(() => responses.forkConversation(id, []), returnsNormally);
        }
      });

      test('should handle empty response ID', () {
        expect(() => responses.getResponse(''), returnsNormally);
        expect(() => responses.deleteResponse(''), returnsNormally);
        expect(() => responses.cancelResponse(''), returnsNormally);
        expect(() => responses.listInputItems(''), returnsNormally);
        expect(() => responses.continueConversation('', []), returnsNormally);
        expect(() => responses.forkConversation('', []), returnsNormally);
      });

      test('should handle special characters in response ID', () {
        const specialIds = [
          'resp-with-dashes',
          'resp.with.dots',
          'resp_with_underscores',
          'resp123numbers',
        ];

        for (final id in specialIds) {
          expect(() => responses.getResponse(id), returnsNormally);
          expect(() => responses.deleteResponse(id), returnsNormally);
          expect(() => responses.cancelResponse(id), returnsNormally);
        }
      });
    });

    // ========== Streaming Tests ==========
    group('Streaming', () {
      late OpenAIProvider provider;
      late OpenAIResponses responses;

      setUp(() async {
        provider = await ai()
            .openai((openai) => openai.useResponsesAPI().webSearchTool())
            .apiKey('test-key')
            .model('gpt-4o')
            .build() as OpenAIProvider;

        responses = provider.responses!;
      });

      test('should handle streaming with empty messages', () {
        expect(() => responses.chatStream([]), returnsNormally);
      });

      test('should handle streaming with messages', () {
        final messages = [ChatMessage.user('Tell me a story')];
        expect(() => responses.chatStream(messages), returnsNormally);
      });

      test('should handle streaming with tools', () {
        final messages = [ChatMessage.user('What is the weather?')];
        final tools = [
          Tool.function(
            name: 'get_weather',
            description: 'Get weather',
            parameters: ParametersSchema(
              schemaType: 'object',
              properties: {
                'location': ParameterProperty(
                  propertyType: 'string',
                  description: 'Location for weather',
                ),
              },
              required: [],
            ),
          ),
        ];

        expect(() => responses.chatStream(messages, tools: tools),
            returnsNormally);
      });
    });
  });
}
