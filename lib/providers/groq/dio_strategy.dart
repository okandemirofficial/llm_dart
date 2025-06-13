import '../../utils/config_utils.dart';
import '../../utils/dio_client_factory.dart';
import 'config.dart';

/// Groq-specific Dio strategy implementation
///
/// Uses OpenAI-compatible authentication (Bearer token).
class GroqDioStrategy extends BaseProviderDioStrategy {
  @override
  String get providerName => 'Groq';

  @override
  Map<String, String> buildHeaders(dynamic config) {
    final groqConfig = config as GroqConfig;
    return ConfigUtils.buildOpenAIHeaders(groqConfig.apiKey);
  }
}
