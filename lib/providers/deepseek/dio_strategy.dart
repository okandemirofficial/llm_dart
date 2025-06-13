import '../../utils/config_utils.dart';
import '../../utils/dio_client_factory.dart';
import 'config.dart';

/// DeepSeek-specific Dio strategy implementation
///
/// Uses OpenAI-compatible authentication (Bearer token).
class DeepSeekDioStrategy extends BaseProviderDioStrategy {
  @override
  String get providerName => 'DeepSeek';

  @override
  Map<String, String> buildHeaders(dynamic config) {
    final deepSeekConfig = config as DeepSeekConfig;
    return ConfigUtils.buildOpenAIHeaders(deepSeekConfig.apiKey);
  }
}
