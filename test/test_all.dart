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

// Provider tests
import 'providers/factories/base_factory_test.dart' as factory_tests;

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
    });

    group('Provider Tests', () {
      factory_tests.main();
      openai_advanced_tests.main();
    });
  });
}
