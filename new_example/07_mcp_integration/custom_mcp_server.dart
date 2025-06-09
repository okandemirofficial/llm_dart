// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';
import 'package:mcp_dart/mcp_dart.dart';

/// Custom MCP Server - Creating Your Own MCP Tools
///
/// This example demonstrates how to create a custom MCP server that provides
/// various tools and resources for LLMs to use. This server can be used
/// with any MCP-compatible client, including our llm_dart integration.
///
/// Features:
/// - Mathematical calculations
/// - Random number generation
/// - Simple file operations
/// - System information
/// - Time and date utilities
///
/// To run this server:
/// dart run new_example/07_mcp_integration/custom_mcp_server.dart
void main() async {
  print('Custom MCP Server - Creating Your Own MCP Tools\n');

  // Create MCP server with capabilities
  final server = McpServer(
    Implementation(name: "llm-dart-example-server", version: "1.0.0"),
    options: ServerOptions(
      capabilities: ServerCapabilities(
        tools: ServerCapabilitiesTools(),
        resources: ServerCapabilitiesResources(),
        prompts: ServerCapabilitiesPrompts(),
      ),
    ),
  );

  // Register all tools
  _registerMathTools(server);
  _registerUtilityTools(server);
  _registerFileTools(server);
  _registerSystemTools(server);

  print('📋 Registered Tools:');
  print('   • calculate - Perform mathematical calculations');
  print('   • random_number - Generate random numbers');
  print('   • current_time - Get current date and time');
  print('   • file_info - Get file information');
  print('   • system_info - Get system information');
  print('   • uuid_generate - Generate UUID');

  print('\n🚀 Starting MCP server on stdio...');
  print('💡 Connect with: dart run basic_mcp_client.dart');
  print('🔗 Or integrate with LLM: dart run mcp_with_llm.dart');
  print('⏹️  Press Ctrl+C to stop\n');

  try {
    // Connect using stdio transport
    await server.connect(StdioServerTransport());
  } catch (e) {
    print('❌ Server error: $e');
    exit(1);
  }
}

/// Register mathematical calculation tools
void _registerMathTools(McpServer server) {
  // Basic calculator
  server.tool(
    "calculate",
    description:
        'Perform mathematical calculations (supports +, -, *, /, ^, sqrt, sin, cos, tan)',
    inputSchemaProperties: {
      'expression': {
        'type': 'string',
        'description':
            'Mathematical expression to evaluate (e.g., "2 + 3 * 4", "sqrt(16)", "sin(30)")',
      },
    },
    callback: ({args, extra}) async {
      try {
        final expression = args!['expression'] as String;
        final result = _evaluateMathExpression(expression);
        return CallToolResult.fromContent(
          content: [
            TextContent(text: 'Expression: $expression\nResult: $result'),
          ],
        );
      } catch (e) {
        return CallToolResult.fromContent(
          isError: true,
          content: [TextContent(text: 'Math error: $e')],
        );
      }
    },
  );

  // Random number generator
  server.tool(
    "random_number",
    description: 'Generate random numbers within specified range',
    inputSchemaProperties: {
      'min': {
        'type': 'number',
        'description': 'Minimum value (inclusive)',
        'default': 0,
      },
      'max': {
        'type': 'number',
        'description': 'Maximum value (inclusive)',
        'default': 100,
      },
      'count': {
        'type': 'integer',
        'description': 'Number of random numbers to generate',
        'default': 1,
        'minimum': 1,
        'maximum': 10,
      },
    },
    callback: ({args, extra}) async {
      try {
        final min = (args!['min'] as num?)?.toInt() ?? 0;
        final max = (args['max'] as num?)?.toInt() ?? 100;
        final count = (args['count'] as num?)?.toInt() ?? 1;

        final random = Random();
        final numbers = List.generate(
          count,
          (_) => min + random.nextInt(max - min + 1),
        );

        return CallToolResult.fromContent(
          content: [
            TextContent(
              text:
                  'Random numbers between $min and $max:\n${numbers.join(', ')}',
            ),
          ],
        );
      } catch (e) {
        return CallToolResult.fromContent(
          content: [TextContent(text: 'Random generation error: $e')],
          isError: true,
        );
      }
    },
  );
}

/// Register utility tools
void _registerUtilityTools(McpServer server) {
  // Current time
  server.tool(
    "current_time",
    description: 'Get current date and time in various formats',
    inputSchemaProperties: {
      'format': {
        'type': 'string',
        'description': 'Time format: iso, local, utc, timestamp',
        'enum': ['iso', 'local', 'utc', 'timestamp'],
        'default': 'local',
      },
      'timezone': {
        'type': 'string',
        'description': 'Timezone (only for local format)',
        'default': 'system',
      },
    },
    callback: ({args, extra}) async {
      try {
        final format = args!['format'] as String? ?? 'local';
        final now = DateTime.now();

        String timeString;
        switch (format) {
          case 'iso':
            timeString = now.toIso8601String();
            break;
          case 'utc':
            timeString = now.toUtc().toString();
            break;
          case 'timestamp':
            timeString = now.millisecondsSinceEpoch.toString();
            break;
          case 'local':
          default:
            timeString = now.toString();
            break;
        }

        return CallToolResult.fromContent(
          content: [
            TextContent(
              text: 'Current time ($format): $timeString',
            ),
          ],
        );
      } catch (e) {
        return CallToolResult.fromContent(
          content: [TextContent(text: 'Time error: $e')],
          isError: true,
        );
      }
    },
  );

  // UUID generator
  server.tool(
    "uuid_generate",
    description: 'Generate UUID (Universally Unique Identifier)',
    inputSchemaProperties: {
      'count': {
        'type': 'integer',
        'description': 'Number of UUIDs to generate',
        'default': 1,
        'minimum': 1,
        'maximum': 5,
      },
    },
    callback: ({args, extra}) async {
      try {
        final count = (args!['count'] as num?)?.toInt() ?? 1;
        final uuids = List.generate(count, (_) => _generateUuid());

        return CallToolResult.fromContent(
          content: [
            TextContent(
              text: count == 1
                  ? 'Generated UUID: ${uuids.first}'
                  : 'Generated UUIDs:\n${uuids.map((u) => '• $u').join('\n')}',
            ),
          ],
        );
      } catch (e) {
        return CallToolResult.fromContent(
          content: [TextContent(text: 'UUID generation error: $e')],
          isError: true,
        );
      }
    },
  );
}

/// Register file operation tools
void _registerFileTools(McpServer server) {
  server.tool(
    "file_info",
    description: 'Get information about a file or directory',
    inputSchemaProperties: {
      'path': {
        'type': 'string',
        'description': 'File or directory path',
      },
    },
    callback: ({args, extra}) async {
      try {
        final path = args!['path'] as String;
        final file = File(path);
        final directory = Directory(path);

        String info;
        if (await file.exists()) {
          final stat = await file.stat();
          final size = stat.size;
          final modified = stat.modified;
          info = 'File: $path\n'
              'Size: $size bytes\n'
              'Modified: $modified\n'
              'Type: ${stat.type}';
        } else if (await directory.exists()) {
          final contents = await directory.list().length;
          info = 'Directory: $path\n'
              'Contents: $contents items\n'
              'Type: directory';
        } else {
          info = 'Path does not exist: $path';
        }

        return CallToolResult.fromContent(
          content: [TextContent(text: info)],
        );
      } catch (e) {
        return CallToolResult.fromContent(
          content: [TextContent(text: 'File info error: $e')],
          isError: true,
        );
      }
    },
  );
}

/// Register system information tools
void _registerSystemTools(McpServer server) {
  server.tool(
    "system_info",
    description: 'Get system information',
    inputSchemaProperties: {
      'type': {
        'type': 'string',
        'description': 'Type of system info: os, memory, environment',
        'enum': ['os', 'memory', 'environment', 'all'],
        'default': 'all',
      },
    },
    callback: ({args, extra}) async {
      try {
        final type = args!['type'] as String? ?? 'all';
        final info = StringBuffer();

        if (type == 'os' || type == 'all') {
          info.writeln('Operating System: ${Platform.operatingSystem}');
          info.writeln('OS Version: ${Platform.operatingSystemVersion}');
          info.writeln('Dart Version: ${Platform.version}');
        }

        if (type == 'environment' || type == 'all') {
          info.writeln('\nEnvironment Variables:');
          final envVars = Platform.environment;
          final importantVars = ['PATH', 'HOME', 'USER', 'SHELL'];
          for (final varName in importantVars) {
            if (envVars.containsKey(varName)) {
              info.writeln('  $varName: ${envVars[varName]}');
            }
          }
        }

        return CallToolResult.fromContent(
          content: [TextContent(text: info.toString().trim())],
        );
      } catch (e) {
        return CallToolResult.fromContent(
          content: [TextContent(text: 'System info error: $e')],
          isError: true,
        );
      }
    },
  );
}

/// Simple math expression evaluator
double _evaluateMathExpression(String expression) {
  // Remove spaces
  expression = expression.replaceAll(' ', '');

  // Handle special functions
  if (expression.startsWith('sqrt(') && expression.endsWith(')')) {
    final inner = expression.substring(5, expression.length - 1);
    return sqrt(double.parse(inner));
  }

  if (expression.startsWith('sin(') && expression.endsWith(')')) {
    final inner = expression.substring(4, expression.length - 1);
    return sin(double.parse(inner) * pi / 180); // Convert degrees to radians
  }

  if (expression.startsWith('cos(') && expression.endsWith(')')) {
    final inner = expression.substring(4, expression.length - 1);
    return cos(double.parse(inner) * pi / 180);
  }

  if (expression.startsWith('tan(') && expression.endsWith(')')) {
    final inner = expression.substring(4, expression.length - 1);
    return tan(double.parse(inner) * pi / 180);
  }

  // Handle basic arithmetic (very simplified)
  if (expression.contains('+')) {
    final parts = expression.split('+');
    return parts.map(double.parse).reduce((a, b) => a + b);
  }

  if (expression.contains('-') && !expression.startsWith('-')) {
    final parts = expression.split('-');
    return parts.map(double.parse).reduce((a, b) => a - b);
  }

  if (expression.contains('*')) {
    final parts = expression.split('*');
    return parts.map(double.parse).reduce((a, b) => a * b);
  }

  if (expression.contains('/')) {
    final parts = expression.split('/');
    return parts.map(double.parse).reduce((a, b) => a / b);
  }

  // Single number
  return double.parse(expression);
}

/// Generate a simple UUID (not cryptographically secure)
String _generateUuid() {
  final random = Random();
  final chars = '0123456789abcdef';
  final uuid = StringBuffer();

  for (int i = 0; i < 32; i++) {
    if (i == 8 || i == 12 || i == 16 || i == 20) {
      uuid.write('-');
    }
    uuid.write(chars[random.nextInt(chars.length)]);
  }

  return uuid.toString();
}
