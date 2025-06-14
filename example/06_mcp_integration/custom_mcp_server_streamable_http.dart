// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:mcp_dart/mcp_dart.dart';

// Add a custom extension to access the server from the RequestHandlerExtra
extension McpRequestHandlerExtra on RequestHandlerExtra {
  Server? get mcpServer => null;
}

// Simple in-memory event store for resumability
class InMemoryEventStore implements EventStore {
  final Map<String, List<({EventId id, JsonRpcMessage message})>> _events = {};
  int _eventCounter = 0;

  @override
  Future<EventId> storeEvent(StreamId streamId, JsonRpcMessage message) async {
    final eventId = (++_eventCounter).toString();
    _events.putIfAbsent(streamId, () => []);
    _events[streamId]!.add((id: eventId, message: message));
    return eventId;
  }

  @override
  Future<StreamId> replayEventsAfter(
    EventId lastEventId, {
    required Future<void> Function(EventId eventId, JsonRpcMessage message)
        send,
  }) async {
    // Find the stream containing this event ID
    String? streamId;
    int fromIndex = -1;

    for (final entry in _events.entries) {
      final idx = entry.value.indexWhere((event) => event.id == lastEventId);

      if (idx >= 0) {
        streamId = entry.key;
        fromIndex = idx;
        break;
      }
    }

    if (streamId == null) {
      throw StateError('Event ID not found: $lastEventId');
    }

    // Replay all events after the lastEventId
    for (int i = fromIndex + 1; i < _events[streamId]!.length; i++) {
      final event = _events[streamId]![i];
      await send(event.id, event.message);
    }

    return streamId;
  }
}

// Create an MCP server with implementation details
McpServer getServer() {
  // Create the McpServer with the implementation details and options
  final server = McpServer(
    Implementation(name: 'simple-streamable-http-server', version: '1.0.0'),
  );

  // Register a simple tool that returns a greeting
  server.tool(
    'greet',
    description: 'A simple greeting tool',
    inputSchemaProperties: {
      'name': {'type': 'string', 'description': 'Name to greet'},
    },
    callback: ({args, extra}) async {
      final name = args?['name'] as String? ?? 'world';
      return CallToolResult.fromContent(
        content: [
          TextContent(text: 'Hello, $name!'),
        ],
      );
    },
  );

  // Register mathematical calculation tools
  _registerMathTools(server);
  
  // Register utility tools
  _registerUtilityTools(server);
  
  // Register streaming tools
  _registerStreamingTools(server);

  // Register a simple prompt
  server.prompt(
    'greeting-template',
    description: 'A simple greeting prompt template',
    argsSchema: {
      'name': PromptArgumentDefinition(
        description: 'Name to include in greeting',
        required: true,
      ),
    },
    callback: (args, extra) async {
      final name = args!['name'] as String;
      return GetPromptResult(
        messages: [
          PromptMessage(
            role: PromptMessageRole.user,
            content: TextContent(
              text: 'Please greet $name in a friendly manner.',
            ),
          ),
        ],
      );
    },
  );

  // Create a simple resource at a fixed URI
  server.resource(
    'greeting-resource',
    'https://example.com/greetings/default',
    (uri, extra) async {
      return ReadResourceResult(
        contents: [
          ResourceContents.fromJson({
            'uri': 'https://example.com/greetings/default',
            'text': 'Hello, world!',
            'mimeType': 'text/plain'
          }),
        ],
      );
    },
    metadata: (mimeType: 'text/plain', description: null),
  );

  return server;
}

void main() async {
  // Map to store transports by session ID
  final transports = <String, StreamableHTTPServerTransport>{};

  // Create HTTP server
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
  print('MCP Streamable HTTP Server listening on port 3000');
  print('📋 Available Tools:');
  print('   • greet - Simple greeting tool');
  print('   • calculate - Simple mathematical calculations (addition only)');
  print('   • random_number - Generate random numbers');
  print('   • current_time - Get current date and time');
  print('   • multi-greet - Multiple greetings with notifications');
  print('   • start-notification-stream - Periodic notifications for testing');
  print('\n🌐 Connect to: http://localhost:3000/mcp');
  print('⏹️  Press Ctrl+C to stop\n');

  await for (final request in server) {
    if (request.uri.path != '/mcp') {
      // Not an MCP endpoint
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found')
        ..close();
      continue;
    }

    switch (request.method) {
      case 'POST':
        await handlePostRequest(request, transports);
        break;
      case 'GET':
        await handleGetRequest(request, transports);
        break;
      case 'DELETE':
        await handleDeleteRequest(request, transports);
        break;
      default:
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..headers.set(HttpHeaders.allowHeader, 'GET, POST, DELETE')
          ..write('Method Not Allowed')
          ..close();
    }
  }
}



// Handle POST requests
Future<void> handlePostRequest(
  HttpRequest request,
  Map<String, StreamableHTTPServerTransport> transports,
) async {
  print('Received MCP request');

  try {
    // Check for existing session ID first
    final sessionId = request.headers.value('mcp-session-id');
    StreamableHTTPServerTransport? transport;

    if (sessionId != null && transports.containsKey(sessionId)) {
      // Reuse existing transport
      transport = transports[sessionId]!;
      await transport.handleRequest(request);
      return;
    }

    // For new sessions, we need to check if it's an initialize request
    // We'll let the transport handle the body parsing to avoid stream conflicts
    if (sessionId == null) {
      // New initialization request
      final eventStore = InMemoryEventStore();
      transport = StreamableHTTPServerTransport(
        options: StreamableHTTPServerTransportOptions(
          sessionIdGenerator: () => generateUUID(),
          eventStore: eventStore, // Enable resumability
          onsessioninitialized: (sessionId) {
            // Store the transport by session ID when session is initialized
            print('Session initialized with ID: $sessionId');
            transports[sessionId] = transport!;
          },
        ),
      );

      // Set up onclose handler to clean up transport when closed
      transport.onclose = () {
        final sid = transport!.sessionId;
        if (sid != null && transports.containsKey(sid)) {
          print(
              'Transport closed for session $sid, removing from transports map');
          transports.remove(sid);
        }
      };

      // Connect the transport to the MCP server BEFORE handling the request
      final server = getServer();
      await server.connect(transport);

      await transport.handleRequest(request);
      return;
    } else {
      // Invalid request - session ID provided but not found
      request.response
        ..statusCode = HttpStatus.badRequest
        ..headers.set(HttpHeaders.contentTypeHeader, 'application/json')
        ..write(jsonEncode({
          'jsonrpc': '2.0',
          'error': {
            'code': -32000,
            'message': 'Bad Request: Invalid session ID',
          },
          'id': null,
        }))
        ..close();
      return;
    }
  } catch (error) {
    print('Error handling MCP request: $error');
    // Check if headers are already sent
    bool headersSent = false;
    try {
      headersSent = request.response.headers.contentType
          .toString()
          .startsWith('text/event-stream');
    } catch (_) {
      // Ignore errors when checking headers
    }

    if (!headersSent) {
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..headers.set(HttpHeaders.contentTypeHeader, 'application/json')
        ..write(jsonEncode({
          'jsonrpc': '2.0',
          'error': {
            'code': -32603,
            'message': 'Internal server error',
          },
          'id': null,
        }))
        ..close();
    }
  }
}

// Handle GET requests for SSE streams
Future<void> handleGetRequest(
  HttpRequest request,
  Map<String, StreamableHTTPServerTransport> transports,
) async {
  final sessionId = request.headers.value('mcp-session-id');
  if (sessionId == null || !transports.containsKey(sessionId)) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Invalid or missing session ID')
      ..close();
    return;
  }

  // Check for Last-Event-ID header for resumability
  final lastEventId = request.headers.value('Last-Event-ID');
  if (lastEventId != null) {
    print('Client reconnecting with Last-Event-ID: $lastEventId');
  } else {
    print('Establishing new SSE stream for session $sessionId');
  }

  final transport = transports[sessionId]!;
  await transport.handleRequest(request);
}

// Handle DELETE requests for session termination
Future<void> handleDeleteRequest(
  HttpRequest request,
  Map<String, StreamableHTTPServerTransport> transports,
) async {
  final sessionId = request.headers.value('mcp-session-id');
  if (sessionId == null || !transports.containsKey(sessionId)) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Invalid or missing session ID')
      ..close();
    return;
  }

  print('Received session termination request for session $sessionId');

  try {
    final transport = transports[sessionId]!;
    await transport.handleRequest(request);
  } catch (error) {
    print('Error handling session termination: $error');
    // Check if headers are already sent
    bool headersSent = false;
    try {
      headersSent = request.response.headers.contentType
          .toString()
          .startsWith('text/event-stream');
    } catch (_) {
      // Ignore errors when checking headers
    }

    if (!headersSent) {
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Error processing session termination')
        ..close();
    }
  }
}



/// Register mathematical calculation tools
void _registerMathTools(McpServer server) {
  // Basic calculator
  server.tool(
    "calculate",
    description:
        'Perform simple mathematical calculations (supports addition only)',
    inputSchemaProperties: {
      'expression': {
        'type': 'string',
        'description':
            'Mathematical expression to evaluate (e.g., "2 + 3 + 4", "15 + 23 + 7")',
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
}

/// Register streaming and notification tools
void _registerStreamingTools(McpServer server) {
  // Register a tool that sends multiple greetings with notifications
  server.tool(
    'multi-greet',
    description:
        'A tool that sends different greetings with delays between them',
    inputSchemaProperties: {
      'name': {'type': 'string', 'description': 'Name to greet'},
    },
    annotations: ToolAnnotations(
      title: 'Multiple Greeting Tool',
      readOnlyHint: true,
      openWorldHint: false,
    ),
    callback: ({args, extra}) async {
      final name = args?['name'] as String? ?? 'world';

      // Helper function for sleeping
      Future<void> sleep(int ms) => Future.delayed(Duration(milliseconds: ms));

      // Send debug notification
      await extra?.sendNotification(JsonRpcLoggingMessageNotification(
          logParams: LoggingMessageNotificationParams(
        level: LoggingLevel.debug,
        data: 'Starting multi-greet for $name',
      )));

      await sleep(1000); // Wait 1 second before first greeting

      // Send first info notification
      await extra?.sendNotification(JsonRpcLoggingMessageNotification(
          logParams: LoggingMessageNotificationParams(
        level: LoggingLevel.info,
        data: 'Sending first greeting to $name',
      )));

      await sleep(1000); // Wait another second before second greeting

      // Send second info notification
      await extra?.sendNotification(JsonRpcLoggingMessageNotification(
          logParams: LoggingMessageNotificationParams(
        level: LoggingLevel.info,
        data: 'Sending second greeting to $name',
      )));

      return CallToolResult.fromContent(
        content: [
          TextContent(text: 'Good morning, $name!'),
        ],
      );
    },
  );

  // Register a tool specifically for testing resumability
  server.tool(
    'start-notification-stream',
    description:
        'Starts sending periodic notifications for testing resumability',
    inputSchemaProperties: {
      'interval': {
        'type': 'number',
        'description': 'Interval in milliseconds between notifications',
        'default': 100,
      },
      'count': {
        'type': 'number',
        'description': 'Number of notifications to send (0 for 100)',
        'default': 50,
      },
    },
    callback: ({args, extra}) async {
      final interval = args?['interval'] as num? ?? 100;
      final count = args?['count'] as num? ?? 50;

      // Helper function for sleeping
      Future<void> sleep(int ms) => Future.delayed(Duration(milliseconds: ms));

      var counter = 0;

      while (count == 0 || counter < count) {
        counter++;
        try {
          await extra?.sendNotification(JsonRpcLoggingMessageNotification(
              logParams: LoggingMessageNotificationParams(
            level: LoggingLevel.info,
            data:
                'Periodic notification #$counter at ${DateTime.now().toIso8601String()}',
          )));
        } catch (error) {
          print('Error sending notification: $error');
        }

        // Wait for the specified interval
        await sleep(interval.toInt());
      }

      return CallToolResult.fromContent(
        content: [
          TextContent(
            text: 'Started sending periodic notifications every ${interval}ms',
          ),
        ],
      );
    },
  );
}

/// Simple math expression evaluator (supports addition only)
double _evaluateMathExpression(String expression) {
  // Remove spaces
  expression = expression.replaceAll(' ', '');

  // Handle simple addition
  if (expression.contains('+')) {
    final parts = expression.split('+');
    double result = 0;
    for (final part in parts) {
      result += double.parse(part.trim());
    }
    return result;
  }

  // Single number
  return double.parse(expression);
}
