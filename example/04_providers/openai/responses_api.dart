/// Example demonstrating OpenAI's new Responses API
///
/// This example shows how to use the Responses API with built-in tools
/// like web search, file search, and computer use.
library;

import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['OPENAI_API_KEY'];
  if (apiKey == null) {
    print('Please set OPENAI_API_KEY environment variable');
    exit(1);
  }

  print('=== OpenAI Responses API Examples ===\n');

  // Example 1: Basic Responses API usage
  await basicResponsesAPIExample(apiKey);

  // Example 2: Web search with Responses API
  await webSearchExample(apiKey);

  // Example 3: File search with Responses API
  await fileSearchExample(apiKey);

  // Example 4: Multiple built-in tools
  await multipleToolsExample(apiKey);

  // Example 5: Streaming with Responses API
  await streamingExample(apiKey);
}

/// Example 1: Basic Responses API usage
Future<void> basicResponsesAPIExample(String apiKey) async {
  print('--- Example 1: Basic Responses API ---');

  try {
    final provider = await ai()
        .openai((openai) => openai.useResponsesAPI())
        .apiKey(apiKey)
        .model('gpt-4o')
        .temperature(0.7)
        .build();

    final messages = [
      ChatMessage.user(
          'Explain the difference between Responses API and Chat Completions API'),
    ];

    final response = await provider.chat(messages);
    print('Response: ${response.text}\n');

    if (response.thinking != null) {
      print('Thinking: ${response.thinking}\n');
    }
  } catch (e) {
    print('Error in basic example: $e\n');
  }
}

/// Example 2: Web search with Responses API
Future<void> webSearchExample(String apiKey) async {
  print('--- Example 2: Web Search ---');

  try {
    final provider = await ai()
        .openai((openai) => openai.useResponsesAPI().webSearchTool())
        .apiKey(apiKey)
        .model('gpt-4o')
        .build();

    final messages = [
      ChatMessage.user(
          'What are the latest developments in AI from this week?'),
    ];

    final response = await provider.chat(messages);
    print('Response with web search: ${response.text}\n');
  } catch (e) {
    print('Error in web search example: $e\n');
  }
}

/// Example 3: File search with Responses API
Future<void> fileSearchExample(String apiKey) async {
  print('--- Example 3: File Search ---');

  try {
    // Note: You would need to create vector stores first
    // This is just an example of the API usage
    final provider = await ai()
        .openai((openai) => openai.useResponsesAPI().fileSearchTool(
              vectorStoreIds: [
                'vs_example123'
              ], // Replace with actual vector store IDs
              parameters: {'max_results': 5},
            ))
        .apiKey(apiKey)
        .model('gpt-4o')
        .build();

    final messages = [
      ChatMessage.user(
          'Search for information about machine learning in the uploaded documents'),
    ];

    final response = await provider.chat(messages);
    print('Response with file search: ${response.text}\n');
  } catch (e) {
    print('Error in file search example (expected if no vector stores): $e\n');
  }
}

/// Example 4: Multiple built-in tools
Future<void> multipleToolsExample(String apiKey) async {
  print('--- Example 4: Multiple Built-in Tools ---');

  try {
    final provider = await ai()
        .openai((openai) => openai
            .useResponsesAPI()
            .webSearchTool()
            .fileSearchTool(vectorStoreIds: ['vs_example123']))
        .apiKey(apiKey)
        .model('gpt-4o')
        .build();

    final messages = [
      ChatMessage.user(
          'Compare recent AI news with information from my documents about AI trends'),
    ];

    final response = await provider.chat(messages);
    print('Response with multiple tools: ${response.text}\n');
  } catch (e) {
    print('Error in multiple tools example: $e\n');
  }
}

/// Example 5: Streaming with Responses API
Future<void> streamingExample(String apiKey) async {
  print('--- Example 5: Streaming ---');

  try {
    final provider = await ai()
        .openai((openai) => openai.useResponsesAPI().webSearchTool())
        .apiKey(apiKey)
        .model('gpt-4o')
        .build();

    final messages = [
      ChatMessage.user('Tell me about the latest AI research papers'),
    ];

    print('Streaming response:');
    await for (final event in provider.chatStream(messages)) {
      switch (event) {
        case TextDeltaEvent(delta: final delta):
          stdout.write(delta);
          break;
        case ThinkingDeltaEvent():
          // Thinking content (if any)
          break;
        case ToolCallDeltaEvent():
          print('\n[Tool call in progress...]');
          break;
        case CompletionEvent():
          print('\n[Stream completed]');
          break;
        case ErrorEvent():
          print('\n[Error occurred]');
          break;
      }
    }
    print('\n');
  } catch (e) {
    print('Error in streaming example: $e\n');
  }
}

/// Example 6: Computer use (commented out as it requires special access)
/*
Future<void> computerUseExample(String apiKey) async {
  print('--- Example 6: Computer Use ---');

  try {
    final provider = await ai()
        .openai((openai) => openai
            .useResponsesAPI()
            .computerUseTool(
              displayWidth: 1024,
              displayHeight: 768,
              environment: 'browser',
            ))
        .apiKey(apiKey)
        .model('computer-use-preview')
        .build();

    final messages = [
      ChatMessage.user('Help me search for information about Dart programming'),
    ];

    final response = await provider.chat(messages);
    print('Response with computer use: ${response.text}\n');
  } catch (e) {
    print('Error in computer use example: $e\n');
  }
}
*/

/// Example 7: Response chaining
Future<void> responseChainingExample(String apiKey) async {
  print('--- Example 7: Response Chaining ---');

  try {
    // First request
    final provider1 = await ai()
        .openai((openai) => openai.useResponsesAPI())
        .apiKey(apiKey)
        .model('gpt-4o')
        .build();

    final messages1 = [
      ChatMessage.user('Start a story about a robot learning to paint'),
    ];

    final response1 = await provider1.chat(messages1);
    print('First response: ${response1.text}\n');

    // TODO: Extract response ID from response1 and use it for chaining
    // This would require implementing response ID extraction in the response class

    /*
    // Second request using previous response ID
    final provider2 = await ai()
        .openai((openai) => openai
            .useResponsesAPI()
            .previousResponseId(response1.responseId)) // This would need to be implemented
        .apiKey(apiKey)
        .model('gpt-4o')
        .build();

    final messages2 = [
      ChatMessage.user('Continue the story with the robot discovering colors'),
    ];

    final response2 = await provider2.chat(messages2);
    print('Chained response: ${response2.text}\n');
    */
  } catch (e) {
    print('Error in response chaining example: $e\n');
  }
}
