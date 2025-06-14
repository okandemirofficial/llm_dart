# MCP Integration Examples

This directory demonstrates how to integrate the Model Context Protocol (MCP) with llm_dart to enable LLMs to interact with external tools and services through standardized protocols.

## What is MCP?

Model Context Protocol (MCP) is an open protocol that standardizes how applications provide context to LLMs. Think of MCP like a USB-C port for AI applications - it provides a standardized way to connect AI models to different data sources and tools.

## Examples Overview

### Files in this directory:

- **`mcp_concept_demo.dart`** - **START HERE** - Core MCP concepts and integration patterns
- **`basic_mcp_client.dart`** - Basic MCP client that connects to MCP servers
- **`simple_mcp_demo.dart`** - Simplified working example with MCP + LLM integration
- **`mcp_with_llm.dart`** - Advanced integration example showing how LLMs can use MCP tools
- **`custom_mcp_server_stdio.dart`** - Simple MCP server implementation for testing (stdio)
- **`custom_mcp_server_streamable_http.dart`** - **NEW** - Streamable HTTP MCP server with resumability
- **`test_streamable_http_client.dart`** - **NEW** - Test client for streamable HTTP server
- **`mcp_tool_bridge.dart`** - Bridge that converts MCP tools to llm_dart tools

## Prerequisites

Before running these examples, you need:

1. **Install dependencies**:
   ```bash
   dart pub get
   ```

2. **MCP Server** (choose one):
   - Use the included `custom_mcp_server_stdio.dart`
   - Install an existing MCP server (e.g., filesystem, database, API servers)
   - Use online MCP demo servers

## 🧪 Detailed Testing Guide

### 🚀 Quick Test (Recommended)

**One-command test all examples:**
```bash
dart run example/06_mcp_integration/test_all_examples.dart
```

**Expected Output:**
```
🧪 Testing All MCP Examples - Automated Test Suite

🔍 Environment Check:
   ✅ Found pubspec.yaml - in correct directory
   ✅ mcp_dart dependency found
   ✅ OpenAI API key found

📋 Running Tests:

🔧 Testing: MCP Concept Demo
   Description: Tests core MCP concepts and educational content
   File: mcp_concept_demo.dart
   ✅ PASSED - Exit code: 0

🔧 Testing: Basic MCP Client
   Description: Tests MCP client connection patterns
   File: basic_mcp_client.dart
   ✅ PASSED - Exit code: 0

🔧 Testing: Simple MCP + LLM Demo
   Description: Tests basic MCP + LLM integration
   File: simple_mcp_demo.dart
   ✅ PASSED - Exit code: 0

🔧 Testing: Custom MCP Server
   Description: Tests custom MCP server startup
   File: custom_mcp_server_stdio.dart
   ✅ PASSED - Server started successfully
   ✅ PASSED - Server stopped cleanly

📊 Test Results Summary:
📈 Overall: 4/4 tests passed

   ✅ PASS  Concept Demo
   ✅ PASS  Basic Client
   ✅ PASS  Simple Demo
   ✅ PASS  Custom Server

🎉 Excellent! All tests passed.
✅ Your MCP integration is working perfectly!
```

**Duration:** ~30 seconds
**Requirements:** None (works with or without API keys)

---

### Step 1: Understanding MCP Concepts (Recommended Start)

**Command:**
```bash
dart run example/06_mcp_integration/mcp_concept_demo.dart
```

**What it does:**
- Explains MCP fundamentals with visual diagrams
- Shows tool definition formats
- Demonstrates integration patterns
- Provides real-world examples

**Expected Output:**
```
🎯 MCP Concept Demo - Understanding Model Context Protocol

📚 Core MCP Concepts:
   🔌 What is MCP?
      Model Context Protocol (MCP) is like USB-C for AI applications.
      It provides a standardized way to connect LLMs to external tools and data.

   🏗️ MCP Architecture:
      ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
      │ LLM Client  │◄──►│ MCP Bridge  │◄──►│ MCP Server  │
      │ (llm_dart)  │    │ (Converter) │    │ (Tools)     │
      └─────────────┘    └─────────────┘    └─────────────┘
...
✅ MCP concept demo completed!
🚀 Ready to build MCP-powered AI applications!
```

**Duration:** ~30 seconds
**Requirements:** None (no API keys needed)

---

### Step 2: Basic MCP Client Operations

**Command:**
```bash
dart run example/06_mcp_integration/basic_mcp_client.dart
```

**What it does:**
- Demonstrates MCP client connection patterns
- Shows tool discovery simulation
- Explains different transport types (stdio, HTTP)

**Expected Output:**
```
🔗 Basic MCP Client - Connecting to MCP Servers

📡 Stdio Connection:
   Setting up stdio transport...
   📝 Note: This would connect to a stdio-based MCP server
   Example command: dart run mcp_server.dart
   ✅ Stdio connection setup complete

🌐 HTTP Connection:
   Setting up HTTP transport...
   📝 Note: This would connect to an HTTP-based MCP server
   Example URL: http://localhost:3000/mcp
   ✅ HTTP connection setup complete

🔍 Tool Discovery:
   Discovering available tools...
   📋 Available Tools:
      • calculate: Perform mathematical calculations
      • get_weather: Get current weather information
      • file_read: Read contents of a file
   ✅ Tool discovery successful

⚡ Tool Execution:
   Executing MCP tools...
      🔧 Tool: calculate
         Args: {expression: 2 + 2}
         Result: Result: 4
      🔧 Tool: get_weather
         Args: {location: Tokyo, unit: celsius}
         Result: Weather in Tokyo: 22°C, Sunny
   ✅ Tool execution successful

✅ MCP client examples completed!
```

**Duration:** ~10 seconds
**Requirements:** None (simulated operations)

---

### Step 3: Simple MCP + LLM Integration

**Command:**
```bash
dart run example/06_mcp_integration/simple_mcp_demo.dart
```

**What it does:**
- Creates a working MCP server with tools
- Demonstrates LLM integration with tools
- Shows tool execution simulation

**Expected Output:**
```
🚀 Simple MCP Demo - Quick Start with MCP Integration

⚠️  Warning: Using test API key. Set OPENAI_API_KEY for real usage.

🛠️ MCP Server Demo:
   📋 MCP Server created with tools:
      • calculate - Perform arithmetic operations
      • current_time - Get current date and time
   ✅ MCP server setup successful

🤖 LLM Integration Demo:
   🔧 Available Tools:
      • calculate: Perform basic arithmetic operations
      • current_time: Get current date and time

   💬 User: Calculate 15 * 23 and tell me the current time.
   🤖 LLM: Processing request with available tools...
   🔧 Tool calls made:
      Tool: calculate
      Args: {operation: multiply, a: 15, b: 23}
      Result: Result: 345
   📝 LLM Response: [Simulated response about calculation and time]
   ✅ LLM integration successful

✅ Simple MCP demo completed!
```

**Duration:** ~15 seconds
**Requirements:** None (works with test API key)

---

### Step 4: Advanced Testing with Real API

**Setup:**
```bash
# For OpenAI
export OPENAI_API_KEY="sk-your-actual-key-here"

# For Anthropic
export ANTHROPIC_API_KEY="sk-ant-your-key-here"

# For Google
export GOOGLE_API_KEY="your-google-key-here"
```

**Command:**
```bash
dart run example/06_mcp_integration/simple_mcp_demo.dart
```

**Expected Output with Real API:**
```
🚀 Simple MCP Demo - Quick Start with MCP Integration

🛠️ MCP Server Demo:
   📋 MCP Server created with tools:
      • calculate - Perform arithmetic operations
      • current_time - Get current date and time
   ✅ MCP server setup successful

🤖 LLM Integration Demo:
   🔧 Available Tools:
      • calculate: Perform basic arithmetic operations
      • current_time: Get current date and time

   💬 User: Calculate 15 * 23 and tell me the current time.
   🤖 LLM: Processing request with available tools...
   🔧 Tool calls made:
      Tool: calculate
      Args: {operation: multiply, a: 15, b: 23}
      Result: Result: 345
      Tool: current_time
      Args: {format: local}
      Result: Current time (local): 2024-01-15 14:30:25.123456
   📝 LLM Response: I calculated 15 * 23 = 345. The current time is 2024-01-15 14:30:25.
   ✅ LLM integration successful

✅ Simple MCP demo completed!
```

**Duration:** ~20-30 seconds
**Requirements:** Valid API key, internet connection

---

### Step 5: Testing Custom MCP Server (Advanced)

**Terminal 1 - Start MCP Server:**
```bash
dart run example/06_mcp_integration/custom_mcp_server_stdio.dart
```

**Expected Server Output:**
```
🛠️ Custom MCP Server - Creating Your Own MCP Tools

📋 Registered Tools:
   • calculate - Perform mathematical calculations
   • random_number - Generate random numbers
   • current_time - Get current date and time
   • file_info - Get file information
   • system_info - Get system information
   • uuid_generate - Generate UUID

🚀 Starting MCP server on stdio...
💡 Connect with: dart run basic_mcp_client.dart
🔗 Or integrate with LLM: dart run mcp_with_llm.dart
⏹️  Press Ctrl+C to stop

[Server running and waiting for connections...]
```

**Terminal 2 - Test Client Connection:**
```bash
dart run example/06_mcp_integration/basic_mcp_client.dart
```

**What should happen:**
- Server shows connection activity
- Client discovers and tests tools
- Both terminals show successful communication

**Duration:** Server runs continuously, client test ~15 seconds
**Requirements:** Two terminal windows

---

### Step 6: Testing Streamable HTTP MCP Server (NEW)

**Terminal 1 - Start Streamable HTTP Server:**
```bash
dart run example/06_mcp_integration/custom_mcp_server_streamable_http.dart
```

**Expected Server Output:**
```
MCP Streamable HTTP Server listening on port 3000
📋 Available Tools:
   • greet - Simple greeting tool
   • calculate - Mathematical calculations
   • random_number - Generate random numbers
   • current_time - Get current date and time
   • multi-greet - Multiple greetings with notifications
   • start-notification-stream - Periodic notifications for testing

🌐 Connect to: http://localhost:3000/mcp
⏹️  Press Ctrl+C to stop

[Server running and waiting for HTTP connections...]
```

**Terminal 2 - Test HTTP Client:**
```bash
dart run example/06_mcp_integration/test_streamable_http_client.dart
```

**Expected Client Output:**
```
🧪 Testing Streamable HTTP MCP Server

1️⃣ Initializing MCP connection...
Info: Setting request handler for potentially custom method 'ping'. Ensure client capabilities match.
MCP Client Initialized. Server: simple-streamable-http-server 1.0.0, Protocol: 2025-03-26
   ✅ Session initialized: 56b3248a-8d95-4c8d-91ee-b42a2615dcf0

2️⃣ Listing available tools...
   📋 Available tools:
      • greet: A simple greeting tool
      • calculate: Perform simple mathematical calculations (supports addition only)
      • random_number: Generate random numbers within specified range
      • current_time: Get current date and time in various formats
      • multi-greet: A tool that sends different greetings with delays between them
      • start-notification-stream: Starts sending periodic notifications for testing resumability

3️⃣ Testing greeting tool...
   💬 Greeting result:
      Hello, Alice!

4️⃣ Testing calculation tool...
   🧮 Calculation result:
      Expression: 15 + 23 + 7
      Result: 45.0

5️⃣ Testing time tool...
   ⏰ Time result:
      Current time (iso): 2025-06-14T23:51:06.096688

6️⃣ Testing streaming notifications...
   🌊 Testing multi-greet tool with notifications...
   🌊 Streaming result:
      Good morning, Bob!
   📡 Note: Notifications are sent via SSE stream during execution

✅ All tests completed successfully!
🧹 Connection closed
```

**What this demonstrates:**
- **HTTP-based MCP transport** instead of stdio
- **Session management** with unique session IDs
- **Resumability support** with event store
- **Server-Sent Events (SSE)** for real-time notifications
- **RESTful endpoints** (POST for messages, GET for SSE, DELETE for cleanup)

**Duration:** Server runs continuously, client test ~10 seconds
**Requirements:** Two terminal windows, port 3000 available

> ✅ **Test Status**: Fully functional! The streamable HTTP MCP server and test client work perfectly together, demonstrating proper session management, tool execution, and streaming notifications.

#### 📋 About the Test Client (`test_streamable_http_client.dart`)

The test client demonstrates proper usage of the `mcp_dart` library's `StreamableHttpClientTransport` to connect to our HTTP-based MCP server. It showcases:

- **Proper MCP Client Setup**: Using `Client` and `StreamableHttpClientTransport` from mcp_dart
- **Session Management**: Automatic session ID handling and connection lifecycle
- **Tool Testing**: Systematic testing of all available server tools
- **Error Handling**: Graceful handling of connection and tool execution errors
- **Clean Shutdown**: Proper resource cleanup and connection termination

#### 🔧 How to Test Step by Step

**Step 1: Open Two Terminal Windows**

Make sure both terminals are in the project root directory:

```bash
cd /path/to/llm_dart
```

**Step 2: Start the Server (Terminal 1)**

```bash
# Terminal 1 - Start the HTTP MCP Server
dart run example/06_mcp_integration/custom_mcp_server_streamable_http.dart
```

Wait for the server to show:
```
MCP Streamable HTTP Server listening on port 3000
📋 Available Tools:
   • greet - Simple greeting tool
   • calculate - Mathematical calculations
   • random_number - Generate random numbers
   • current_time - Get current date and time
   • multi-greet - Multiple greetings with notifications
   • start-notification-stream - Periodic notifications for testing

🌐 Connect to: http://localhost:3000/mcp
⏹️  Press Ctrl+C to stop
```

**Step 3: Run the Test Client (Terminal 2)**

```bash
# Terminal 2 - Run the Test Client
dart run example/06_mcp_integration/test_streamable_http_client.dart
```

**Step 4: Observe the Output**

The client will automatically:
1. Connect to the server and establish a session
2. List all available tools
3. Test each tool with sample data
4. Display results and clean up the connection

**Step 5: Check Server Logs**

In Terminal 1, you should see server-side logs like:
```
Received MCP request
Session initialized with ID: abc123-def456-ghi789
Received MCP request
Received MCP request
...
```

**Step 6: Stop the Server**

Press `Ctrl+C` in Terminal 1 to stop the server.

#### 🧪 Testing Different Scenarios

You can modify the test client to test different scenarios:

1. **Test with different parameters:**
   ```dart
   // In testCalculationTool function, change the expression
   arguments: {'expression': 'sqrt(144) + sin(30)'},
   ```

2. **Test error handling:**
   ```dart
   // Try calling a non-existent tool
   arguments: {'expression': 'invalid_expression'},
   ```

3. **Test multiple clients:**
   Run the test client multiple times simultaneously to test concurrent connections.

---

## 🔍 Expected Behavior Summary

| Example | Duration | API Key Required | Internet Required | Expected Tools |
|---------|----------|------------------|-------------------|----------------|
| `mcp_concept_demo.dart` | 30s | ❌ No | ❌ No | Educational only |
| `basic_mcp_client.dart` | 10s | ❌ No | ❌ No | Simulated tools |
| `simple_mcp_demo.dart` | 15s | ⚠️ Optional | ⚠️ Optional | calculate, current_time |
| `custom_mcp_server_stdio.dart` | Continuous | ❌ No | ❌ No | 6 server tools (stdio) |
| `custom_mcp_server_streamable_http.dart` | Continuous | ❌ No | ❌ No | 6 server tools (HTTP) |
| `test_streamable_http_client.dart` | 10s | ❌ No | ❌ No | Automated HTTP client test |

## 🚨 Troubleshooting Guide

### Problem: "Package not found" error

**Error:**
```
Error: Could not resolve the package 'mcp_dart' in 'package:mcp_dart/mcp_dart.dart'.
```

**Solution:**
```bash
# Make sure you're in the project root
cd /path/to/llm_dart

# Install dependencies
dart pub get

# Verify mcp_dart is in pubspec.yaml dev_dependencies
grep -A 5 "dev_dependencies:" pubspec.yaml
```

---

### Problem: API key errors

**Error:**
```
Exception: API key not found or invalid
```

**Solutions:**

**Option 1 - Use test mode (recommended for learning):**
```bash
# Just run without setting API key - uses test mode
dart run example/06_mcp_integration/simple_mcp_demo.dart
```

**Option 2 - Set real API key:**
```bash
# For OpenAI
export OPENAI_API_KEY="sk-your-key-here"

# For Anthropic
export ANTHROPIC_API_KEY="sk-ant-your-key-here"

# Then run
dart run example/06_mcp_integration/simple_mcp_demo.dart
```

**Option 3 - Check API key format:**
```bash
# OpenAI keys start with "sk-"
echo $OPENAI_API_KEY | grep "^sk-"

# Anthropic keys start with "sk-ant-"
echo $ANTHROPIC_API_KEY | grep "^sk-ant-"
```

---

### Problem: "Type conflicts" or compilation errors

**Error:**
```
Error: The argument type 'X' can't be assigned to the parameter type 'Y'
```

**Solution:**
```bash
# Try the working examples first
dart run example/06_mcp_integration/mcp_concept_demo.dart
dart run example/06_mcp_integration/simple_mcp_demo.dart

# If advanced examples fail, this is expected - they're marked as "Partial" status
# Focus on the working examples for learning
```

---

### Problem: No tool calls made by LLM

**Symptoms:**
```
🤖 LLM: Processing request with available tools...
📝 LLM Response: I can help you with calculations...
# (No tool calls shown)
```

**Possible Causes & Solutions:**

1. **LLM didn't understand the request:**
   ```bash
   # Try more explicit requests
   "Use the calculate tool to compute 15 * 23"
   "Call the current_time tool to get the time"
   ```

2. **API key issues:**
   ```bash
   # Check if using test mode
   # Test mode may not support tool calling
   export OPENAI_API_KEY="your-real-key"
   ```

3. **Model doesn't support tools:**
   ```bash
   # Make sure using a tool-capable model
   # gpt-4o-mini, gpt-4, claude-3-sonnet all support tools
   ```

---

### Problem: Server connection issues

**Error:**
```
❌ MCP server connection failed: Connection refused
```

**Solutions:**

1. **Check if server is running:**
   ```bash
   # In another terminal, make sure server started successfully
   dart run example/06_mcp_integration/custom_mcp_server_stdio.dart
   ```

2. **Check for port conflicts:**
   ```bash
   # If using HTTP transport, check if port is available
   netstat -an | grep :3000
   ```

3. **Use working examples:**
   ```bash
   # Start with simulated examples that don't need real connections
   dart run example/06_mcp_integration/basic_mcp_client.dart
   ```

---

## 🎯 Success Indicators

### ✅ Everything Working Correctly

You should see:
- **Clear output formatting** with emojis and structure
- **No error messages** or stack traces
- **Tool calls being made** when using real API keys
- **Realistic tool results** (calculations, timestamps, etc.)
- **Educational explanations** in concept demo

### ⚠️ Partial Success (Still Learning Value)

You might see:
- **Simulated results** instead of real tool calls (this is normal for test mode)
- **"Warning: Using test API key"** messages (this is expected without real keys)
- **Some advanced examples not working** (focus on working ones)

### ❌ Something Wrong

Contact for help if you see:
- **Compilation errors** in basic examples
- **Package not found** errors after `dart pub get`
- **Complete failure** of all examples

---

## 🚀 Next Steps After Testing

### If Everything Works:
1. **Explore real MCP servers**: https://modelcontextprotocol.io/examples
2. **Build custom tools** for your specific use case
3. **Integrate into your app** using the patterns shown
4. **Join MCP community**: https://github.com/modelcontextprotocol

### If Some Issues:
1. **Focus on working examples** for learning
2. **Use test mode** for experimentation
3. **Check troubleshooting guide** above
4. **Start with simple use cases** before complex ones

### For Production Use:
1. **Get real API keys** for your chosen LLM provider
2. **Implement proper error handling** based on examples
3. **Add security validation** for tool inputs
4. **Monitor tool usage** and performance
5. **Cache tool definitions** for better performance

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   LLM Provider  │    │   llm_dart      │    │   MCP Client    │
│   (OpenAI, etc) │◄──►│   Tool System   │◄──►│   (mcp_dart)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
                                               ┌─────────────────┐
                                               │   MCP Server    │
                                               │   (Tools/Data)  │
                                               └─────────────────┘
```

## Key Concepts

### MCP Tools vs llm_dart Tools

- **MCP Tools**: Defined by MCP servers, follow MCP protocol
- **llm_dart Tools**: Native tool format used by llm_dart library
- **Bridge**: Converts between the two formats seamlessly

### Tool Discovery

1. Connect to MCP server
2. List available MCP tools
3. Convert to llm_dart tool format
4. Provide to LLM for function calling

### Tool Execution

1. LLM decides to call a tool
2. llm_dart receives tool call
3. Bridge forwards call to MCP server
4. MCP server executes and returns result
5. Result is passed back to LLM

## Use Cases

- **File Operations**: Read, write, search files through MCP filesystem servers
- **Database Access**: Query databases through MCP database servers
- **API Integration**: Call external APIs through MCP API servers
- **System Tools**: Execute system commands through MCP system servers
- **Custom Tools**: Create domain-specific tools with MCP servers

## Best Practices

1. **Error Handling**: Always handle MCP connection and tool execution errors
2. **Security**: Validate tool inputs and outputs
3. **Performance**: Cache MCP tool definitions when possible
4. **Monitoring**: Log MCP interactions for debugging
5. **Fallbacks**: Provide fallback behavior when MCP servers are unavailable

## Troubleshooting

### Common Issues

1. **Connection Failed**: Check if MCP server is running and accessible
2. **Tool Not Found**: Verify tool name matches MCP server's tool list
3. **Permission Denied**: Check MCP server permissions and authentication
4. **Timeout**: Increase timeout values for slow MCP operations

### Debug Mode

Enable debug logging:
```dart
import 'package:logging/logging.dart';

Logger.root.level = Level.ALL;
Logger.root.onRecord.listen((record) {
  print('${record.level.name}: ${record.time}: ${record.message}');
});
```

---

## 🌐 Streamable HTTP MCP Server Guide

The `custom_mcp_server_streamable_http.dart` implements an HTTP-based MCP server with streaming capabilities and session resumability, providing a modern alternative to the stdio-based approach.

### 🌟 Key Features

#### Comparison with stdio Version

| Feature | stdio Version | Streamable HTTP Version |
|---------|---------------|------------------------|
| Transport | stdin/stdout | HTTP + Server-Sent Events |
| Session Management | None | ✅ Session ID support |
| Resumability | None | ✅ Reconnection support |
| Concurrent Connections | Single | ✅ Multi-client support |
| Real-time Notifications | None | ✅ SSE streaming |
| Web Compatibility | None | ✅ Web application ready |

#### Core Capabilities

1. **Session Management**: Each client connection gets a unique session ID
2. **Event Storage**: Supports message replay and reconnection recovery
3. **Streaming Notifications**: Real-time push notifications via SSE
4. **RESTful API**: Standard HTTP endpoint design
5. **Concurrent Support**: Handle multiple clients simultaneously

### 🚀 Quick Start Guide

#### 1. Start the Server

```bash
dart run example/06_mcp_integration/custom_mcp_server_streamable_http.dart
```

The server will start at `http://localhost:3000/mcp`.

#### 2. Test with Client

In another terminal:

```bash
dart run example/06_mcp_integration/test_streamable_http_client.dart
```

#### 3. Quick Test Commands

For rapid testing, you can use these one-liner commands:

**Terminal 1 (Server):**
```bash
cd /path/to/llm_dart && dart run example/06_mcp_integration/custom_mcp_server_streamable_http.dart
```

**Terminal 2 (Client):**
```bash
cd /path/to/llm_dart && dart run example/06_mcp_integration/test_streamable_http_client.dart
```

The client will automatically connect, test all tools, and disconnect. Perfect for CI/CD or quick validation!

### 📡 API Endpoints

#### POST /mcp
- **Purpose**: Send MCP messages
- **Headers**:
  - `Content-Type: application/json`
  - `mcp-session-id: <session-id>` (after initialization)
- **Body**: JSON-RPC 2.0 message

#### GET /mcp
- **Purpose**: Establish SSE connection for notifications
- **Headers**:
  - `mcp-session-id: <session-id>`
  - `Last-Event-ID: <event-id>` (optional, for resumption)

#### DELETE /mcp
- **Purpose**: Terminate session
- **Headers**:
  - `mcp-session-id: <session-id>`

### 🔧 Available Tools

The server provides these tools:

1. **greet** - Simple greeting tool
2. **calculate** - Mathematical calculations
3. **random_number** - Random number generation
4. **current_time** - Get current time
5. **multi-greet** - Multiple greetings with notifications
6. **start-notification-stream** - Periodic notification stream

### 💡 Usage Examples

#### Initialize Connection

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "roots": {"listChanged": true},
      "sampling": {}
    },
    "clientInfo": {
      "name": "my-client",
      "version": "1.0.0"
    }
  }
}
```

#### Call a Tool

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/call",
  "params": {
    "name": "calculate",
    "arguments": {
      "expression": "15 * 23 + 7"
    }
  }
}
```

#### Streaming Notification Tool

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "multi-greet",
    "arguments": {
      "name": "Alice"
    }
  }
}

### 🔄 Recovery Mechanism

The server supports reconnection recovery:

1. Client disconnects
2. Server saves events to in-memory storage
3. Client reconnects with `Last-Event-ID` header
4. Server replays missed events

### 🛠️ Custom Development

#### Adding New Tools

```dart
server.tool(
  'my_custom_tool',
  description: 'My custom tool description',
  inputSchemaProperties: {
    'param1': {'type': 'string', 'description': 'Parameter 1'},
  },
  callback: ({args, extra}) async {
    // Tool logic here
    return CallToolResult.fromContent(
      content: [TextContent(text: 'Result')],
    );
  },
);
```

#### Sending Notifications

```dart
await extra?.sendNotification(JsonRpcLoggingMessageNotification(
  logParams: LoggingMessageNotificationParams(
    level: LoggingLevel.info,
    data: 'Custom notification message',
  )
));
```

### 🐛 Troubleshooting

#### Port Already in Use
If port 3000 is occupied, modify the port in `main()` function:

```dart
final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3001);
```

#### Session Lost
Check server logs for session initialization messages:

```
Session initialized with ID: abc123-def456-ghi789
```

#### Connection Issues
Ensure:
1. Server is running
2. Firewall allows port access
3. Client uses correct URL

### 🔧 Advanced Features

#### Event Store Implementation

The server uses an in-memory event store for resumability:

```dart
class InMemoryEventStore implements EventStore {
  final Map<String, List<({EventId id, JsonRpcMessage message})>> _events = {};

  @override
  Future<EventId> storeEvent(StreamId streamId, JsonRpcMessage message) async {
    // Store event for replay
  }

  @override
  Future<StreamId> replayEventsAfter(EventId lastEventId, {
    required Future<void> Function(EventId eventId, JsonRpcMessage message) send,
  }) async {
    // Replay events after specified ID
  }
}
```

#### Session Management

Each client gets a unique session ID:

```dart
transport = StreamableHTTPServerTransport(
  options: StreamableHTTPServerTransportOptions(
    sessionIdGenerator: () => generateUUID(),
    eventStore: eventStore,
    onsessioninitialized: (sessionId) {
      transports[sessionId] = transport!;
    },
  ),
);
```

## Next Steps

- Explore MCP server implementations: https://modelcontextprotocol.io/examples
- Read MCP specification: https://modelcontextprotocol.io/specification
- Join MCP community discussions: https://github.com/modelcontextprotocol
