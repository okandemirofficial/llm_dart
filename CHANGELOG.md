# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - Not yet released (WIP)

### Added

- **Anthropic Files API**: Complete file management support
  - Upload, list, retrieve, and delete files
  - Support for MIME types and downloadable flags
  - Cursor-based pagination with `beforeId`, `afterId`, and `limit`
  - Convenience methods: `uploadFileFromBytes()`, `fileExists()`, `getFileContentAsString()`
  - Batch operations: `deleteFiles()`, `getTotalStorageUsed()`
  - Beta API header support (`anthropic-beta: files-api-2025-04-14`)

- **Unified File Management API**: Cross-provider file operations
  - `FileManagementCapability` interface for consistent file operations
  - Universal `FileObject`, `FileUploadRequest`, `FileListResponse` models
  - Support for both OpenAI and Anthropic file formats with automatic conversion
  - Unified `FilePurpose` and `FileStatus` enums
  - Provider-agnostic file operations with format adaptation

- **Provider Configuration Centralization**: Extracted default configurations
  - New `ProviderDefaults` class with all provider endpoints and models
  - `OpenAICompatibleDefaults` for OpenAI-compatible provider configurations
  - Centralized capability definitions for all providers
  - Eliminated configuration duplication across factory classes

### Changed

- **All Providers**: Refactored to modular architecture
  - OpenAI, Anthropic, DeepSeek, Groq, xAI, Phind, ElevenLabs providers now use modular design
  - Consistent file structure across all providers
  - Improved separation of concerns (config, client, capabilities)
  - Better error handling and logging

- **Streaming Configuration**: Removed stream parameters from configs
  - Stream behavior now controlled at method call time (`chat()` vs `chatStream()`)
  - Simplified configuration classes by removing redundant stream parameters
  - More intuitive API design for streaming operations

- **Factory Classes**: Enhanced with full configuration support
  - All factory methods now support complete provider configurations
  - Removed redundant helper methods in favor of base factory functionality
  - Better parameter validation and error handling

### Removed

- **OpenAI Compatible Provider**: Removed `OpenAICompatibleProvider` class
  - Functionality replaced by convenience functions in modular implementation
  - `createDeepSeekProvider()`, `createGroqProvider()`, etc. provide same functionality
  - Simplified architecture with better performance

- **Legacy Provider Files**: Cleaned up deprecated implementations
  - Removed old provider files after modular refactoring
  - Eliminated duplicate code and inconsistent implementations
  - Streamlined provider architecture

- **Stream Configuration Parameters**: Removed from all provider configs
  - `stream` parameter removed from configuration classes
  - Streaming behavior now determined by method choice
  - Cleaner separation between configuration and runtime behavior

### Migration Guide

- **Streaming**: Update streaming usage pattern
  - Replace `config.stream = true` with direct method calls
  - Use `provider.chatStream()` instead of `provider.chat()` with stream config
  - More explicit and intuitive streaming control

- **File Management**: Use unified file API for cross-provider compatibility
  - OpenAI file operations remain unchanged
  - Anthropic now supports file operations through `FileManagementCapability`
  - Use universal file models for provider-agnostic code

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
