/// Test runner for all llm_dart tests
///
/// This file imports and runs all test suites in the project.
/// Run with: dart test test/test_all.dart
library;

import 'package:test/test.dart';

// Core tests
import 'core/capability_test.dart' as capability_tests;
import 'core/config_test.dart' as config_tests;
import 'core/error_test.dart' as error_tests;
import 'core/registry_test.dart' as registry_tests;

// Model tests
import 'models/chat_models_test.dart' as chat_models_tests;
import 'models/tool_models_test.dart' as tool_models_tests;
import 'models/audio_models_test.dart' as audio_models_tests;

// Builder tests
import 'builder/llm_builder_test.dart' as builder_tests;
import 'builder/http_config_test.dart' as http_config_tests;

// Utils tests
import 'utils/utf8_stream_decoder_test.dart' as utf8_decoder_tests;
import 'utils/http_config_utils_test.dart' as http_config_utils_tests;
import 'utils/timeout_priority_test.dart' as timeout_priority_tests;
import 'utils/dio_proxy_test.dart' as dio_proxy_tests;

// Integration tests
import 'integration/thinking_content_extraction_test.dart'
    as thinking_extraction_tests;
import 'integration/thinking_tags_streaming_test.dart'
    as thinking_streaming_tests;
import 'integration/utf8_streaming_test.dart' as utf8_streaming_tests;
import 'integration/http_configuration_integration_test.dart'
    as http_integration_tests;

// Provider tests
import 'providers/factories/base_factory_test.dart' as factory_tests;

// Provider-specific tests
import 'providers/anthropic/anthropic_provider_test.dart'
    as anthropic_provider_tests;
import 'providers/anthropic/anthropic_config_test.dart'
    as anthropic_config_tests;
import 'providers/anthropic/anthropic_factory_test.dart'
    as anthropic_factory_tests;
import 'providers/deepseek/deepseek_provider_test.dart'
    as deepseek_provider_tests;
import 'providers/deepseek/deepseek_config_test.dart' as deepseek_config_tests;
import 'providers/deepseek/deepseek_factory_test.dart'
    as deepseek_factory_tests;

// Existing tests
import 'providers/openai/openai_advanced_test.dart' as openai_advanced_tests;

void main() {
  group('LLM Dart Library Tests', () {
    group('Core System Tests', () {
      capability_tests.main();
      config_tests.main();
      error_tests.main();
      registry_tests.main();
    });

    group('Model Tests', () {
      chat_models_tests.main();
      tool_models_tests.main();
      audio_models_tests.main();
    });

    group('Builder Tests', () {
      builder_tests.main();
      http_config_tests.main();
    });

    group('Utils Tests', () {
      utf8_decoder_tests.main();
      http_config_utils_tests.main();
      timeout_priority_tests.main();
      dio_proxy_tests.main();
    });

    group('Integration Tests', () {
      thinking_extraction_tests.main();
      thinking_streaming_tests.main();
      utf8_streaming_tests.main();
      http_integration_tests.main();
    });

    group('Provider Tests', () {
      factory_tests.main();
      openai_advanced_tests.main();

      // Anthropic provider tests
      anthropic_provider_tests.main();
      anthropic_config_tests.main();
      anthropic_factory_tests.main();

      // DeepSeek provider tests
      deepseek_provider_tests.main();
      deepseek_config_tests.main();
      deepseek_factory_tests.main();
    });
  });
}
