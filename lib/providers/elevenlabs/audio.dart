import 'dart:typed_data';
import 'package:dio/dio.dart';

import '../../core/capability.dart';
import '../../core/llm_error.dart';
import '../../models/audio_models.dart';
import 'client.dart';
import 'config.dart';

/// Word with timing information from ElevenLabs STT
class Word {
  final String text;
  final double start;
  final double end;

  const Word({required this.text, required this.start, required this.end});

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        text: json['text'] as String,
        start: (json['start'] as num?)?.toDouble() ?? 0.0,
        end: (json['end'] as num?)?.toDouble() ?? 0.0,
      );
}

/// ElevenLabs response for TTS
class ElevenLabsTTSResponse {
  final Uint8List audioData;
  final String? contentType;

  const ElevenLabsTTSResponse({required this.audioData, this.contentType});
}

/// ElevenLabs response for STT
class ElevenLabsSTTResponse {
  final String text;
  final String? languageCode;
  final double? languageProbability;
  final List<Word>? words;

  const ElevenLabsSTTResponse({
    required this.text,
    this.languageCode,
    this.languageProbability,
    this.words,
  });

  factory ElevenLabsSTTResponse.fromJson(Map<String, dynamic> json) {
    final wordsJson = json['words'] as List<dynamic>?;
    final words = wordsJson
        ?.map((w) => Word.fromJson(w as Map<String, dynamic>))
        .toList();

    return ElevenLabsSTTResponse(
      text: json['text'] as String? ?? '',
      languageCode: json['language_code'] as String?,
      languageProbability: (json['language_probability'] as num?)?.toDouble(),
      words: words,
    );
  }
}

/// ElevenLabs Audio capability implementation
///
/// This module handles all audio-related functionality for ElevenLabs providers,
/// including text-to-speech and speech-to-text capabilities.
class ElevenLabsAudio
    implements TextToSpeechCapability, SpeechToTextCapability {
  final ElevenLabsClient client;
  final ElevenLabsConfig config;

  ElevenLabsAudio(this.client, this.config);

  // TextToSpeechCapability implementation
  @override
  Future<TTSResponse> textToSpeech(TTSRequest request) async {
    final response = await _textToSpeechInternal(
      request.text,
      voiceId: request.voice,
      model: request.model,
    );

    return TTSResponse(
      audioData: response.audioData,
      contentType: response.contentType,
      voice: request.voice,
      model: request.model,
      // ElevenLabs doesn't provide duration/sample rate in response
      duration: null,
      sampleRate: null,
      usage: null,
    );
  }

  @override
  Future<List<VoiceInfo>> getVoices() async {
    final rawVoices = await _getVoicesRaw();

    return rawVoices.map((voice) {
      return VoiceInfo(
        id: voice['voice_id'] as String? ?? '',
        name: voice['name'] as String? ?? '',
        description: voice['description'] as String?,
        category: voice['category'] as String?,
        gender: voice['labels']?['gender'] as String?,
        accent: voice['labels']?['accent'] as String?,
        previewUrl: voice['preview_url'] as String?,
      );
    }).toList();
  }

  @override
  List<String> getSupportedAudioFormats() {
    return config.supportedAudioFormats;
  }

  // SpeechToTextCapability implementation
  @override
  Future<STTResponse> speechToText(STTRequest request) async {
    late ElevenLabsSTTResponse response;

    if (request.audioData != null) {
      response = await _speechToTextInternal(
        Uint8List.fromList(request.audioData!),
        model: request.model,
      );
    } else if (request.filePath != null) {
      response = await _speechToTextFromFileInternal(
        request.filePath!,
        model: request.model,
      );
    } else {
      throw const InvalidRequestError(
          'Either audioData or filePath must be provided');
    }

    return STTResponse(
      text: response.text,
      language: response.languageCode,
      confidence: response.languageProbability,
      words: response.words
          ?.map((w) => WordTiming(
                word: w.text,
                start: w.start,
                end: w.end,
                confidence:
                    null, // ElevenLabs doesn't provide word-level confidence
              ))
          .toList(),
      model: request.model,
      duration: null,
      usage: null,
    );
  }

  @override
  Future<List<LanguageInfo>> getSupportedLanguages() async {
    // ElevenLabs supports multiple languages but doesn't provide a dynamic API
    // Return commonly supported languages
    return const [
      LanguageInfo(code: 'en', name: 'English', supportsRealtime: true),
      LanguageInfo(code: 'es', name: 'Spanish', supportsRealtime: true),
      LanguageInfo(code: 'fr', name: 'French', supportsRealtime: true),
      LanguageInfo(code: 'de', name: 'German', supportsRealtime: true),
      LanguageInfo(code: 'it', name: 'Italian', supportsRealtime: true),
      LanguageInfo(code: 'pt', name: 'Portuguese', supportsRealtime: true),
      LanguageInfo(code: 'pl', name: 'Polish', supportsRealtime: true),
      LanguageInfo(code: 'tr', name: 'Turkish', supportsRealtime: true),
      LanguageInfo(code: 'ru', name: 'Russian', supportsRealtime: true),
      LanguageInfo(code: 'nl', name: 'Dutch', supportsRealtime: true),
      LanguageInfo(code: 'cs', name: 'Czech', supportsRealtime: true),
      LanguageInfo(code: 'ar', name: 'Arabic', supportsRealtime: true),
      LanguageInfo(code: 'zh', name: 'Chinese', supportsRealtime: true),
      LanguageInfo(code: 'ja', name: 'Japanese', supportsRealtime: true),
      LanguageInfo(code: 'hi', name: 'Hindi', supportsRealtime: true),
      LanguageInfo(code: 'ko', name: 'Korean', supportsRealtime: true),
    ];
  }

  // Convenience methods for backward compatibility
  @override
  Future<List<int>> speech(String text) async {
    final response = await textToSpeech(TTSRequest(text: text));
    return response.audioData;
  }

  @override
  Future<String> transcribe(List<int> audio) async {
    final response = await speechToText(STTRequest.fromAudio(audio));
    return response.text;
  }

  @override
  Future<String> transcribeFile(String filePath) async {
    final response = await speechToText(STTRequest.fromFile(filePath));
    return response.text;
  }

  /// Convert text to speech using ElevenLabs TTS (internal method)
  Future<ElevenLabsTTSResponse> _textToSpeechInternal(
    String text, {
    String? voiceId,
    String? model,
  }) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing ElevenLabs API key');
    }

    final effectiveVoiceId = voiceId ?? config.defaultVoiceId;
    final effectiveModel = model ?? config.defaultTTSModel;

    client.logger.info(
      'Converting text to speech with voice: $effectiveVoiceId, model: $effectiveModel',
    );

    try {
      final requestBody = {
        'text': text,
        'model_id': effectiveModel,
        'voice_settings': config.voiceSettings,
      };

      // Add query parameter for output format
      final audioData = await client.postBinary(
        'text-to-speech/$effectiveVoiceId',
        requestBody,
        queryParams: {'output_format': 'mp3_44100_128'},
      );

      return ElevenLabsTTSResponse(
        audioData: audioData,
        contentType: 'audio/mpeg',
      );
    } catch (e) {
      if (e is LLMError) rethrow;
      throw GenericError('Unexpected error during text-to-speech: $e');
    }
  }

  /// Convert speech to text using ElevenLabs STT (internal method)
  Future<ElevenLabsSTTResponse> _speechToTextInternal(
    Uint8List audioData, {
    String? model,
  }) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing ElevenLabs API key');
    }

    final effectiveModel = model ?? config.defaultSTTModel;

    client.logger.info('Converting speech to text with model: $effectiveModel');

    try {
      // Use 'file' as the field name to match API requirements
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          audioData,
          filename: 'audio.wav',
          contentType: DioMediaType('audio', 'wav'),
        ),
        'model_id': effectiveModel,
      });

      final responseData =
          await client.postFormData('speech-to-text', formData);

      try {
        final sttResponse = ElevenLabsSTTResponse.fromJson(responseData);

        // Extract text from words if available, similar to original implementation
        if (sttResponse.words != null && sttResponse.words!.isNotEmpty) {
          final wordsText = sttResponse.words!.map((w) => w.text).join(' ');
          return ElevenLabsSTTResponse(
            text: wordsText,
            languageCode: sttResponse.languageCode,
            languageProbability: sttResponse.languageProbability,
            words: sttResponse.words,
          );
        }

        return sttResponse;
      } catch (e) {
        throw ResponseFormatError(
          'Failed to parse ElevenLabs STT response: $e',
          responseData.toString(),
        );
      }
    } catch (e) {
      if (e is LLMError) rethrow;
      throw GenericError('Unexpected error during speech-to-text: $e');
    }
  }

  /// Convert speech file to text using ElevenLabs STT (internal method)
  Future<ElevenLabsSTTResponse> _speechToTextFromFileInternal(
    String filePath, {
    String? model,
  }) async {
    if (config.apiKey.isEmpty) {
      throw const AuthError('Missing ElevenLabs API key');
    }

    final effectiveModel = model ?? config.defaultSTTModel;

    client.logger.info(
      'Converting speech file to text: $filePath, model: $effectiveModel',
    );

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'model_id': effectiveModel,
      });

      final responseData =
          await client.postFormData('speech-to-text', formData);

      try {
        final sttResponse = ElevenLabsSTTResponse.fromJson(responseData);

        // Extract text from words if available, similar to original implementation
        if (sttResponse.words != null && sttResponse.words!.isNotEmpty) {
          final wordsText = sttResponse.words!.map((w) => w.text).join(' ');
          return ElevenLabsSTTResponse(
            text: wordsText,
            languageCode: sttResponse.languageCode,
            languageProbability: sttResponse.languageProbability,
            words: sttResponse.words,
          );
        }

        return sttResponse;
      } catch (e) {
        throw ResponseFormatError(
          'Failed to parse ElevenLabs STT response: $e',
          responseData.toString(),
        );
      }
    } catch (e) {
      if (e is LLMError) rethrow;
      throw GenericError(
          'Unexpected error during speech-to-text from file: $e');
    }
  }

  /// Get available voices (internal method)
  Future<List<Map<String, dynamic>>> _getVoicesRaw() async {
    final responseData = await client.getJson('voices');
    final voices = responseData['voices'] as List<dynamic>? ?? [];
    return voices.cast<Map<String, dynamic>>();
  }
}
