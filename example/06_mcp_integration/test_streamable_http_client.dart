// ignore_for_file: avoid_print
import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';

/// Test client for the streamable HTTP MCP server using mcp_dart
///
/// This demonstrates how to connect to and interact with the
/// custom_mcp_server_streamable_http.dart server using the proper
/// mcp_dart Client and StreamableHttpClientTransport.
///
/// Usage:
/// 1. Start the server: dart run custom_mcp_server_streamable_http.dart
/// 2. Run this client: dart run test_streamable_http_client.dart
void main() async {
  print('🧪 Testing Streamable HTTP MCP Server\n');

  Client? client;
  StreamableHttpClientTransport? transport;
  final serverUrl = 'http://localhost:3000/mcp';

  try {
    // Step 1: Initialize MCP client and connection
    print('1️⃣ Initializing MCP connection...');

    client = Client(
      Implementation(name: 'test-client', version: '1.0.0'),
    );

    // Set up error handler
    client.onerror = (error) {
      print('Client error: $error');
    };

    // Create transport
    transport = StreamableHttpClientTransport(
      Uri.parse(serverUrl),
      opts: StreamableHttpClientTransportOptions(),
    );

    // Connect to server
    await client.connect(transport);
    final sessionId = transport.sessionId;
    print('   ✅ Session initialized: $sessionId\n');

    // Step 2: List available tools
    print('2️⃣ Listing available tools...');
    await listTools(client);
    print('');

    // Step 3: Test simple greeting tool
    print('3️⃣ Testing greeting tool...');
    await testGreetingTool(client);
    print('');

    // Step 4: Test math calculation
    print('4️⃣ Testing calculation tool...');
    await testCalculationTool(client);
    print('');

    // Step 5: Test time tool
    print('5️⃣ Testing time tool...');
    await testTimeTool(client);
    print('');

    // Step 6: Test streaming notifications (multi-greet)
    print('6️⃣ Testing streaming notifications...');
    await testStreamingTool(client);
    print('');

    print('✅ All tests completed successfully!');

  } catch (e) {
    print('❌ Test failed: $e');
  } finally {
    // Clean up
    if (transport != null) {
      try {
        await transport.close();
        print('🧹 Connection closed');
      } catch (e) {
        print('⚠️ Error closing connection: $e');
      }
    }

    // Explicitly exit the program
    exit(0);
  }
}

/// List available tools using mcp_dart Client
Future<void> listTools(Client client) async {
  try {
    final toolsResult = await client.listTools();

    print('   📋 Available tools:');
    if (toolsResult.tools.isEmpty) {
      print('      No tools available');
    } else {
      for (final tool in toolsResult.tools) {
        print('      • ${tool.name}: ${tool.description}');
      }
    }
  } catch (error) {
    throw Exception('Failed to list tools: $error');
  }
}

/// Test the greeting tool using mcp_dart Client
Future<void> testGreetingTool(Client client) async {
  try {
    final params = CallToolRequestParams(
      name: 'greet',
      arguments: {'name': 'Alice'},
    );

    final result = await client.callTool(params);

    print('   💬 Greeting result:');
    for (final item in result.content) {
      if (item is TextContent) {
        // Handle multi-line text with proper indentation
        final lines = item.text.split('\n');
        for (final line in lines) {
          print('      $line');
        }
      }
    }
  } catch (error) {
    throw Exception('Greeting tool error: $error');
  }
}

/// Test the calculation tool using mcp_dart Client
Future<void> testCalculationTool(Client client) async {
  try {
    final params = CallToolRequestParams(
      name: 'calculate',
      arguments: {'expression': '15 + 23 + 7'},
    );

    final result = await client.callTool(params);

    print('   🧮 Calculation result:');
    for (final item in result.content) {
      if (item is TextContent) {
        // Handle multi-line text with proper indentation
        final lines = item.text.split('\n');
        for (final line in lines) {
          print('      $line');
        }
      }
    }
  } catch (error) {
    throw Exception('Calculation tool error: $error');
  }
}

/// Test the time tool using mcp_dart Client
Future<void> testTimeTool(Client client) async {
  try {
    final params = CallToolRequestParams(
      name: 'current_time',
      arguments: {'format': 'iso'},
    );

    final result = await client.callTool(params);

    print('   ⏰ Time result:');
    for (final item in result.content) {
      if (item is TextContent) {
        // Handle multi-line text with proper indentation
        final lines = item.text.split('\n');
        for (final line in lines) {
          print('      $line');
        }
      }
    }
  } catch (error) {
    throw Exception('Time tool error: $error');
  }
}

/// Test streaming tool with notifications using mcp_dart Client
Future<void> testStreamingTool(Client client) async {
  try {
    print('   🌊 Testing multi-greet tool with notifications...');

    final params = CallToolRequestParams(
      name: 'multi-greet',
      arguments: {'name': 'Bob'},
    );

    final result = await client.callTool(params);

    print('   🌊 Streaming result:');
    for (final item in result.content) {
      if (item is TextContent) {
        print('      ${item.text}');
      }
    }
    print('   📡 Note: Notifications are sent via SSE stream during execution');
  } catch (error) {
    throw Exception('Streaming tool error: $error');
  }
}
