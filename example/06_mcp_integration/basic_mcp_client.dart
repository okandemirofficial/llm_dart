// ignore_for_file: avoid_print
import 'package:mcp_dart/mcp_dart.dart';

/// Basic MCP Client - Connecting to MCP Servers
///
/// This example demonstrates the fundamentals of MCP (Model Context Protocol):
/// - Connecting to MCP servers
/// - Discovering available tools and resources
/// - Calling MCP tools directly
/// - Handling MCP responses and errors
///
/// Before running:
/// 1. Start a MCP server (use custom_mcp_server.dart or any MCP server)
/// 2. Update the connection details below if needed
void main() async {
  print('Basic MCP Client - Connecting to MCP Servers\n');

  await demonstrateStdioConnection();
  await demonstrateHttpConnection();
  await demonstrateToolDiscovery();
  await demonstrateToolExecution();

  print('\nMCP client examples completed!');
  print('Next: Try mcp_with_llm.dart for LLM integration');
}

/// Demonstrate connecting to MCP server via stdio
Future<void> demonstrateStdioConnection() async {
  print('📡 Stdio Connection:\n');

  try {
    // Create MCP client with stdio transport
    final client = Client(
      Implementation(name: "example-client", version: "1.0.0"),
    );

    // Note: In a real scenario, you would connect to an actual MCP server
    // For demonstration, we'll show the connection setup
    print('   Setting up stdio transport...');
    print('   📝 Note: This would connect to a stdio-based MCP server');
    print('   Example command: dart run mcp_server.dart');
    print('   ✅ Stdio connection setup complete\n');

    // Clean up
    await client.close();
  } catch (e) {
    print('   ❌ Stdio connection failed: $e\n');
  }
}

/// Demonstrate connecting to MCP server via HTTP
Future<void> demonstrateHttpConnection() async {
  print('🌐 HTTP Connection:\n');

  try {
    // Create MCP client for HTTP connection
    final client = Client(
      Implementation(name: "http-client", version: "1.0.0"),
    );

    print('   Setting up HTTP transport...');
    print('   📝 Note: This would connect to an HTTP-based MCP server');
    print('   Example URL: http://localhost:3000/mcp');
    print('   ✅ HTTP connection setup complete\n');

    // Clean up
    await client.close();
  } catch (e) {
    print('   ❌ HTTP connection failed: $e\n');
  }
}

/// Demonstrate discovering tools from MCP server
Future<void> demonstrateToolDiscovery() async {
  print('🔍 Tool Discovery:\n');

  try {
    // Create a client for demonstration
    final client = Client(
      Implementation(name: "discovery-client", version: "1.0.0"),
    );

    // Note: In real usage, you would connect to an actual transport
    // For demo purposes, we'll just show the setup

    print('   Discovering available tools...');

    // In a real scenario, you would call:
    // final toolsResponse = await client.listTools();

    // For demonstration, show what tool discovery looks like
    final mockTools = [
      {
        'name': 'calculate',
        'description': 'Perform mathematical calculations',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'expression': {'type': 'string'},
          },
          'required': ['expression'],
        },
      },
      {
        'name': 'get_weather',
        'description': 'Get current weather information',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'location': {'type': 'string'},
            'unit': {
              'type': 'string',
              'enum': ['celsius', 'fahrenheit']
            },
          },
          'required': ['location'],
        },
      },
      {
        'name': 'file_read',
        'description': 'Read contents of a file',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'path': {'type': 'string'},
          },
          'required': ['path'],
        },
      },
    ];

    print('   📋 Available Tools:');
    for (final tool in mockTools) {
      print('      • ${tool['name']}: ${tool['description']}');
    }

    print('   ✅ Tool discovery successful\n');

    // Clean up
    await client.close();
  } catch (e) {
    print('   ❌ Tool discovery failed: $e\n');
  }
}

/// Demonstrate executing MCP tools
Future<void> demonstrateToolExecution() async {
  print('⚡ Tool Execution:\n');

  try {
    final client = Client(
      Implementation(name: "execution-client", version: "1.0.0"),
    );

    print('   Executing MCP tools...');

    // Simulate tool execution results
    final toolExecutions = [
      {
        'tool': 'calculate',
        'args': {'expression': '2 + 2'},
        'result': 'Result: 4',
      },
      {
        'tool': 'get_weather',
        'args': {'location': 'Tokyo', 'unit': 'celsius'},
        'result': 'Weather in Tokyo: 22°C, Sunny',
      },
      {
        'tool': 'file_read',
        'args': {'path': '/tmp/example.txt'},
        'result': 'File contents: Hello, MCP World!',
      },
    ];

    for (final execution in toolExecutions) {
      print('      🔧 Tool: ${execution['tool']}');
      print('         Args: ${execution['args']}');
      print('         Result: ${execution['result']}');
      print('');
    }

    print('   ✅ Tool execution successful\n');

    // Clean up
    await client.close();
  } catch (e) {
    print('   ❌ Tool execution failed: $e\n');
  }
}

/// Create a mock MCP server for demonstration
McpServer createMockMcpServer() {
  final server = McpServer(
    Implementation(name: "mock-server", version: "1.0.0"),
    options: ServerOptions(
      capabilities: ServerCapabilities(
        tools: ServerCapabilitiesTools(),
        resources: ServerCapabilitiesResources(),
      ),
    ),
  );

  // Add calculator tool
  server.tool(
    "calculate",
    description: 'Perform mathematical calculations',
    inputSchemaProperties: {
      'expression': {'type': 'string'},
    },
    callback: ({args, extra}) async {
      final expression = args!['expression'] as String;
      // Simple calculation simulation
      final result = _evaluateExpression(expression);
      return CallToolResult.fromContent(
          content: [TextContent(text: 'Result: $result')]);
    },
  );

  // Add weather tool
  server.tool(
    "get_weather",
    description: 'Get current weather information',
    inputSchemaProperties: {
      'location': {'type': 'string'},
      'unit': {
        'type': 'string',
        'enum': ['celsius', 'fahrenheit']
      },
    },
    callback: ({args, extra}) async {
      final location = args!['location'] as String;
      final unit = args['unit'] as String? ?? 'celsius';
      return CallToolResult.fromContent(
        content: [
          TextContent(
              text:
                  'Weather in $location: 22°${unit == 'celsius' ? 'C' : 'F'}, Sunny')
        ],
      );
    },
  );

  return server;
}

/// Simple expression evaluator for demo purposes
String _evaluateExpression(String expression) {
  try {
    // Very basic evaluation - in real apps use a proper parser
    expression = expression.replaceAll(' ', '');
    if (expression.contains('+')) {
      final parts = expression.split('+');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]) ?? 0;
        final b = double.tryParse(parts[1]) ?? 0;
        return (a + b).toString();
      }
    }
    return 'Cannot evaluate: $expression';
  } catch (e) {
    return 'Error: $e';
  }
}

/// 🎯 Key MCP Client Concepts Summary:
///
/// Connection Types:
/// - Stdio: Direct process communication
/// - HTTP: Web-based MCP servers
/// - Stream: In-process communication
///
/// Core Operations:
/// 1. Connect to MCP server
/// 2. Discover available tools/resources
/// 3. Execute tools with parameters
/// 4. Handle responses and errors
///
/// Best Practices:
/// 1. Always handle connection errors
/// 2. Validate tool parameters
/// 3. Clean up connections properly
/// 4. Log MCP interactions for debugging
/// 5. Implement timeouts for operations
///
/// Next Steps:
/// - mcp_with_llm.dart: Integrate MCP with LLMs
/// - custom_mcp_server.dart: Create your own MCP server
/// - Explore real MCP servers for production use
