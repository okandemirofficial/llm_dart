// /// Integration tests for OpenAI Responses API
// ///
// /// This test suite focuses on integration scenarios and realistic usage
// /// patterns for the OpenAI Responses API, including mock responses and
// /// end-to-end workflow testing.
// library;

// import 'package:test/test.dart';
// import 'package:llm_dart/llm_dart.dart';
// import 'package:llm_dart/models/responses_models.dart';

// void main() {
//   group('OpenAI Responses API Integration Tests', () {
//     // ========== Mock Response Tests ==========
//     group('Mock Response Handling', () {
//       test('should handle successful chat response structure', () {
//         // Mock a typical OpenAI Responses API response
//         final mockResponse = {
//           'id': 'resp_test_123abc',
//           'object': 'response',
//           'created': 1234567890,
//           'model': 'gpt-4o',
//           'output': [
//             {
//               'type': 'message',
//               'role': 'assistant',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text': 'Hello! How can I help you today?',
//                 }
//               ],
//             }
//           ],
//           'usage': {
//             'prompt_tokens': 10,
//             'completion_tokens': 15,
//             'total_tokens': 25,
//           },
//         };

//         // Test that we can parse this structure
//         expect(mockResponse['id'], equals('resp_test_123abc'));
//         expect(mockResponse['object'], equals('response'));
//         expect(mockResponse['output'], isA<List>());
//         expect(mockResponse['usage'], isA<Map>());
//       });

//       test('should handle response with thinking content', () {
//         final mockResponse = {
//           'id': 'resp_thinking_456',
//           'object': 'response',
//           'created': 1234567890,
//           'model': 'o3-mini',
//           'output': [
//             {
//               'type': 'reasoning',
//               'content': [
//                 {
//                   'type': 'thinking',
//                   'thinking': 'Let me think about this step by step...',
//                 }
//               ],
//             },
//             {
//               'type': 'message',
//               'role': 'assistant',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text': 'Based on my analysis, here is the answer...',
//                 }
//               ],
//             }
//           ],
//           'usage': {
//             'prompt_tokens': 20,
//             'completion_tokens': 30,
//             'reasoning_tokens': 100,
//             'total_tokens': 150,
//           },
//         };

//         final output = mockResponse['output'] as List;
//         expect(output, hasLength(2));
//         expect(output[0]['type'], equals('reasoning'));
//         expect(output[1]['type'], equals('message'));
//         final usage = mockResponse['usage'] as Map<String, dynamic>;
//         expect(usage['reasoning_tokens'], equals(100));
//       });

//       test('should handle response with tool calls', () {
//         final mockResponse = {
//           'id': 'resp_tools_789',
//           'object': 'response',
//           'created': 1234567890,
//           'model': 'gpt-4o',
//           'output': [
//             {
//               'type': 'message',
//               'role': 'assistant',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text': 'I need to search for current weather information.',
//                 },
//                 {
//                   'type': 'tool_call',
//                   'tool_call': {
//                     'id': 'call_weather_123',
//                     'type': 'function',
//                     'function': {
//                       'name': 'get_weather',
//                       'arguments': '{"location": "San Francisco, CA"}',
//                     },
//                   },
//                 }
//               ],
//             }
//           ],
//         };

//         final output = mockResponse['output'] as List;
//         final content = output[0]['content'] as List;
//         expect(content, hasLength(2));
//         expect(content[0]['type'], equals('text'));
//         expect(content[1]['type'], equals('tool_call'));
//         expect(
//             content[1]['tool_call']['function']['name'], equals('get_weather'));
//       });

//       test('should handle response with built-in tool usage', () {
//         final mockResponse = {
//           'id': 'resp_builtin_abc',
//           'object': 'response',
//           'created': 1234567890,
//           'model': 'gpt-4o',
//           'output': [
//             {
//               'type': 'message',
//               'role': 'assistant',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text':
//                       'Let me search for the latest information about that topic.',
//                 }
//               ],
//             },
//             {
//               'type': 'tool_use',
//               'tool_type': 'web_search_preview',
//               'query': 'latest AI developments 2024',
//               'results': [
//                 {
//                   'title': 'AI Breakthrough in 2024',
//                   'url': 'https://example.com/ai-news',
//                   'snippet':
//                       'Recent developments in artificial intelligence...',
//                 }
//               ],
//             },
//             {
//               'type': 'message',
//               'role': 'assistant',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text':
//                       'Based on my search, here are the latest AI developments...',
//                 }
//               ],
//             }
//           ],
//         };

//         final output = mockResponse['output'] as List;
//         expect(output, hasLength(3));
//         expect(output[1]['type'], equals('tool_use'));
//         expect(output[1]['tool_type'], equals('web_search_preview'));
//         expect(output[1]['results'], isA<List>());
//       });
//     });

//     // ========== Response Input Items Tests ==========
//     group('Response Input Items Integration', () {
//       test('should handle realistic input items list', () {
//         final mockInputItemsList = {
//           'object': 'list',
//           'data': [
//             {
//               'id': 'item_msg_001',
//               'type': 'message',
//               'role': 'user',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text': 'What is the capital of France?',
//                 }
//               ],
//             },
//             {
//               'id': 'item_msg_002',
//               'type': 'message',
//               'role': 'assistant',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text': 'The capital of France is Paris.',
//                 }
//               ],
//             },
//             {
//               'id': 'item_msg_003',
//               'type': 'message',
//               'role': 'user',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text': 'Tell me more about Paris.',
//                 }
//               ],
//             }
//           ],
//           'first_id': 'item_msg_001',
//           'last_id': 'item_msg_003',
//           'has_more': false,
//         };

//         final inputItemsList =
//             ResponseInputItemsList.fromJson(mockInputItemsList);

//         expect(inputItemsList.object, equals('list'));
//         expect(inputItemsList.data, hasLength(3));
//         expect(inputItemsList.firstId, equals('item_msg_001'));
//         expect(inputItemsList.lastId, equals('item_msg_003'));
//         expect(inputItemsList.hasMore, isFalse);

//         // Test individual items
//         expect(inputItemsList.data[0].id, equals('item_msg_001'));
//         expect(inputItemsList.data[0].role, equals('user'));
//         expect(inputItemsList.data[1].role, equals('assistant'));
//         expect(inputItemsList.data[2].role, equals('user'));
//       });

//       test('should handle paginated input items list', () {
//         final mockPaginatedList = {
//           'object': 'list',
//           'data': [
//             {
//               'id': 'item_page1_001',
//               'type': 'message',
//               'role': 'user',
//               'content': [
//                 {'type': 'text', 'text': 'First message'}
//               ],
//             },
//             {
//               'id': 'item_page1_002',
//               'type': 'message',
//               'role': 'assistant',
//               'content': [
//                 {'type': 'text', 'text': 'First response'}
//               ],
//             }
//           ],
//           'first_id': 'item_page1_001',
//           'last_id': 'item_page1_002',
//           'has_more': true,
//         };

//         final inputItemsList =
//             ResponseInputItemsList.fromJson(mockPaginatedList);

//         expect(inputItemsList.hasMore, isTrue);
//         expect(inputItemsList.data, hasLength(2));
//         expect(inputItemsList.firstId, equals('item_page1_001'));
//         expect(inputItemsList.lastId, equals('item_page1_002'));
//       });

//       test('should handle complex input items with multimodal content', () {
//         final mockComplexItems = {
//           'object': 'list',
//           'data': [
//             {
//               'id': 'item_multimodal_001',
//               'type': 'message',
//               'role': 'user',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text': 'Analyze this image and data:',
//                 },
//                 {
//                   'type': 'image_url',
//                   'image_url': {
//                     'url': 'https://example.com/chart.png',
//                     'detail': 'high',
//                   },
//                 },
//                 {
//                   'type': 'text',
//                   'text': 'What trends do you see?',
//                 }
//               ],
//             },
//             {
//               'id': 'item_tool_response_001',
//               'type': 'tool_response',
//               'tool_call_id': 'call_analysis_123',
//               'content': [
//                 {
//                   'type': 'text',
//                   'text':
//                       'Analysis results: The chart shows an upward trend...',
//                 }
//               ],
//             }
//           ],
//           'first_id': 'item_multimodal_001',
//           'last_id': 'item_tool_response_001',
//           'has_more': false,
//         };

//         final inputItemsList =
//             ResponseInputItemsList.fromJson(mockComplexItems);

//         expect(inputItemsList.data, hasLength(2));
//         expect(inputItemsList.data[0].type, equals('message'));
//         expect(inputItemsList.data[0].content, hasLength(3));
//         expect(inputItemsList.data[1].type, equals('tool_response'));
//       });
//     });

//     // ========== Error Response Tests ==========
//     group('Error Response Integration', () {
//       test('should handle API error response format', () {
//         final mockErrorResponse = {
//           'error': {
//             'message': 'Invalid response ID provided',
//             'type': 'invalid_request_error',
//             'param': 'response_id',
//             'code': 'invalid_response_id',
//           }
//         };

//         final error = mockErrorResponse['error'] as Map<String, dynamic>;
//         expect(error, isA<Map>());
//         expect(error['message'], isA<String>());
//         expect(error['type'], equals('invalid_request_error'));
//         expect(error['code'], equals('invalid_response_id'));
//       });

//       test('should handle rate limit error response', () {
//         final mockRateLimitError = {
//           'error': {
//             'message': 'Rate limit exceeded for responses API',
//             'type': 'rate_limit_error',
//             'param': null,
//             'code': 'rate_limit_exceeded',
//           }
//         };

//         final rateLimitError =
//             mockRateLimitError['error'] as Map<String, dynamic>;
//         expect(rateLimitError['type'], equals('rate_limit_error'));
//         expect(rateLimitError['code'], equals('rate_limit_exceeded'));
//       });

//       test('should handle server error response', () {
//         final mockServerError = {
//           'error': {
//             'message': 'Internal server error occurred',
//             'type': 'server_error',
//             'param': null,
//             'code': 'internal_error',
//           }
//         };

//         final serverError = mockServerError['error'] as Map<String, dynamic>;
//         expect(serverError['type'], equals('server_error'));
//         expect(serverError['code'], equals('internal_error'));
//       });
//     });

//     // ========== Workflow Integration Tests ==========
//     group('Workflow Integration', () {
//       test('should support complete conversation workflow', () async {
//         // This test demonstrates the expected workflow without actual API calls
//         final provider = await ai()
//             .openai((openai) => openai.useResponsesAPI().webSearchTool())
//             .apiKey('test-key')
//             .model('gpt-4o')
//             .build() as OpenAIProvider;

//         final responses = provider.responses!;

//         // Step 1: Initial conversation
//         expect(
//             () => responses.chat([
//                   ChatMessage.user('Tell me about renewable energy trends'),
//                 ]),
//             returnsNormally);

//         // Step 2: Continue conversation (would use response ID from step 1)
//         expect(
//             () => responses.continueConversation('resp_123', [
//                   ChatMessage.user('What about solar energy specifically?'),
//                 ]),
//             returnsNormally);

//         // Step 3: Fork conversation for different topic
//         expect(
//             () => responses.forkConversation('resp_123', [
//                   ChatMessage.user('What about wind energy instead?'),
//                 ]),
//             returnsNormally);

//         // Step 4: Background processing
//         expect(
//             () => responses.chatWithToolsBackground([
//                   ChatMessage.user(
//                       'Generate a detailed report on renewable energy'),
//                 ], null),
//             returnsNormally);

//         // Step 5: Response management
//         expect(() => responses.getResponse('resp_background_456'),
//             returnsNormally);
//         expect(() => responses.listInputItems('resp_background_456'),
//             returnsNormally);
//         expect(() => responses.deleteResponse('resp_background_456'),
//             returnsNormally);
//       });

//       test('should support streaming workflow', () async {
//         final provider = await ai()
//             .openai((openai) => openai.useResponsesAPI())
//             .apiKey('test-key')
//             .model('gpt-4o')
//             .build() as OpenAIProvider;

//         final responses = provider.responses!;

//         // Test streaming setup
//         expect(
//             () => responses.chatStream([
//                   ChatMessage.user('Tell me a story'),
//                 ]),
//             returnsNormally);

//         // Test streaming with tools
//         expect(
//             () => responses.chatStream([
//                   ChatMessage.user('What is the weather like?'),
//                 ], tools: [
//                   Tool.function(
//                     name: 'get_weather',
//                     description: 'Get weather information',
//                     parameters: ParametersSchema(
//                       schemaType: 'object',
//                       properties: {
//                         'location': ParameterProperty(
//                           propertyType: 'string',
//                           description: 'Location for weather',
//                         ),
//                       },
//                       required: [],
//                     ),
//                   ),
//                 ]),
//             returnsNormally);
//       });

//       test('should support buildOpenAIResponses workflow', () async {
//         // Test the convenience method workflow
//         final provider = await ai()
//             .openai((openai) => openai
//                 .webSearchTool()
//                 .fileSearchTool(vectorStoreIds: ['vs_123']))
//             .apiKey('test-key')
//             .model('gpt-4o')
//             .buildOpenAIResponses();

//         expect(provider, isA<OpenAIProvider>());
//         expect(provider.responses, isNotNull);
//         expect(provider.supports(LLMCapability.openaiResponses), isTrue);

//         // Test direct access without casting
//         final directResponses = provider.responses!;
//         expect(
//             () => directResponses.chat([
//                   ChatMessage.user('Search for AI news and analyze documents'),
//                 ]),
//             returnsNormally);
//       });
//     });
//   });
// }
