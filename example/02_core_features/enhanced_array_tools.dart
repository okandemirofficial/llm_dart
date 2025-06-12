// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🔧 Enhanced Array Tools - Nested Object Support
///
/// This example demonstrates the new enhanced array tool functionality:
/// - Defining arrays with complex object structures
/// - Nested object validation and type checking
/// - Real-world use cases for structured data processing
///
/// Before running, set your API key:
/// export OPENAI_API_KEY="your-key"
void main() async {
  print('🔧 Enhanced Array Tools - Nested Object Support\n');

  // Get API key
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';

  // Create AI provider
  final provider = await ai()
      .openai()
      .apiKey(apiKey)
      .model('gpt-4o-mini')
      .temperature(0.1)
      .maxTokens(1000)
      .build();

  // Demonstrate different array tool scenarios
  await demonstrateBasicArrayWithObjects(provider);
  await demonstrateComplexNestedStructures(provider);
  await demonstrateValidationFeatures(provider);

  print('\n✅ Enhanced array tools demonstration completed!');
}

/// Demonstrate basic array with object structures
Future<void> demonstrateBasicArrayWithObjects(ChatCapability provider) async {
  print('📋 Basic Array with Object Structures:\n');

  try {
    // Define a tool that processes an array of user objects
    final processUsersTool = Tool.function(
      name: 'process_users',
      description: 'Process a list of user objects with validation',
      parameters: ParametersSchema(
        schemaType: 'object',
        properties: {
          'users': ParameterProperty(
            propertyType: 'array',
            description: 'Array of user objects to process',
            items: ParameterProperty(
              propertyType: 'object',
              description: 'Individual user object',
              properties: {
                'name': ParameterProperty(
                  propertyType: 'string',
                  description: 'User full name',
                ),
                'email': ParameterProperty(
                  propertyType: 'string',
                  description: 'User email address',
                ),
                'age': ParameterProperty(
                  propertyType: 'integer',
                  description: 'User age in years',
                ),
                'active': ParameterProperty(
                  propertyType: 'boolean',
                  description: 'Whether user account is active',
                ),
              },
              required: ['name', 'email'], // age and active are optional
            ),
          ),
        },
        required: ['users'],
      ),
    );

    final messages = [
      ChatMessage.user(
        'Process these users: John Doe (john@example.com, 30, active) and Jane Smith (jane@example.com, 25, inactive). Use the process_users tool.',
      )
    ];

    print('   User: Process these users: John Doe and Jane Smith...');
    print('   Available tools: process_users (with nested object validation)');

    final response = await provider.chatWithTools(messages, [processUsersTool]);

    if (response.toolCalls != null && response.toolCalls!.isNotEmpty) {
      print('   🔧 AI tool calls:');

      for (final toolCall in response.toolCalls!) {
        print('      • Function: ${toolCall.function.name}');
        print('      • Arguments: ${toolCall.function.arguments}');

        // Validate the tool call structure
        final isValid =
            ToolValidator.validateToolCall(toolCall, processUsersTool);
        print('      • Validation: ${isValid ? '✅ Valid' : '❌ Invalid'}');

        // Execute the function
        final result = await _processUsers(toolCall);
        print('      • Result: $result');
      }

      print('   ✅ Basic array with objects completed\n');
    } else {
      print('   ℹ️  AI chose not to use tools: ${response.text}\n');
    }
  } catch (e) {
    print('   ❌ Error: $e\n');
  }
}

/// Demonstrate complex nested structures
Future<void> demonstrateComplexNestedStructures(ChatCapability provider) async {
  print('🏗️  Complex Nested Structures:\n');

  try {
    // Define a tool for processing orders with items
    final processOrdersTool = Tool.function(
      name: 'process_orders',
      description: 'Process customer orders with complex item structures',
      parameters: ParametersSchema(
        schemaType: 'object',
        properties: {
          'orders': ParameterProperty(
            propertyType: 'array',
            description: 'Array of customer orders',
            items: ParameterProperty(
              propertyType: 'object',
              description: 'Individual order object',
              properties: {
                'order_id': ParameterProperty(
                  propertyType: 'string',
                  description: 'Unique order identifier',
                ),
                'customer_name': ParameterProperty(
                  propertyType: 'string',
                  description: 'Customer full name',
                ),
                'items': ParameterProperty(
                  propertyType: 'array',
                  description: 'Array of items in the order',
                  items: ParameterProperty(
                    propertyType: 'object',
                    description: 'Individual item object',
                    properties: {
                      'product_name': ParameterProperty(
                        propertyType: 'string',
                        description: 'Name of the product',
                      ),
                      'quantity': ParameterProperty(
                        propertyType: 'integer',
                        description: 'Number of items ordered',
                      ),
                      'price': ParameterProperty(
                        propertyType: 'number',
                        description: 'Price per item in dollars',
                      ),
                      'category': ParameterProperty(
                        propertyType: 'string',
                        description: 'Product category',
                        enumList: ['electronics', 'clothing', 'books', 'home'],
                      ),
                    },
                    required: ['product_name', 'quantity', 'price'],
                  ),
                ),
                'total_amount': ParameterProperty(
                  propertyType: 'number',
                  description: 'Total order amount in dollars',
                ),
              },
              required: ['order_id', 'customer_name', 'items'],
            ),
          ),
        },
        required: ['orders'],
      ),
    );

    final messages = [
      ChatMessage.user(
        'Process order ORD001 for Alice Johnson: 2x Laptop at \$999 each (electronics), 1x T-shirt at \$25 (clothing). Total: \$2023. Use the process_orders tool.',
      )
    ];

    print('   User: Process order ORD001 for Alice Johnson...');
    print(
        '   Available tools: process_orders (with nested arrays and objects)');

    final response =
        await provider.chatWithTools(messages, [processOrdersTool]);

    if (response.toolCalls != null && response.toolCalls!.isNotEmpty) {
      print('   🔧 AI tool calls:');

      for (final toolCall in response.toolCalls!) {
        print('      • Function: ${toolCall.function.name}');
        print('      • Arguments: ${toolCall.function.arguments}');

        try {
          final isValid =
              ToolValidator.validateToolCall(toolCall, processOrdersTool);
          print('      • Validation: ${isValid ? '✅ Valid' : '❌ Invalid'}');

          final result = await _processOrders(toolCall);
          print('      • Result: $result');
        } catch (e) {
          print('      • Validation Error: $e');
        }
      }

      print('   ✅ Complex nested structures completed\n');
    } else {
      print('   ℹ️  AI chose not to use tools: ${response.text}\n');
    }
  } catch (e) {
    print('   ❌ Error: $e\n');
  }
}

/// Demonstrate validation features
Future<void> demonstrateValidationFeatures(ChatCapability provider) async {
  print('🔍 Validation Features:\n');

  // Create a tool with strict validation requirements
  final strictValidationTool = Tool.function(
    name: 'validate_data',
    description: 'Validate structured data with strict requirements',
    parameters: ParametersSchema(
      schemaType: 'object',
      properties: {
        'records': ParameterProperty(
          propertyType: 'array',
          description: 'Array of data records',
          items: ParameterProperty(
            propertyType: 'object',
            description: 'Data record with strict validation',
            properties: {
              'id': ParameterProperty(
                propertyType: 'string',
                description: 'Record identifier',
              ),
              'status': ParameterProperty(
                propertyType: 'string',
                description: 'Record status',
                enumList: ['active', 'inactive', 'pending'],
              ),
              'priority': ParameterProperty(
                propertyType: 'integer',
                description: 'Priority level (1-5)',
              ),
              'metadata': ParameterProperty(
                propertyType: 'object',
                description: 'Additional metadata',
                properties: {
                  'source': ParameterProperty(
                    propertyType: 'string',
                    description: 'Data source',
                  ),
                  'timestamp': ParameterProperty(
                    propertyType: 'string',
                    description: 'ISO timestamp',
                  ),
                },
                required: ['source'],
              ),
            },
            required: ['id', 'status', 'priority'],
          ),
        ),
      },
      required: ['records'],
    ),
  );

  // Test different validation scenarios
  final testCases = [
    'Create a valid record: ID="REC001", status="active", priority=3, metadata with source="api"',
    'Create an invalid record with missing required fields',
    'Create a record with invalid enum value for status',
  ];

  for (int i = 0; i < testCases.length; i++) {
    print('   Test ${i + 1}: ${testCases[i]}');

    try {
      final response = await provider.chatWithTools(
        [ChatMessage.user('${testCases[i]}. Use the validate_data tool.')],
        [strictValidationTool],
      );

      if (response.toolCalls != null && response.toolCalls!.isNotEmpty) {
        for (final toolCall in response.toolCalls!) {
          try {
            final isValid =
                ToolValidator.validateToolCall(toolCall, strictValidationTool);
            print('      ✅ Validation passed: $isValid');
          } catch (e) {
            print('      ❌ Validation failed: $e');
          }
        }
      }
    } catch (e) {
      print('      ❌ Request failed: $e');
    }

    print('');
  }

  print('   ✅ Validation features completed\n');
}

/// Mock function to process users
Future<String> _processUsers(ToolCall toolCall) async {
  try {
    final args =
        jsonDecode(toolCall.function.arguments) as Map<String, dynamic>;
    final users = args['users'] as List;

    final processed = users.map((user) {
      final u = user as Map<String, dynamic>;
      return '${u['name']} (${u['email']})';
    }).join(', ');

    return 'Processed ${users.length} users: $processed';
  } catch (e) {
    return 'Error processing users: $e';
  }
}

/// Mock function to process orders
Future<String> _processOrders(ToolCall toolCall) async {
  try {
    final args =
        jsonDecode(toolCall.function.arguments) as Map<String, dynamic>;
    final orders = args['orders'] as List;

    double totalRevenue = 0;
    int totalItems = 0;

    for (final order in orders) {
      final o = order as Map<String, dynamic>;
      final items = o['items'] as List;

      for (final item in items) {
        final i = item as Map<String, dynamic>;
        totalItems += i['quantity'] as int;
        totalRevenue += (i['quantity'] as int) * (i['price'] as num);
      }
    }

    return 'Processed ${orders.length} orders, $totalItems items, \$${totalRevenue.toStringAsFixed(2)} revenue';
  } catch (e) {
    return 'Error processing orders: $e';
  }
}
