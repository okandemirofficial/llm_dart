# Custom Dio Client Support

The llm_dart package now supports passing your own custom Dio instance for HTTP requests. This allows you to:

- Add custom interceptors for logging, monitoring, or debugging
- Configure proxy settings
- Set custom certificates for secure connections
- Implement request/response caching
- Add custom authentication headers
- Share the same HTTP client across multiple providers

## Basic Usage

```dart
import 'package:dio/dio.dart';
import 'package:llm_dart/llm_dart.dart';

// Create a custom Dio instance
final customDio = Dio();

// Add custom interceptors
customDio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
  logPrint: (object) => print('HTTP Log: $object'),
));

// Use with any provider
final provider = await ai()
    .anthropic()
    .apiKey("your-api-key")
    .model("claude-3-5-sonnet-20241022")
    .dioClient(customDio)  // Pass your custom Dio instance
    .build();
```

## Advanced Examples

### Custom Logging and Monitoring

```dart
final dio = Dio();

// Add comprehensive request/response logging
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    print('→ ${options.method} ${options.uri}');
    print('Headers: ${options.headers}');
    handler.next(options);
  },
  onResponse: (response, handler) {
    print('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  },
  onError: (error, handler) {
    print('✗ ${error.message}');
    handler.next(error);
  },
));

final provider = await ai()
    .openai()
    .apiKey("your-api-key")
    .dioClient(dio)
    .build();
```

### Proxy Configuration

```dart
final dio = Dio();

// Configure proxy settings
dio.options.headers['Proxy-Authorization'] = 'Bearer your-proxy-token';

// Custom certificate handling for corporate environments
(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
  client.badCertificateCallback = (cert, host, port) => true;
  return client;
};

final provider = await ai()
    .anthropic()
    .apiKey("your-api-key")
    .dioClient(dio)
    .build();
```

### API Key Rotation

```dart
class ApiKeyRotationInterceptor extends Interceptor {
  final List<String> apiKeys;
  int currentKeyIndex = 0;

  ApiKeyRotationInterceptor(this.apiKeys);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
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
    if (err.response?.statusCode == 429) {
      print('Rate limited, rotating to next API key...');
      // Retry logic could be implemented here
    }
    
    handler.next(err);
  }
}

// Usage
final dio = Dio();
dio.interceptors.add(ApiKeyRotationInterceptor([
  'key1',
  'key2', 
  'key3'
]));

final provider = await ai()
    .openai()
    .dioClient(dio)
    .build();
```

### Shared Dio Instance

```dart
// Create one Dio instance for all providers
final sharedDio = Dio();
sharedDio.options.connectTimeout = const Duration(seconds: 30);
sharedDio.options.receiveTimeout = const Duration(seconds: 60);

// Add shared interceptors
sharedDio.interceptors.add(LogInterceptor());

// Use with multiple providers
final anthropicProvider = await ai()
    .anthropic()
    .apiKey("anthropic-key")
    .dioClient(sharedDio)
    .build();

final openaiProvider = await ai()
    .openai()
    .apiKey("openai-key")
    .dioClient(sharedDio)
    .build();

// Both providers will use the same HTTP client with shared configuration
```

### DeepSeek with Custom Monitoring

```dart
final deepSeekDio = Dio();

// Add DeepSeek-specific monitoring
deepSeekDio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    print('📤 DeepSeek request: ${options.method} ${options.uri}');
    handler.next(options);
  },
  onResponse: (response, handler) {
    print('📥 DeepSeek response: ${response.statusCode}');
    handler.next(response);
  },
));

// Configure longer timeouts for reasoning models
deepSeekDio.options.receiveTimeout = const Duration(seconds: 120);

final deepSeekProvider = await ai()
    .deepseek()
    .apiKey("your-deepseek-key")
    .model("deepseek-reasoner")
    .dioClient(deepSeekDio)
    .reasoning(true)
    .build();
```

### ElevenLabs with Audio Request Monitoring

```dart
final elevenLabsDio = Dio();

// Add audio-specific interceptors
elevenLabsDio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    print('🎵 ElevenLabs audio request: ${options.method} ${options.uri}');
    
    // Log request type based on endpoint
    if (options.path.contains('text-to-speech')) {
      print('🗣️  Request type: Text-to-Speech');
    } else if (options.path.contains('speech-to-text')) {
      print('👂 Request type: Speech-to-Text');
    } else if (options.path.contains('voices')) {
      print('🎭 Request type: Voice listing');
    }
    
    handler.next(options);
  },
  onResponse: (response, handler) {
    print('📥 ElevenLabs response: ${response.statusCode}');
    
    // Log response details for audio requests
    final contentType = response.headers.value('content-type');
    if (contentType?.contains('audio') == true) {
      print('🎵 Audio response received: ${response.data?.length ?? 0} bytes');
    }
    
    handler.next(response);
  },
));

// Configure timeouts for audio processing
elevenLabsDio.options.connectTimeout = const Duration(seconds: 30);
elevenLabsDio.options.receiveTimeout = const Duration(seconds: 180); // Audio generation can take longer

final elevenLabsProvider = await ai()
    .provider("elevenlabs")
    .apiKey("your-elevenlabs-key")
    .dioClient(elevenLabsDio)
    .build();
```

## Important Notes

### Header Merging
When you provide a custom Dio instance, llm_dart will:
- Preserve your existing headers
- Add provider-specific authentication headers
- Merge rather than replace configurations

### Base URL Handling
- If your Dio instance doesn't have a base URL set, llm_dart will set it automatically
- If you have a base URL set, it will be preserved

### Timeout Configuration
- Custom timeouts in your Dio instance take precedence
- If no timeouts are set, llm_dart will apply default timeouts

### Provider Compatibility
This feature is currently supported by:
- ✅ Anthropic
- ✅ OpenAI  
- ✅ DeepSeek
- 🔄 Other providers (coming soon)

## Migration Guide

### Before (using default HTTP client)
```dart
final provider = await ai()
    .anthropic()
    .apiKey("your-api-key")
    .timeout(Duration(seconds: 30))  // Basic timeout config
    .build();
```

### After (using custom Dio client)
```dart
final customDio = Dio();
customDio.options.connectTimeout = const Duration(seconds: 30);
customDio.interceptors.add(LogInterceptor());  // Add advanced features

final provider = await ai()
    .anthropic()
    .apiKey("your-api-key")
    .dioClient(customDio)  // Full control over HTTP client
    .build();
```

## Benefits

1. **Enhanced Debugging**: Add detailed request/response logging
2. **Corporate Networks**: Support for proxies and custom certificates
3. **Performance Monitoring**: Track request metrics and performance
4. **Resilience**: Implement retry logic and circuit breakers
5. **Security**: Add custom authentication and encryption
6. **Efficiency**: Share HTTP connections across multiple providers
7. **Compliance**: Meet enterprise security and auditing requirements

## Example Integration with Popular Packages

### With `dio_certificate_pinning`
```dart
final dio = Dio();
dio.interceptors.add(CertificatePinningInterceptor(
  allowedSHAFingerprints: ['YOUR_SHA_FINGERPRINT'],
));
```

### With `dio_cache_interceptor`
```dart
final dio = Dio();
dio.interceptors.add(DioCacheInterceptor(
  options: CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 7),
  ),
));
```

### With `pretty_dio_logger`
```dart
final dio = Dio();
dio.interceptors.add(PrettyDioLogger(
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: true,
));
```

## See Also

- [Dio Documentation](https://pub.dev/packages/dio)
- [Custom Dio Example](example/custom_dio_example.dart)
- [llm_dart Provider Documentation](README.md) 