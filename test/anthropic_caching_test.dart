import 'package:dio/dio.dart';
import 'package:llm_dart/llm_dart.dart';
import 'package:test/test.dart';

/// This test verifies that the Anthropic system prompt caching feature works correctly
/// by intercepting the raw HTTP request and asserting its structure.
///
/// To run this test:
/// 1. Replace 'your-anthropic-api-key' with your actual Anthropic API key.
/// 2. Run the test from your terminal: `dart test test/anthropic_caching_test.dart`
void main() {
  const String apiKey = 'your-anthropic-api-key'; // <-- Replace with your key

  // Skip the test if the API key is not provided.
  if (apiKey == 'your-anthropic-api-key' || apiKey.isEmpty) {
    print('API key not provided, skipping test.');
    return;
  }

  group('Anthropic Provider System Prompt Caching', () {
    test(
      'correctly sends caching payload on multiple requests',
      () async {
        // 1. Configure the provider
        final provider = createAnthropicProvider(
          apiKey: apiKey,
          model: 'claude-3-5-sonnet-20240620',
          systemPrompt: 'You are an expert on the US Constitution.',
          cachedSystemPrompt: 'Preamble: We the People...',
        );

        // 2. Intercept the request to verify its structure before it is sent.
        Map<String, dynamic>? capturedRequestData;
        provider.addInterceptorForTest(InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.data is Map<String, dynamic>) {
              capturedRequestData = options.data as Map<String, dynamic>;
            }
            handler.next(options);
          },
        ));

        // 3. Define messages, including a system message to test merging.
        final messages = [
          ChatMessage.system('The user is asking as a historian.'),
          ChatMessage.user('What is the purpose of the Preamble?'),
        ];

        try {
          // 4. Send the first chat request to trigger the interceptor.
          await provider.chat(messages);

          // 5. Assert the structure of the captured request body for the FIRST call.
          _verifyRequestPayload(capturedRequestData);

          // 6. Send a second request to ensure the payload remains correct.
          await provider.chat(messages);

          // 7. Assert the structure for the SECOND call.
          _verifyRequestPayload(capturedRequestData);
        } on AuthError catch (e) {
          fail(
              'Authentication failed: ${e.message}. Please check your API key.');
        } catch (e) {
          fail('An unexpected error occurred: $e');
        }
      },
      // Increase timeout for network request
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}

/// Helper function to run assertions on the captured request payload.
void _verifyRequestPayload(Map<String, dynamic>? requestData) {
  // --- Basic Checks ---
  expect(requestData, isNotNull,
      reason: 'Request data should have been captured by the interceptor.');

  final systemField = requestData!['system'];
  expect(systemField, isA<List>(),
      reason: 'The "system" field must be a list for caching to work.');

  final systemList = systemField as List;
  expect(systemList.length, 2,
      reason:
          'System list should have two blocks: one for normal prompts and one for the cached prompt.');

  // --- Verify Cached Block ---
  Map<String, dynamic>? cachedBlock;
  try {
    cachedBlock = systemList.firstWhere(
      (block) => block is Map && block.containsKey('cache_control'),
    ) as Map<String, dynamic>?;
  } catch (e) {
    // `firstWhere` throws if not found; we handle this with the expect below.
  }

  expect(cachedBlock, isNotNull,
      reason: 'A system block with "cache_control" must exist.');

  expect(cachedBlock!['cache_control'], {'type': 'ephemeral'},
      reason:
          'The "cache_control" value must be exactly `{\'type\': \'ephemeral\'}`.');
  expect(cachedBlock['text'], contains('Preamble: We the People...'),
      reason: 'The cached block text is incorrect.');

  // --- Verify Non-Cached Block ---
  Map<String, dynamic>? nonCachedBlock;
  try {
    nonCachedBlock = systemList.firstWhere(
      (block) => block is Map && !block.containsKey('cache_control'),
    ) as Map<String, dynamic>?;
  } catch (e) {
    // `firstWhere` throws if not found; we handle this with the expect below.
  }

  expect(nonCachedBlock, isNotNull,
      reason: 'A non-cached system block must exist.');
  expect(nonCachedBlock!['text'], contains('expert on the US Constitution'),
      reason: 'The config system prompt is missing from the non-cached block.');
  expect(nonCachedBlock['text'], contains('asking as a historian'),
      reason: 'The chat system message is missing from the non-cached block.');
}
