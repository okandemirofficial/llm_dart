import 'package:dio/dio.dart';
import 'package:llm_dart/llm_dart.dart';

void main() async {
  // Create a custom Dio instance with your preferred configuration
  final customDio = Dio();

  // Add custom interceptors
  customDio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => print('Custom Dio Log: $object'),
    ),
  );

  // Add custom proxy settings if needed
  // customDio.options.headers['User-Agent'] = 'MyApp/1.0';

  // Configure custom timeouts
  customDio.options.connectTimeout = const Duration(seconds: 30);
  customDio.options.receiveTimeout = const Duration(seconds: 60);

  // Example 1: Using custom Dio with Anthropic
  print('=== Anthropic with Custom Dio ===');
  try {
    final anthropicProvider = await ai()
        .provider("anthropic")
        .apiKey("your-anthropic-api-key-here")
        .model("claude-3-5-sonnet-20241022")
        .dioClient(customDio) // Pass your custom Dio instance
        .build();

    final response = await anthropicProvider.chat([
      ChatMessage.user("Hello! Can you tell me about custom HTTP clients?")
    ]);

    print('Response: ${response.text}');
  } catch (e) {
    print('Error: $e');
  }

  // Example 2: Using custom Dio with OpenAI
  print('\n=== OpenAI with Custom Dio ===');
  try {
    final openaiProvider = await ai()
        .openai()
        .apiKey("your-openai-api-key-here")
        .model("gpt-3.5-turbo")
        .dioClient(customDio) // Pass your custom Dio instance
        .build();

    final response = await openaiProvider.chat([
      ChatMessage.user("Explain the benefits of custom HTTP clients in Dart.")
    ]);

    print('Response: ${response.text}');
  } catch (e) {
    print('Error: $e');
  }

  // Example 2.5: Using custom Dio with Groq
  print('\n=== Groq with Custom Dio ===');
  try {
    final groqProvider = await ai()
        .groq()
        .apiKey("your-groq-api-key-here")
        .model("llama-3.3-70b-versatile")
        .dioClient(customDio) // Pass your custom Dio instance
        .build();

    final response = await groqProvider.chat([
      ChatMessage.user("Explain ultra-fast inference and Groq's approach.")
    ]);

    print('Response: ${response.text}');
  } catch (e) {
    print('Error: $e');
  }

  // Example 2.6: Using custom Dio with Ollama
  print('\n=== Ollama with Custom Dio ===');
  try {
    final ollamaProvider = await ai()
        .ollama()
        .baseUrl("http://localhost:11434")
        .model("llama3.2")
        .dioClient(customDio) // Pass your custom Dio instance
        .build();

    final response = await ollamaProvider.chat(
        [ChatMessage.user("Explain the benefits of local LLM deployment.")]);

    print('Response: ${response.text}');
  } catch (e) {
    print('Error: $e');
  }

  // Example 3: Custom Dio with specific proxy settings
  print('\n=== Custom Dio with Proxy Settings ===');
  final proxyDio = Dio();

  // Configure proxy if needed (example)
  // proxyDio.options.headers['Proxy-Authorization'] = 'Bearer your-proxy-token';

  // Add custom certificate handling
  // (proxyDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
  //   client.badCertificateCallback = (cert, host, port) => true;
  //   return client;
  // };

  try {
    await ai().anthropic().apiKey("your-api-key").dioClient(proxyDio).build();

    print('Provider created successfully with custom proxy Dio');
  } catch (e) {
    print('Error with proxy Dio: $e');
  }

  // Example 4: Using the same custom Dio instance across multiple providers
  print('\n=== Shared Custom Dio Instance ===');
  final sharedDio = Dio();
  sharedDio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print('Making request to: ${options.uri}');
      handler.next(options);
    },
    onResponse: (response, handler) {
      print('Received response with status: ${response.statusCode}');
      handler.next(response);
    },
    onError: (error, handler) {
      print('Request failed: ${error.message}');
      handler.next(error);
    },
  ));

  // You can now use the same Dio instance for multiple providers
  // This is useful for:
  // - Consistent logging across all providers
  // - Shared proxy settings
  // - Common authentication headers
  // - Request/response caching

  // Example using shared Dio with multiple providers
  try {
    final groqProvider =
        await ai().groq().apiKey("your-groq-key").dioClient(sharedDio).build();

    print('Groq provider created successfully with shared Dio instance');

    // Create Ollama provider with shared Dio
    final ollamaProvider = await ai()
        .ollama()
        .baseUrl("http://localhost:11434")
        .model("llama3.2")
        .dioClient(sharedDio)
        .build();

    print('Ollama provider created successfully with shared Dio instance');
  } catch (e) {
    print('Error with shared Dio providers: $e');
  }

  print('Setup completed. Custom Dio instances are ready for use!');
}

/// Example of a custom interceptor for API key rotation
class ApiKeyRotationInterceptor extends Interceptor {
  final List<String> apiKeys;
  int currentKeyIndex = 0;

  ApiKeyRotationInterceptor(this.apiKeys);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Rotate API keys on each request
    if (apiKeys.isNotEmpty) {
      final currentKey = apiKeys[currentKeyIndex];

      // Update the appropriate header based on provider
      if (options.headers.containsKey('Authorization')) {
        options.headers['Authorization'] = 'Bearer $currentKey';
      } else if (options.headers.containsKey('x-api-key')) {
        options.headers['x-api-key'] = currentKey;
      }

      currentKeyIndex = (currentKeyIndex + 1) % apiKeys.length;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle rate limiting by trying the next API key
    if (err.response?.statusCode == 429) {
      print('Rate limited, rotating to next API key...');
      // In a real implementation, you might retry the request with the next key
    }

    handler.next(err);
  }
}
