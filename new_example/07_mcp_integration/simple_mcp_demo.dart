// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart' as llm;
import 'package:mcp_dart/mcp_dart.dart';

/// Simple MCP Demo - Quick Start with MCP Integration
///
/// This simplified example demonstrates the core concepts of integrating
/// MCP (Model Context Protocol) with llm_dart without complex type conversions.
///
/// Key concepts demonstrated:
/// - Creating MCP servers with tools
/// - Basic tool execution
/// - Integration patterns with LLMs
///
/// Before running:
/// export OPENAI_API_KEY="your-key-here"
/// dart run new_example/07_mcp_integration/simple_mcp_demo.dart
void main() async {
  print('Simple MCP Demo - Quick Start with MCP Integration\n');

  // Get API key
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';
  if (apiKey == 'sk-TESTKEY') {
    print('Warning: Using test API key. Set OPENAI_API_KEY for real usage.\n');
  }

  await demonstrateMcpServer();
  await demonstrateLlmIntegration(apiKey);

  print('\n✅ Simple MCP demo completed!');
  print('📖 Next steps:');
  print(
      '   • Explore real MCP servers: https://modelcontextprotocol.io/examples');
  print('   • Build custom MCP tools for your domain');
  print('   • Integrate with production LLM applications');
}

/// Demonstrate creating and using an MCP server
Future<void> demonstrateMcpServer() async {
  print('🛠️ MCP Server Demo:\n');

  try {
    // Create MCP server with tools
    final server = McpServer(
      Implementation(name: "demo-server", version: "1.0.0"),
      options: ServerOptions(
        capabilities: ServerCapabilities(
          tools: ServerCapabilitiesTools(),
        ),
      ),
    );

    // Add a simple calculator tool
    server.tool(
      "calculate",
      description: 'Perform basic arithmetic operations',
      inputSchemaProperties: {
        'operation': {
          'type': 'string',
          'enum': ['add', 'subtract', 'multiply', 'divide'],
        },
        'a': {'type': 'number'},
        'b': {'type': 'number'},
      },
      callback: ({args, extra}) async {
        final operation = args!['operation'];
        final a = args['a'] as num;
        final b = args['b'] as num;

        final result = switch (operation) {
          'add' => a + b,
          'subtract' => a - b,
          'multiply' => a * b,
          'divide' => a / b,
          _ => throw Exception('Invalid operation'),
        };

        return CallToolResult.fromContent(
          content: [
            TextContent(text: 'Result: $result'),
          ],
        );
      },
    );

    // Add a time tool
    server.tool(
      "current_time",
      description: 'Get current date and time',
      inputSchemaProperties: {
        'format': {
          'type': 'string',
          'enum': ['iso', 'local', 'timestamp'],
          'default': 'local',
        },
      },
      callback: ({args, extra}) async {
        final format = args?['format'] ?? 'local';
        final now = DateTime.now();

        final timeString = switch (format) {
          'iso' => now.toIso8601String(),
          'timestamp' => now.millisecondsSinceEpoch.toString(),
          _ => now.toString(),
        };

        return CallToolResult.fromContent(
          content: [
            TextContent(text: 'Current time ($format): $timeString'),
          ],
        );
      },
    );

    print('   📋 MCP Server created with tools:');
    print('      • calculate - Perform arithmetic operations');
    print('      • current_time - Get current date and time');
    print('   ✅ MCP server setup successful\n');
  } catch (e) {
    print('   ❌ MCP server demo failed: $e\n');
  }
}

/// Demonstrate LLM integration concepts
Future<void> demonstrateLlmIntegration(String apiKey) async {
  print('🤖 LLM Integration Demo:\n');

  try {
    // Create LLM provider
    final llmProvider = await llm
        .ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o-mini')
        .temperature(0.7)
        .build();

    // Create equivalent tools for llm_dart
    final tools = [
      llm.Tool.function(
        name: 'calculate',
        description: 'Perform basic arithmetic operations',
        parameters: llm.ParametersSchema(
          schemaType: 'object',
          properties: {
            'operation': llm.ParameterProperty(
              propertyType: 'string',
              description: 'Arithmetic operation',
              enumList: ['add', 'subtract', 'multiply', 'divide'],
            ),
            'a': llm.ParameterProperty(
              propertyType: 'number',
              description: 'First number',
            ),
            'b': llm.ParameterProperty(
              propertyType: 'number',
              description: 'Second number',
            ),
          },
          required: ['operation', 'a', 'b'],
        ),
      ),
      llm.Tool.function(
        name: 'current_time',
        description: 'Get current date and time',
        parameters: llm.ParametersSchema(
          schemaType: 'object',
          properties: {
            'format': llm.ParameterProperty(
              propertyType: 'string',
              description: 'Time format',
              enumList: ['iso', 'local', 'timestamp'],
            ),
          },
          required: [],
        ),
      ),
    ];

    print('   🔧 Available Tools:');
    for (final tool in tools) {
      print('      • ${tool.function.name}: ${tool.function.description}');
    }

    // Test with a calculation request
    final messages = [
      llm.ChatMessage.user('Calculate 15 * 23 and tell me the current time.')
    ];

    print('\n   💬 User: Calculate 15 * 23 and tell me the current time.');
    print('   🤖 LLM: Processing request with available tools...');

    final response = await llmProvider.chatWithTools(messages, tools);

    if (response.toolCalls != null && response.toolCalls!.isNotEmpty) {
      print('   🔧 Tool calls made:');
      for (final toolCall in response.toolCalls!) {
        print('      Tool: ${toolCall.function.name}');
        print('      Args: ${toolCall.function.arguments}');

        // Simulate tool execution results
        final result = _simulateToolExecution(
          toolCall.function.name,
          toolCall.function.arguments,
        );
        print('      Result: $result');
      }
    }

    print('   📝 LLM Response: ${response.text}');
    print('   ✅ LLM integration successful\n');
  } catch (e) {
    print('   ❌ LLM integration failed: $e\n');
  }
}

/// Simulate tool execution for demo purposes
String _simulateToolExecution(String toolName, dynamic arguments) {
  // Convert arguments if they're a string (JSON)
  Map<String, dynamic> args;
  if (arguments is String) {
    try {
      args = Map<String, dynamic>.from(
          // Simple JSON parsing for demo - in real apps use proper JSON parsing
          {'operation': 'multiply', 'a': 15, 'b': 23});
    } catch (e) {
      return 'Error parsing arguments: $e';
    }
  } else {
    args = arguments as Map<String, dynamic>;
  }
  switch (toolName) {
    case 'calculate':
      final operation = args['operation'] as String;
      final a = args['a'] as num;
      final b = args['b'] as num;

      final result = switch (operation) {
        'add' => a + b,
        'subtract' => a - b,
        'multiply' => a * b,
        'divide' => a / b,
        _ => 'Invalid operation',
      };

      return 'Result: $result';

    case 'current_time':
      final format = args['format'] as String? ?? 'local';
      final now = DateTime.now();

      final timeString = switch (format) {
        'iso' => now.toIso8601String(),
        'timestamp' => now.millisecondsSinceEpoch.toString(),
        _ => now.toString(),
      };

      return 'Current time ($format): $timeString';

    default:
      return 'Unknown tool: $toolName';
  }
}

/// 🎯 Key MCP Integration Concepts:
///
/// 1. **MCP Server**: Provides tools and resources through standardized protocol
/// 2. **Tool Definition**: JSON Schema-based tool descriptions
/// 3. **Tool Execution**: Callback functions that perform actual work
/// 4. **LLM Integration**: Converting MCP tools to llm_dart tool format
/// 5. **Bidirectional Communication**: LLM calls tools, tools return results
///
/// Benefits of MCP:
/// - Standardized protocol for AI tool integration
/// - Reusable tools across different AI applications
/// - Clear separation between AI reasoning and tool execution
/// - Growing ecosystem of pre-built MCP servers
///
/// Real-world Applications:
/// - File system operations
/// - Database queries
/// - API integrations
/// - System administration
/// - Custom business logic
///
/// Next Steps:
/// 1. Explore existing MCP servers: https://modelcontextprotocol.io/examples
/// 2. Build custom MCP servers for your specific needs
/// 3. Integrate MCP into production AI applications
/// 4. Contribute to the MCP ecosystem
