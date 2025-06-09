// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🖼️ Multi-modal Processing - Images, Audio, and Files
///
/// This example demonstrates how to process different types of media with AI:
/// - Image analysis and understanding
/// - Audio transcription and generation
/// - File handling and document processing
/// - Multi-modal conversations
///
/// Before running, set your API keys:
/// export OPENAI_API_KEY="your-key"
/// export ANTHROPIC_API_KEY="your-key"
/// export ELEVENLABS_API_KEY="your-key"
void main() async {
  print('🖼️ Multi-modal Processing - Images, Audio, and Files\n');

  // Get API keys
  final openaiKey = Platform.environment['OPENAI_API_KEY'] ?? 'sk-TESTKEY';
  final anthropicKey =
      Platform.environment['ANTHROPIC_API_KEY'] ?? 'sk-ant-TESTKEY';
  final elevenlabsKey =
      Platform.environment['ELEVENLABS_API_KEY'] ?? 'el-TESTKEY';

  // Demonstrate different multi-modal scenarios
  await demonstrateImageAnalysis(openaiKey);
  await demonstrateImageGeneration(openaiKey);
  await demonstrateAudioProcessing(openaiKey, elevenlabsKey);
  await demonstrateDocumentProcessing(anthropicKey);
  await demonstrateMultiModalConversation(openaiKey);

  print('\n✅ Multi-modal processing completed!');
  print('📖 Next: Try custom_providers.dart for building custom AI providers');
}

/// Demonstrate image analysis with vision models
Future<void> demonstrateImageAnalysis(String apiKey) async {
  print('👁️  Image Analysis:\n');

  try {
    // Create vision-capable provider
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o') // Vision-capable model
        .temperature(0.7)
        .maxTokens(500)
        .build();

    // Simulate image data (in real usage, load from file)
    final imageUrl =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg';

    print('   Analyzing image: Nature boardwalk');

    // Create message with image
    final messages = [
      ChatMessage.imageUrl(
        role: ChatRole.user,
        url: imageUrl,
        content: 'What do you see in this image? Describe it in detail.',
      )
    ];

    final response = await provider.chat(messages);
    print('   🤖 AI Analysis: ${response.text}');

    // Follow-up question about the image
    messages.add(ChatMessage.assistant(response.text ?? ''));
    messages.add(ChatMessage.user(
        'What time of day do you think this photo was taken?'));

    final followUp = await provider.chat(messages);
    print('   🤖 Follow-up: ${followUp.text}');

    print('   ✅ Image analysis successful\n');
  } catch (e) {
    print('   ❌ Image analysis failed: $e\n');
  }
}

/// Demonstrate image generation
Future<void> demonstrateImageGeneration(String apiKey) async {
  print('🎨 Image Generation:\n');

  try {
    // Note: This would require DALL-E integration
    // For now, we'll demonstrate the concept
    print('   Generating image: "A futuristic city with flying cars"');
    print('   🎨 Image generation would be implemented here');
    print('   💡 Use OpenAI\'s DALL-E API for actual image generation');
    print('   ✅ Image generation concept demonstrated\n');
  } catch (e) {
    print('   ❌ Image generation failed: $e\n');
  }
}

/// Demonstrate audio processing
Future<void> demonstrateAudioProcessing(
    String openaiKey, String elevenlabsKey) async {
  print('🎵 Audio Processing:\n');

  // Speech-to-text with OpenAI Whisper
  await demonstrateSpeechToText(openaiKey);

  // Text-to-speech with ElevenLabs
  await demonstrateTextToSpeech(elevenlabsKey);
}

/// Demonstrate speech-to-text
Future<void> demonstrateSpeechToText(String apiKey) async {
  print('   🎤 Speech-to-Text (Whisper):');

  try {
    // Note: This would require Whisper API integration
    print('      Audio file: "Hello, this is a test recording"');
    print('      🎤 Transcription would be implemented here');
    print('      💡 Use OpenAI\'s Whisper API for actual transcription');
    print('      ✅ Speech-to-text concept demonstrated');
  } catch (e) {
    print('      ❌ Speech-to-text failed: $e');
  }
}

/// Demonstrate text-to-speech
Future<void> demonstrateTextToSpeech(String apiKey) async {
  print('\n   🔊 Text-to-Speech (ElevenLabs):');

  try {
    // Note: This would require ElevenLabs integration
    final text = 'Hello! This is a demonstration of text-to-speech synthesis.';
    print('      Text: "$text"');
    print('      🔊 Audio generation would be implemented here');
    print('      💡 Use ElevenLabs API for high-quality voice synthesis');
    print('      ✅ Text-to-speech concept demonstrated\n');
  } catch (e) {
    print('      ❌ Text-to-speech failed: $e\n');
  }
}

/// Demonstrate document processing
Future<void> demonstrateDocumentProcessing(String apiKey) async {
  print('📄 Document Processing:\n');

  try {
    // Create provider for document analysis
    final provider = await ai()
        .anthropic()
        .apiKey(apiKey)
        .model('claude-3-5-sonnet-20241022')
        .temperature(0.3)
        .maxTokens(1000)
        .build();

    // Simulate document content
    final documentContent = '''
QUARTERLY BUSINESS REPORT - Q3 2024

Executive Summary:
Our company achieved significant growth in Q3 2024, with revenue increasing by 25% 
compared to the previous quarter. Key highlights include:

- Total Revenue: \$2.5M (up from \$2.0M in Q2)
- New Customer Acquisitions: 150 customers
- Customer Retention Rate: 92%
- Product Development: Launched 2 new features

Challenges:
- Increased competition in the market
- Supply chain delays affecting 15% of orders
- Need for additional technical staff

Recommendations:
1. Invest in marketing to maintain competitive edge
2. Diversify supplier base to reduce delays
3. Hire 5 additional engineers by end of Q4
''';

    print('   Processing business report...');

    final messages = [
      ChatMessage.system(
          'You are a business analyst. Analyze documents and provide insights.'),
      ChatMessage.user(
          'Please analyze this quarterly report and provide key insights:\n\n$documentContent'),
    ];

    final response = await provider.chat(messages);
    print('   🤖 Document Analysis: ${response.text}');

    // Follow-up analysis
    messages.add(ChatMessage.assistant(response.text ?? ''));
    messages.add(ChatMessage.user(
        'What are the top 3 priorities for the next quarter based on this report?'));

    final priorities = await provider.chat(messages);
    print('\n   🎯 Priority Analysis: ${priorities.text}');

    print('   ✅ Document processing successful\n');
  } catch (e) {
    print('   ❌ Document processing failed: $e\n');
  }
}

/// Demonstrate multi-modal conversation
Future<void> demonstrateMultiModalConversation(String apiKey) async {
  print('🔄 Multi-modal Conversation:\n');

  try {
    // Create vision-capable provider
    final provider = await ai()
        .openai()
        .apiKey(apiKey)
        .model('gpt-4o')
        .temperature(0.7)
        .maxTokens(800)
        .build();

    // Start conversation with text
    var messages = [
      ChatMessage.user('I\'m planning a garden. Can you help me choose plants?')
    ];

    var response = await provider.chat(messages);
    print('   User: I\'m planning a garden. Can you help me choose plants?');
    print('   🤖 AI: ${response.text}\n');

    // Add image to conversation
    messages.add(ChatMessage.assistant(response.text ?? ''));
    messages.add(ChatMessage.imageUrl(
      role: ChatRole.user,
      url: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800',
      content:
          'Here\'s a photo of my backyard. What do you think would work well here?',
    ));

    response = await provider.chat(messages);
    print('   User: [Shares backyard photo] What would work well here?');
    print('   🤖 AI: ${response.text}\n');

    // Continue with text-only follow-up
    messages.add(ChatMessage.assistant(response.text ?? ''));
    messages.add(ChatMessage.user(
        'I prefer low-maintenance plants. Any specific recommendations?'));

    response = await provider.chat(messages);
    print(
        '   User: I prefer low-maintenance plants. Any specific recommendations?');
    print('   🤖 AI: ${response.text}');

    print('\n   💡 Multi-modal Conversation Features:');
    print('      • Seamless mixing of text and images');
    print('      • Context maintained across modalities');
    print('      • AI can reference previous images');
    print('      • Natural conversation flow');
    print('   ✅ Multi-modal conversation successful\n');
  } catch (e) {
    print('   ❌ Multi-modal conversation failed: $e\n');
  }
}

/// 🎯 Key Multi-modal Concepts Summary:
///
/// Image Processing:
/// - Vision models (GPT-4o, Claude 3.5 Sonnet)
/// - Image analysis and description
/// - Visual question answering
/// - Image generation (DALL-E)
///
/// Audio Processing:
/// - Speech-to-text (Whisper)
/// - Text-to-speech (OpenAI TTS, ElevenLabs)
/// - Audio analysis and transcription
/// - Voice synthesis and cloning
///
/// Document Processing:
/// - Text extraction and analysis
/// - Document summarization
/// - Content understanding
/// - Structured data extraction
///
/// Multi-modal Conversations:
/// - Mixing text, images, and audio
/// - Context preservation across modalities
/// - Natural interaction patterns
/// - Cross-modal references
///
/// Best Practices:
/// 1. Choose appropriate models for each modality
/// 2. Optimize file sizes for faster processing
/// 3. Handle different media formats gracefully
/// 4. Maintain context across modal switches
/// 5. Implement proper error handling for media
///
/// Technical Considerations:
/// - File size limits and compression
/// - Supported formats and encodings
/// - Processing time and costs
/// - Quality vs speed trade-offs
///
/// Next Steps:
/// - custom_providers.dart: Build custom AI providers
/// - performance_optimization.dart: Optimize for production
/// - ../04_providers/openai/vision_example.dart: OpenAI vision features
