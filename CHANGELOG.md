# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - Not yet released (WIP)

### Changed

- **OpenAI Provider**: Replaced with new modular implementation
  - Renamed `ModularOpenAIProvider` to `OpenAIProvider` (now the default)
  - Replaced old monolithic `OpenAIProvider` with modular architecture
  - Better maintainability and testing capabilities
  - Improved error handling and type safety
  - Full backward compatibility maintained
  - All existing APIs continue to work unchanged

### Removed

- **OpenAI Compatible Provider**: Removed `OpenAICompatibleProvider` class
  - Functionality replaced by convenience functions in modular implementation
  - `createDeepSeekProvider()`, `createGroqProvider()`, etc. provide same functionality
  - Simplified architecture with better performance

### Migration Guide

- **OpenAI Provider**: No code changes required for basic usage
  - All existing `OpenAIProvider` usage continues to work
  - Configuration classes renamed: `ModularOpenAIConfig` → `OpenAIConfig`
  - Factory classes updated to use full configuration support

## [0.1.2] - 2025-6-8

### Fixed

- **Package Configuration**: Updated pubspec.yaml repository URLs
  - Fixed homepage, repository, and issue_tracker URLs to point to correct standalone repository
  - Ensures proper package metadata on pub.dev for the independent library

## [0.1.1] - 2025-6-8

### Changed

- **Documentation**: Updated README.md to reflect standalone library status
  - Added pub.dev package badge and link (<https://pub.dev/packages/llm_dart>)
  - Simplified installation instructions (removed unnecessary dio dependency mention)

## [0.1.0] - 2025-6-8

### Added

- Initial release of LLM Dart library
- Multi-provider support for AI interactions
- Unified interface for OpenAI, Anthropic, Google, DeepSeek, Ollama, xAI, Phind, Groq, and ElevenLabs
- Builder pattern API for easy configuration
- Streaming support for real-time responses
- Tool calling capabilities for function execution
- Structured output with JSON schema support
- Comprehensive error handling with specific error types
- Provider registry system for extensibility
- Capability-based design for type safety

#### Supported Providers

- **OpenAI**: GPT models with reasoning support
- **Anthropic**: Claude models with thinking capabilities
- **Google**: Gemini models
- **DeepSeek**: DeepSeek reasoning models
- **Ollama**: Local model support
- **xAI**: Grok models
- **Phind**: Phind models
- **Groq**: Fast inference
- **ElevenLabs**: Text-to-Speech and Speech-to-Text

#### Features

- Chat completion with multiple providers
- Real-time streaming responses
- Function/tool calling
- Structured JSON output
- Provider-specific extensions
- Custom provider registration
- Comprehensive examples and documentation

#### Examples

- Basic usage examples for all providers
- Streaming examples
- Tool calling examples
- Custom provider implementation
- Advanced configuration examples
- ElevenLabs TTS/STT examples

### Technical Details

- Built with Dart 3.0+ support
- Flutter 3.8+ compatibility
- Uses Dio for HTTP requests
- Comprehensive error handling
- Type-safe interfaces
- Modular architecture

### Documentation

- Complete API documentation
- Extensive examples directory
- Setup and configuration guides
- Best practices documentation
- Provider-specific guides
