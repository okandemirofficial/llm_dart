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
- **`custom_mcp_server.dart`** - Simple MCP server implementation for testing
- **`mcp_tool_bridge.dart`** - Bridge that converts MCP tools to llm_dart tools

## Prerequisites

Before running these examples, you need:

1. **Install dependencies**:
   ```bash
   dart pub get
   ```

2. **MCP Server** (choose one):
   - Use the included `custom_mcp_server.dart`
   - Install an existing MCP server (e.g., filesystem, database, API servers)
   - Use online MCP demo servers

## 🧪 Detailed Testing Guide

### 🚀 Quick Test (Recommended)

**One-command test all examples:**
```bash
dart run new_example/07_mcp_integration/test_all_examples.dart
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
   File: custom_mcp_server.dart
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
dart run new_example/07_mcp_integration/mcp_concept_demo.dart
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
dart run new_example/07_mcp_integration/basic_mcp_client.dart
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
dart run new_example/07_mcp_integration/simple_mcp_demo.dart
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
dart run new_example/07_mcp_integration/simple_mcp_demo.dart
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
dart run new_example/07_mcp_integration/custom_mcp_server.dart
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
dart run new_example/07_mcp_integration/basic_mcp_client.dart
```

**What should happen:**
- Server shows connection activity
- Client discovers and tests tools
- Both terminals show successful communication

**Duration:** Server runs continuously, client test ~15 seconds
**Requirements:** Two terminal windows

---

## 🔍 Expected Behavior Summary

| Example | Duration | API Key Required | Internet Required | Expected Tools |
|---------|----------|------------------|-------------------|----------------|
| `mcp_concept_demo.dart` | 30s | ❌ No | ❌ No | Educational only |
| `basic_mcp_client.dart` | 10s | ❌ No | ❌ No | Simulated tools |
| `simple_mcp_demo.dart` | 15s | ⚠️ Optional | ⚠️ Optional | calculate, current_time |
| `custom_mcp_server.dart` | Continuous | ❌ No | ❌ No | 6 server tools |

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
dart run new_example/07_mcp_integration/simple_mcp_demo.dart
```

**Option 2 - Set real API key:**
```bash
# For OpenAI
export OPENAI_API_KEY="sk-your-key-here"

# For Anthropic
export ANTHROPIC_API_KEY="sk-ant-your-key-here"

# Then run
dart run new_example/07_mcp_integration/simple_mcp_demo.dart
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
dart run new_example/07_mcp_integration/mcp_concept_demo.dart
dart run new_example/07_mcp_integration/simple_mcp_demo.dart

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
   dart run new_example/07_mcp_integration/custom_mcp_server.dart
   ```

2. **Check for port conflicts:**
   ```bash
   # If using HTTP transport, check if port is available
   netstat -an | grep :3000
   ```

3. **Use working examples:**
   ```bash
   # Start with simulated examples that don't need real connections
   dart run new_example/07_mcp_integration/basic_mcp_client.dart
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

## Next Steps

- Explore MCP server implementations: https://modelcontextprotocol.io/examples
- Read MCP specification: https://modelcontextprotocol.io/specification
- Join MCP community discussions: https://github.com/modelcontextprotocol
