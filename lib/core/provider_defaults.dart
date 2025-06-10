import 'capability.dart';

/// Centralized provider default configurations
///
/// This file contains all default endpoints, models, and capabilities
/// for all supported providers to eliminate configuration duplication
/// and ensure consistency across the library.
class ProviderDefaults {
  // Core OpenAI
  static const String openaiBaseUrl = 'https://api.openai.com/v1/';
  static const String openaiDefaultModel = 'gpt-4o';

  // Anthropic
  static const String anthropicBaseUrl = 'https://api.anthropic.com/v1/';
  static const String anthropicDefaultModel = 'claude-3-5-sonnet-20241022';

  // Google (Gemini)
  static const String googleBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/';
  static const String googleDefaultModel = 'gemini-1.5-flash';

  // DeepSeek
  static const String deepseekBaseUrl = 'https://api.deepseek.com/v1/';
  static const String deepseekDefaultModel = 'deepseek-chat';

  // Groq
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1/';
  static const String groqDefaultModel = 'llama-3.3-70b-versatile';

  // xAI
  static const String xaiBaseUrl = 'https://api.x.ai/v1/';
  static const String xaiDefaultModel = 'grok-2-latest';

  // Phind
  static const String phindBaseUrl = 'https://api.phind.com/v1/';
  static const String phindDefaultModel = 'Phind-70B';

  // ElevenLabs
  static const String elevenLabsBaseUrl = 'https://api.elevenlabs.io/v1/';
  static const String elevenLabsDefaultVoiceId = 'JBFqnCBsd6RMkjVDRZzb';
  static const String elevenLabsDefaultTTSModel = 'eleven_monolingual_v1';
  static const String elevenLabsDefaultSTTModel = 'eleven_multilingual_v2';

  // Ollama
  static const String ollamaBaseUrl = 'http://localhost:11434';
  static const String ollamaDefaultModel = 'llama3.2';

  // OpenAI-compatible providers
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1/';
  static const String openRouterDefaultModel = 'openai/gpt-4';

  static const String azureOpenAIApiVersion = '2024-02-15-preview';

  static const String githubCopilotBaseUrl =
      'https://api.githubcopilot.com/chat/completions';
  static const String githubCopilotDefaultModel = 'gpt-4';

  static const String togetherAIBaseUrl = 'https://api.together.xyz/v1/';
  static const String togetherAIDefaultModel = 'meta-llama/Llama-3-70b-chat-hf';

  /// Get default configuration for a provider
  static Map<String, dynamic> getDefaults(String providerId) {
    switch (providerId) {
      case 'openai':
        return {
          'baseUrl': openaiBaseUrl,
          'model': openaiDefaultModel,
        };
      case 'anthropic':
        return {
          'baseUrl': anthropicBaseUrl,
          'model': anthropicDefaultModel,
        };
      case 'google':
        return {
          'baseUrl': googleBaseUrl,
          'model': googleDefaultModel,
        };
      case 'deepseek':
        return {
          'baseUrl': deepseekBaseUrl,
          'model': deepseekDefaultModel,
        };
      case 'groq':
        return {
          'baseUrl': groqBaseUrl,
          'model': groqDefaultModel,
        };
      case 'xai':
        return {
          'baseUrl': xaiBaseUrl,
          'model': xaiDefaultModel,
        };
      case 'phind':
        return {
          'baseUrl': phindBaseUrl,
          'model': phindDefaultModel,
        };
      case 'elevenlabs':
        return {
          'baseUrl': elevenLabsBaseUrl,
          'voiceId': elevenLabsDefaultVoiceId,
          'model': elevenLabsDefaultTTSModel,
        };
      case 'ollama':
        return {
          'baseUrl': ollamaBaseUrl,
          'model': ollamaDefaultModel,
        };
      default:
        throw ArgumentError('Unknown provider: $providerId');
    }
  }

  /// Get supported capabilities for a provider
  static Set<LLMCapability> getCapabilities(String providerId) {
    switch (providerId) {
      case 'openai':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.embedding,
          LLMCapability.modelListing,
          LLMCapability.toolCalling,
          LLMCapability.reasoning,
          LLMCapability.vision,
          LLMCapability.textToSpeech,
          LLMCapability.speechToText,
          LLMCapability.imageGeneration,
        };
      case 'anthropic':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.toolCalling,
          LLMCapability.reasoning,
          LLMCapability.vision,
        };
      case 'google':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.toolCalling,
          LLMCapability.reasoning,
          LLMCapability.vision,
          LLMCapability.imageGeneration,
        };
      case 'deepseek':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.toolCalling,
          LLMCapability.reasoning,
        };
      case 'groq':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.toolCalling,
        };
      case 'xai':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.toolCalling,
          LLMCapability.reasoning,
          LLMCapability.embedding,
        };
      case 'phind':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.toolCalling,
        };
      case 'elevenlabs':
        return {
          LLMCapability.textToSpeech,
          LLMCapability.speechToText,
        };
      case 'ollama':
        return {
          LLMCapability.chat,
          LLMCapability.streaming,
          LLMCapability.embedding,
          LLMCapability.modelListing,
        };
      default:
        return <LLMCapability>{};
    }
  }
}

/// OpenAI-compatible provider configurations
class OpenAICompatibleDefaults {
  /// DeepSeek using OpenAI-compatible API
  static const Map<String, dynamic> deepseek = {
    'providerId': 'deepseek-openai',
    'displayName': 'DeepSeek (OpenAI-compatible)',
    'description': 'DeepSeek AI models using OpenAI-compatible interface',
    'baseUrl': ProviderDefaults.deepseekBaseUrl,
    'model': ProviderDefaults.deepseekDefaultModel,
    'capabilities': {
      LLMCapability.chat,
      LLMCapability.streaming,
      LLMCapability.toolCalling,
      LLMCapability.reasoning,
    },
  };

  /// Groq using OpenAI-compatible API
  static const Map<String, dynamic> groq = {
    'providerId': 'groq-openai',
    'displayName': 'Groq (OpenAI-compatible)',
    'description':
        'Groq AI models using OpenAI-compatible interface for ultra-fast inference',
    'baseUrl': ProviderDefaults.groqBaseUrl,
    'model': ProviderDefaults.groqDefaultModel,
    'capabilities': {
      LLMCapability.chat,
      LLMCapability.streaming,
      LLMCapability.toolCalling,
    },
  };

  /// xAI using OpenAI-compatible API
  static const Map<String, dynamic> xai = {
    'providerId': 'xai-openai',
    'displayName': 'xAI Grok (OpenAI-compatible)',
    'description': 'xAI Grok models using OpenAI-compatible interface',
    'baseUrl': ProviderDefaults.xaiBaseUrl,
    'model': ProviderDefaults.xaiDefaultModel,
    'capabilities': {
      LLMCapability.chat,
      LLMCapability.streaming,
      LLMCapability.toolCalling,
      LLMCapability.reasoning,
    },
  };

  /// Phind using OpenAI-compatible API
  static const Map<String, dynamic> phind = {
    'providerId': 'phind-openai',
    'displayName': 'Phind (OpenAI-compatible)',
    'description': 'Phind AI models using OpenAI-compatible interface',
    'baseUrl': ProviderDefaults.phindBaseUrl,
    'model': ProviderDefaults.phindDefaultModel,
    'capabilities': {
      LLMCapability.chat,
      LLMCapability.streaming,
      LLMCapability.toolCalling,
    },
  };

  /// OpenRouter configuration
  static const Map<String, dynamic> openRouter = {
    'providerId': 'openrouter',
    'displayName': 'OpenRouter',
    'description': 'OpenRouter unified API for multiple AI models',
    'baseUrl': ProviderDefaults.openRouterBaseUrl,
    'model': ProviderDefaults.openRouterDefaultModel,
    'capabilities': {
      LLMCapability.chat,
      LLMCapability.streaming,
      LLMCapability.toolCalling,
      LLMCapability.vision,
    },
  };

  /// GitHub Copilot configuration
  static const Map<String, dynamic> githubCopilot = {
    'providerId': 'github-copilot',
    'displayName': 'GitHub Copilot',
    'description': 'GitHub Copilot Chat API',
    'baseUrl': ProviderDefaults.githubCopilotBaseUrl,
    'model': ProviderDefaults.githubCopilotDefaultModel,
    'capabilities': {
      LLMCapability.chat,
      LLMCapability.streaming,
      LLMCapability.toolCalling,
    },
  };

  /// Together AI configuration
  static const Map<String, dynamic> togetherAI = {
    'providerId': 'together-ai',
    'displayName': 'Together AI',
    'description': 'Together AI platform for open source models',
    'baseUrl': ProviderDefaults.togetherAIBaseUrl,
    'model': ProviderDefaults.togetherAIDefaultModel,
    'capabilities': {
      LLMCapability.chat,
      LLMCapability.streaming,
      LLMCapability.toolCalling,
    },
  };

  /// Get all OpenAI-compatible configurations
  static List<Map<String, dynamic>> getAllConfigs() {
    return [
      deepseek,
      groq,
      xai,
      phind,
      openRouter,
      githubCopilot,
      togetherAI,
    ];
  }

  /// Get configuration by provider ID
  static Map<String, dynamic>? getConfig(String providerId) {
    switch (providerId) {
      case 'deepseek-openai':
        return deepseek;
      case 'groq-openai':
        return groq;
      case 'xai-openai':
        return xai;
      case 'phind-openai':
        return phind;
      case 'openrouter':
        return openRouter;
      case 'github-copilot':
        return githubCopilot;
      case 'together-ai':
        return togetherAI;
      default:
        return null;
    }
  }
}
