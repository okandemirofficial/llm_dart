// ignore_for_file: avoid_print
import 'dart:io';
import 'package:llm_dart/llm_dart.dart';

/// 🎵 ElevenLabs Basic Usage - Getting Started with Voice Synthesis
///
/// This example demonstrates the fundamental usage of ElevenLabs:
/// - Voice generation and configuration
/// - Speech-to-text capabilities
/// - Voice selection and settings
/// - Best practices for voice synthesis
///
/// Before running, set your API key:
/// export ELEVENLABS_API_KEY="your-elevenlabs-api-key"
void main() async {
  print('🎵 ElevenLabs Basic Usage - Getting Started\n');

  // Get API key
  final apiKey = Platform.environment['ELEVENLABS_API_KEY'] ?? 'your-api-key';

  // Demonstrate different ElevenLabs usage patterns
  await demonstrateVoiceSelection(apiKey);
  await demonstrateTextToSpeech(apiKey);
  await demonstrateSpeechToText(apiKey);
  await demonstrateConfigurationOptions(apiKey);
  await demonstrateBestPractices(apiKey);

  print('\n✅ ElevenLabs basic usage completed!');
  print('📖 Next: Try voice_cloning.dart for advanced voice capabilities');
}

/// Demonstrate voice selection
Future<void> demonstrateVoiceSelection(String apiKey) async {
  print('🎭 Voice Selection:\n');

  try {
    final provider = await ai()
        .elevenlabs()
        .apiKey(apiKey)
        .model('eleven_multilingual_v2')
        .build() as ElevenLabsProvider;

    // Get available voices
    print('   Getting available voices...');
    final voices = await provider.getVoices();

    print('   Available voices (first 5):');
    for (final voice in voices.take(5)) {
      print('      • ${voice.name} (${voice.id})');
      if (voice.description != null) {
        print('        Description: ${voice.description}');
      }
      if (voice.category != null) {
        print('        Category: ${voice.category}');
      }
      print('');
    }

    if (voices.length > 5) {
      print('   ... and ${voices.length - 5} more voices available');
    }

    print('   💡 Voice Selection Tips:');
    print('      • Choose voices that match your content tone');
    print('      • Consider language and accent requirements');
    print('      • Test different voices for your use case');
    print('   ✅ Voice selection demonstration completed\n');
  } catch (e) {
    print('   ❌ Voice selection failed: $e\n');
  }
}

/// Demonstrate text-to-speech functionality
Future<void> demonstrateTextToSpeech(String apiKey) async {
  print('🔊 Text-to-Speech:\n');

  try {
    // Create ElevenLabs provider with optimized settings
    final provider = await ai()
        .elevenlabs()
        .apiKey(apiKey)
        .model('eleven_multilingual_v2')
        .voiceId('JBFqnCBsd6RMkjVDRZzb') // George voice
        .stability(0.7)
        .similarityBoost(0.9)
        .style(0.1)
        .useSpeakerBoost(true)
        .build() as ElevenLabsProvider;

    // Test different text types
    final testTexts = [
      'Hello! Welcome to ElevenLabs voice synthesis.',
      'This is a demonstration of high-quality text-to-speech conversion.',
      'The quick brown fox jumps over the lazy dog.',
    ];

    for (int i = 0; i < testTexts.length; i++) {
      final text = testTexts[i];
      print('   Converting text ${i + 1}: "$text"');

      final ttsRequest = TTSRequest(
        text: text,
        voice: 'JBFqnCBsd6RMkjVDRZzb',
        model: 'eleven_multilingual_v2',
        format: 'mp3_44100_128',
      );

      final response = await provider.textToSpeech(ttsRequest);

      // Save audio file
      final filename = 'elevenlabs_test_${i + 1}.mp3';
      await File(filename).writeAsBytes(response.audioData);

      print(
          '      ✅ Generated: $filename (${response.audioData.length} bytes)');
      print('      Voice: ${response.voice ?? 'default'}');
      print('      Model: ${response.model ?? 'default'}');
      print('');
    }

    print('   💡 TTS Tips:');
    print('      • Use punctuation for natural pauses');
    print('      • Adjust stability for consistency');
    print('      • Higher similarity boost for voice accuracy');
    print('   ✅ Text-to-speech demonstration completed\n');
  } catch (e) {
    print('   ❌ Text-to-speech failed: $e\n');
  }
}

/// Demonstrate speech-to-text functionality
Future<void> demonstrateSpeechToText(String apiKey) async {
  print('🎤 Speech-to-Text:\n');

  try {
    final provider =
        await ai().elevenlabs().apiKey(apiKey).build() as ElevenLabsProvider;

    // Check if we have audio files to transcribe
    final audioFiles = ['elevenlabs_test_1.mp3', 'elevenlabs_test_2.mp3'];

    for (final audioFile in audioFiles) {
      final file = File(audioFile);
      if (await file.exists()) {
        print('   Transcribing: $audioFile');

        final sttRequest = STTRequest.fromFile(
          audioFile,
          model: 'scribe_v1',
          includeWordTiming: true,
          includeConfidence: true,
        );

        final response = await provider.speechToText(sttRequest);

        print('      ✅ Transcription: "${response.text}"');
        print('      Language: ${response.language ?? 'auto-detected'}');
        print(
            '      Confidence: ${response.confidence?.toStringAsFixed(2) ?? 'N/A'}');

        // Show word timing if available
        if (response.words != null && response.words!.isNotEmpty) {
          print('      Word timing (first 3 words):');
          for (final word in response.words!.take(3)) {
            print(
                '        "${word.word}" (${word.start.toStringAsFixed(1)}s - ${word.end.toStringAsFixed(1)}s)');
          }
        }
        print('');
      }
    }

    // Demonstrate transcription from bytes
    final testFile = File('elevenlabs_test_1.mp3');
    if (await testFile.exists()) {
      print('   Transcribing from audio bytes...');

      final audioBytes = await testFile.readAsBytes();
      final sttRequest = STTRequest.fromAudio(
        audioBytes,
        model: 'scribe_v1_experimental',
      );

      final response = await provider.speechToText(sttRequest);
      print('      ✅ Bytes transcription: "${response.text}"');
    }

    print('   💡 STT Tips:');
    print('      • Use high-quality audio for better accuracy');
    print('      • Enable word timing for detailed analysis');
    print('      • Choose appropriate model for your needs');
    print('   ✅ Speech-to-text demonstration completed\n');
  } catch (e) {
    print('   ❌ Speech-to-text failed: $e\n');
  }
}

/// Demonstrate configuration options
Future<void> demonstrateConfigurationOptions(String apiKey) async {
  print('⚙️  Configuration Options:\n');

  // Test different voice settings
  print('   Voice Settings Comparison:');
  final settings = [
    {
      'name': 'High Stability',
      'stability': 0.9,
      'similarity': 0.5,
      'style': 0.0
    },
    {'name': 'Balanced', 'stability': 0.7, 'similarity': 0.7, 'style': 0.3},
    {'name': 'Expressive', 'stability': 0.3, 'similarity': 0.9, 'style': 0.7},
  ];

  const testText = 'This is a test of different voice settings.';

  for (final setting in settings) {
    try {
      final provider = await ai()
          .elevenlabs()
          .apiKey(apiKey)
          .model('eleven_multilingual_v2')
          .voiceId('JBFqnCBsd6RMkjVDRZzb')
          .stability(setting['stability'] as double)
          .similarityBoost(setting['similarity'] as double)
          .style(setting['style'] as double)
          .build() as ElevenLabsProvider;

      final ttsRequest = TTSRequest(
        text: testText,
        voice: 'JBFqnCBsd6RMkjVDRZzb',
        model: 'eleven_multilingual_v2',
      );

      final response = await provider.textToSpeech(ttsRequest);
      final filename =
          'test_${(setting['name'] as String).toLowerCase().replaceAll(' ', '_')}.mp3';
      await File(filename).writeAsBytes(response.audioData);

      print(
          '      ✅ ${setting['name']}: $filename (${response.audioData.length} bytes)');
    } catch (e) {
      print('      ❌ ${setting['name']}: $e');
    }
  }

  // Test different formats
  print('\n   Audio Format Options:');
  try {
    final provider = await ai()
        .elevenlabs()
        .apiKey(apiKey)
        .model('eleven_multilingual_v2')
        .voiceId('JBFqnCBsd6RMkjVDRZzb')
        .build() as ElevenLabsProvider;

    final formats = provider.getSupportedAudioFormats();
    print('      Supported formats: ${formats.join(', ')}');

    // Test a few formats
    final testFormats = ['mp3_44100_128', 'wav', 'ogg_opus'];
    for (final format in testFormats) {
      if (formats.contains(format)) {
        final ttsRequest = TTSRequest(
          text: 'Format test',
          voice: 'JBFqnCBsd6RMkjVDRZzb',
          model: 'eleven_multilingual_v2',
          format: format,
        );

        final response = await provider.textToSpeech(ttsRequest);
        print('      ✅ $format: ${response.audioData.length} bytes');
      }
    }
  } catch (e) {
    print('      ❌ Format testing failed: $e');
  }

  print('\n   💡 Configuration Guide:');
  print('      • Stability: Higher = more consistent, Lower = more varied');
  print('      • Similarity: Higher = closer to original voice');
  print('      • Style: Higher = more expressive and emotional');
  print('      • Speaker boost: Enhances voice clarity');
  print('   ✅ Configuration demonstration completed\n');
}

/// Demonstrate best practices
Future<void> demonstrateBestPractices(String apiKey) async {
  print('🏆 Best Practices:\n');

  // Error handling
  print('   Error Handling:');
  try {
    final provider = await ai()
        .elevenlabs()
        .apiKey('invalid-key') // Intentionally invalid
        .build();

    await (provider as ElevenLabsProvider).speech('Test');
  } on AuthError catch (e) {
    print('      ✅ Properly caught AuthError: ${e.message}');
  } catch (e) {
    print('      ⚠️  Unexpected error type: $e');
  }

  // Convenience methods
  print('\n   Convenience Methods:');
  try {
    final provider = await ai()
        .elevenlabs()
        .apiKey(apiKey)
        .model('eleven_multilingual_v2')
        .voiceId('JBFqnCBsd6RMkjVDRZzb')
        .build() as ElevenLabsProvider;

    // Use convenience speech method
    const testText = 'Testing convenience methods.';
    final audioBytes = await provider.speech(testText);
    print('      ✅ Convenience TTS: ${audioBytes.length} bytes');

    // Save and test convenience transcribe
    const convenienceFile = 'convenience_test.mp3';
    await File(convenienceFile).writeAsBytes(audioBytes);

    final transcription = await provider.transcribeFile(convenienceFile);
    print('      ✅ Convenience STT: "$transcription"');

    // Clean up
    await File(convenienceFile).delete();
  } catch (e) {
    print('      ⚠️  Convenience methods issue: $e');
  }

  // Performance optimization
  print('\n   Performance Optimization:');
  final optimizationTips = [
    'Use appropriate audio formats for your use case',
    'Batch multiple TTS requests when possible',
    'Cache frequently used audio files',
    'Monitor API usage and costs',
    'Choose voice settings based on content type'
  ];

  for (final tip in optimizationTips) {
    print('      • $tip');
  }

  print('\n   💡 Best Practices Summary:');
  print('      • Choose appropriate voices for your content');
  print('      • Optimize settings for quality vs speed');
  print('      • Use convenience methods for simple tasks');
  print('      • Implement proper error handling');
  print('      • Monitor usage and costs');
  print('      • Cache audio when appropriate');
  print('   ✅ Best practices demonstration completed\n');
}

/// 🎯 Key ElevenLabs Concepts Summary:
///
/// Voice Synthesis:
/// - High-quality, natural-sounding voices
/// - Emotional expression and style control
/// - Multiple languages and accents
/// - Custom voice cloning capabilities
///
/// Speech Recognition:
/// - Accurate transcription with confidence scores
/// - Word-level timing information
/// - Multiple audio format support
/// - Language detection and identification
///
/// Configuration Parameters:
/// - stability: Voice consistency (0.0-1.0)
/// - similarity_boost: Voice accuracy (0.0-1.0)
/// - style: Emotional expression (0.0-1.0)
/// - speaker_boost: Voice clarity enhancement
///
/// Best Use Cases:
/// - Voice assistants and chatbots
/// - Content creation and narration
/// - Accessibility applications
/// - Multi-language applications
/// - Professional voice production
///
/// Next Steps:
/// - voice_cloning.dart: Custom voice creation
/// - multi_language.dart: International voices
/// - speech_to_text.dart: Advanced transcription
