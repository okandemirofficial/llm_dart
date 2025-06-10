// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';
import 'package:mcp_dart/mcp_dart.dart' hide Tool;
import 'mcp_tool_bridge.dart';

/// MCP + LLM Integration - AI Agents with External Tools
///
/// This example demonstrates the powerful combination of llm_dart and MCP:
/// - LLMs can discover and use tools from MCP servers
/// - Seamless integration between AI reasoning and external capabilities
/// - Real-world tool execution through standardized protocols
///
/// Architecture:
/// LLM (OpenAI/etc) ↔ llm_dart ↔ MCP Bridge ↔ MCP Server ↔ External Tools
///
/// Before running:
/// export OPENAI_API_KEY="your-key-here"
/// dart run new_example/07_mcp_integration/mcp_with_llm.dart
void main() async {
  print('MCP + LLM Integration - AI Agents with External Tools\n');

  // Get API key
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';
  if (apiKey == 'sk-TESTKEY') {
    print(
        '⚠️  Warning: Using test API key. Set OPENAI_API_KEY for real usage.\n');
  }

  await demonstrateBasicIntegration(apiKey);
  await demonstrateAdvancedWorkflow(apiKey);
  await demonstrateErrorHandling(apiKey);
  await demonstrateMultiStepReasoning(apiKey);

  print('\n✅ MCP + LLM integration examples completed!');
  print('🚀 You can now build AI agents that use external tools through MCP!');
}

/// Demonstrate basic MCP + LLM integration
Future<void> demonstrateBasicIntegration(String apiKey) async {
  print('🔗 Basic MCP + LLM Integration:\n');

  try {
    // Create LLM provider
    final llmProvider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.7)
        .build();

    // Create MCP bridge (simulated for demo)
    final mcpBridge = await _createMockMcpBridge();

    // Get MCP tools as llm_dart tools
    final mcpTools = mcpBridge.convertToLlmDartTools();

    print('   🔧 Available MCP Tools:');
    for (final tool in mcpTools) {
      print('      • ${tool.function.name}: ${tool.function.description}');
    }

    // Create enhanced tools that bridge to MCP
    final enhancedTools = _createEnhancedTools(mcpBridge, mcpTools);

    // Test with a simple calculation request
    final messages = [
      ChatMessage.user('Calculate 15 * 23 + 7 using the available tools.')
    ];

    print('\n   💬 User: Calculate 15 * 23 + 7 using the available tools.');
    print('   🤖 LLM: Analyzing request and selecting appropriate tools...');

    final response = await llmProvider.chatWithTools(messages, enhancedTools);

    if (response.toolCalls != null && response.toolCalls!.isNotEmpty) {
      print('   🔧 Tool calls made:');
      for (final toolCall in response.toolCalls!) {
        print('      Tool: ${toolCall.function.name}');
        print('      Args: ${toolCall.function.arguments}');

        // Execute the MCP tool
        final result = await mcpBridge.executeMcpTool(
          toolCall.function.name,
          toolCall.function.arguments,
        );
        print('      Result: $result');
      }
    }

    print('   📝 LLM Response: ${response.text}');
    print('   ✅ Basic integration successful\n');

    await mcpBridge.close();
  } catch (e) {
    print('   ❌ Basic integration failed: $e\n');
  }
}

/// Demonstrate advanced workflow with multiple tools
Future<void> demonstrateAdvancedWorkflow(String apiKey) async {
  print('⚡ Advanced Multi-Tool Workflow:\n');

  try {
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.3)
        .build();

    final mcpBridge = await _createMockMcpBridge();
    final mcpTools = mcpBridge.convertToLlmDartTools();
    final enhancedTools = _createEnhancedTools(mcpBridge, mcpTools);

    // Complex multi-step request
    final messages = [
      ChatMessage.system(
          'You are a helpful assistant that can use various tools. '
          'When asked to perform tasks, use the appropriate tools and explain your process.'),
      ChatMessage.user(
          'I need you to: 1) Get the current time, 2) Generate 3 random numbers between 1 and 100, '
          '3) Calculate the average of those numbers, and 4) Tell me what the weather is like in Tokyo.'),
    ];

    print('   💬 User: Multi-step request with 4 different operations');
    print('   🤖 LLM: Planning multi-tool workflow...');

    // This would typically involve multiple rounds of tool calls
    final response = await provider.chatWithTools(messages, enhancedTools);

    print('   📋 Workflow execution:');
    if (response.toolCalls != null) {
      for (int i = 0; i < response.toolCalls!.length; i++) {
        final toolCall = response.toolCalls![i];
        print('      Step ${i + 1}: ${toolCall.function.name}');

        final result = await mcpBridge.executeMcpTool(
          toolCall.function.name,
          toolCall.function.arguments,
        );
        print('         Result: $result');
      }
    }

    print('   📝 Final Response: ${response.text}');
    print('   ✅ Advanced workflow successful\n');

    await mcpBridge.close();
  } catch (e) {
    print('   ❌ Advanced workflow failed: $e\n');
  }
}

/// Demonstrate error handling in MCP integration
Future<void> demonstrateErrorHandling(String apiKey) async {
  print('🛡️ Error Handling:\n');

  try {
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.5)
        .build();

    final mcpBridge = await _createMockMcpBridge();
    final mcpTools = mcpBridge.convertToLlmDartTools();
    final enhancedTools = _createEnhancedTools(mcpBridge, mcpTools);

    // Request that will cause an error
    final messages = [
      ChatMessage.user(
          'Calculate the square root of -1 using the calculator tool.')
    ];

    print('   💬 User: Calculate the square root of -1 (will cause error)');
    print('   🤖 LLM: Attempting calculation...');

    final response = await provider.chatWithTools(messages, enhancedTools);

    if (response.toolCalls != null) {
      for (final toolCall in response.toolCalls!) {
        try {
          final result = await mcpBridge.executeMcpTool(
            toolCall.function.name,
            toolCall.function.arguments,
          );
          print('   ✅ Tool result: $result');
        } catch (e) {
          print('   ❌ Tool error: $e');
          print(
              '   🔄 LLM can handle this error and provide alternative solutions');
        }
      }
    }

    print('   📝 LLM Response: ${response.text}');
    print('   ✅ Error handling demonstrated\n');

    await mcpBridge.close();
  } catch (e) {
    print('   ❌ Error handling demo failed: $e\n');
  }
}

/// Demonstrate multi-step reasoning with tool results
Future<void> demonstrateMultiStepReasoning(String apiKey) async {
  print('🧠 Multi-Step Reasoning:\n');

  try {
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.2)
        .build();

    final mcpBridge = await _createMockMcpBridge();
    final mcpTools = mcpBridge.convertToLlmDartTools();
    final enhancedTools = _createEnhancedTools(mcpBridge, mcpTools);

    // Start conversation
    final conversation = <ChatMessage>[
      ChatMessage.system(
          'You are a data analyst assistant. Use tools to gather information and provide insights.'),
      ChatMessage.user(
          'I want to analyze some data. First, generate 5 random numbers between 10 and 50, '
          'then calculate their sum and average. Finally, tell me if the average is above 30.'),
    ];

    print('   💬 User: Data analysis request with multiple steps');
    print('   🤖 LLM: Breaking down the analysis...');

    // First tool call - generate random numbers
    var response = await provider.chatWithTools(conversation, enhancedTools);

    if (response.toolCalls != null) {
      for (final toolCall in response.toolCalls!) {
        final result = await mcpBridge.executeMcpTool(
          toolCall.function.name,
          toolCall.function.arguments,
        );

        // Add tool result to conversation
        conversation.add(ChatMessage.assistant(response.text ?? ''));
        conversation.add(ChatMessage.user(
            'Tool result: $result. Please continue with the analysis.'));

        print('   🔧 Step: ${toolCall.function.name} → $result');
      }
    }

    // Continue the conversation for further analysis
    response = await provider.chatWithTools(conversation, enhancedTools);

    print('   📊 Analysis Result: ${response.text}');
    print('   ✅ Multi-step reasoning completed\n');

    await mcpBridge.close();
  } catch (e) {
    print('   ❌ Multi-step reasoning failed: $e\n');
  }
}

/// Create enhanced tools that bridge to MCP
List<Tool> _createEnhancedTools(McpToolBridge bridge, List<Tool> mcpTools) {
  // For demo purposes, we'll return the MCP tools as-is
  // In a real implementation, you might enhance them with additional metadata
  return mcpTools;
}

/// Create a mock MCP bridge for demonstration
Future<McpToolBridge> _createMockMcpBridge() async {
  // Create a mock MCP client
  final client = Client(
    Implementation(name: "demo-client", version: "1.0.0"),
  );

  final bridge = McpToolBridge(client);
  await bridge.initialize();
  return bridge;
}

/// 🎯 Key Integration Concepts Summary:
///
/// MCP + LLM Benefits:
/// - LLMs can use external tools through standardized protocol
/// - Tools are discoverable and self-describing
/// - Seamless integration with existing MCP ecosystem
/// - Separation of concerns: LLM reasoning + MCP execution
///
/// Architecture Layers:
/// 1. LLM Provider (OpenAI, Anthropic, etc.)
/// 2. llm_dart Tool System
/// 3. MCP Bridge (conversion layer)
/// 4. MCP Client/Server Protocol
/// 5. External Tools and Services
///
/// Best Practices:
/// 1. Handle MCP connection errors gracefully
/// 2. Validate tool parameters before MCP calls
/// 3. Provide meaningful error messages to LLMs
/// 4. Cache tool definitions for performance
/// 5. Monitor tool usage and performance
/// 6. Implement proper timeouts and retries
///
/// Use Cases:
/// - File system operations
/// - Database queries
/// - API integrations
/// - System administration
/// - Data analysis workflows
/// - Custom business logic
///
/// Next Steps:
/// - Explore real MCP servers
/// - Build custom MCP tools for your domain
/// - Integrate with production LLM applications
/// - Contribute to the MCP ecosystem
