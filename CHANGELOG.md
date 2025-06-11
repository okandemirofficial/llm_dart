# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2025-6-11

### Added

- New examples and restructured the example directory for better clarity.
- **Comprehensive Test Suite**: Added extensive test coverage for core functionality
- **UTF-8 Stream Decoder**: Robust handling of multi-byte characters in streaming responses
  - `Utf8StreamDecoder` class for intelligent buffering of incomplete UTF-8 byte sequences
  - Prevents `FormatException: Unfinished UTF-8 octet sequence` errors in streaming

### Fixed

- **UTF-8 Streaming Issues**: Complete resolution of multi-byte character encoding problems
  - Fixed garbled text output (e.g., `ä½ æ` → `你好`) in streaming responses
  - Updated all provider clients (OpenAI, Anthropic, DeepSeek, Groq, Google, xAI, Ollama) to use UTF-8 stream decoder
  - Proper handling of Chinese, Japanese, Korean, Arabic, and emoji characters in streams
  - Eliminated `FormatException: Unfinished UTF-8 octet sequence` errors when multi-byte characters are split across network chunks
- **BaseProviderFactory**: Improved validation logic in `validateConfigWithDetails` method

## [0.4.0] - 2025-6-11

### Added

- **Unified Web Search API**: Provider-agnostic web search functionality across multiple LLM providers
  - `WebSearchConfig` - Universal configuration class supporting all provider-specific parameters
  - `WebSearchLocation` - Geographic location configuration for localized search results
  - `WebSearchType` - Search type enumeration (web, news, academic, combined)
  - `WebSearchStrategy` - Implementation strategy control (native, tool, plugin, parameter, auto)
  - `WebSearchContextSize` - Context size control for providers that support it
  - **Provider Support**:
    - **xAI Grok**: Live Search with `search_parameters` (mode, sources, date filtering, result limits)
    - **Anthropic Claude**: Web Search Tool with domain filtering and location-based search
    - **OpenAI**: Web Search with context size control for `gpt-4o-search-preview` models
    - **OpenRouter**: Plugin-based search with custom prompts and `:online` model shortcuts
    - **Perplexity**: Native search capabilities with context size control
  - **Ergonomic Builder Methods**:
    - `enableWebSearch()` - Simple web search activation
    - `quickWebSearch()` - Fast configuration with common settings
    - `webSearch()` - Advanced configuration with full parameter control
    - `newsSearch()` - News-specific search configuration
    - `searchLocation()` - Geographic context configuration
    - Provider-specific methods: `openaiWebSearch()`, `openRouterWebSearch()`, `perplexityWebSearch()`
    - `advancedWebSearch()` - Full control over all search parameters
  - **Automatic Provider Adaptation**: Same API automatically translates to provider-specific formats
  - **Rich Configuration Options**: Domain filtering, result limits, date ranges, geographic context
  - **Type Safety**: Strong typing with enums and configuration classes
  - **Comprehensive Examples**: Complete demonstration in `02_core_features/web_search.dart`

- **Enhanced LLM Capability System**: Extended capability detection for web search
  - `LLMCapability.liveSearch` - New capability for real-time web search functionality
  - Updated provider capability declarations to include search support
  - Enhanced capability factory methods to support web search providers

- **Capability Factory Methods**: Type-safe provider building with compile-time capability checking
  - `buildAudio()` → `AudioCapability` - Build providers with audio capabilities
  - `buildImageGeneration()` → `ImageGenerationCapability` - Build providers with image generation
  - `buildEmbedding()` → `EmbeddingCapability` - Build providers with embedding capabilities
  - `buildFileManagement()` → `FileManagementCapability` - Build providers with file management
  - `buildModeration()` → `ModerationCapability` - Build providers with moderation capabilities
  - `buildAssistant()` → `AssistantCapability` - Build providers with assistant capabilities
  - `buildModelListing()` → `ModelListingCapability` - Build providers with model listing
  - Eliminates runtime type casting and provides compile-time type safety
  - Clear error messages with `UnsupportedCapabilityError` when capabilities are not supported
  - Better IDE support and autocomplete for capability-specific methods

- **Enhanced Error Handling**: New error types and improved error handling examples
  - `UnsupportedCapabilityError` - Thrown when building providers with unsupported capabilities
  - Updated `error_handling.dart` example to demonstrate capability factory method errors
  - Clear error messages listing supported providers for each capability

- **Core Features Examples**: New capability detection and model listing examples
  - `capability_detection.dart` - Demonstrates provider capability discovery and comparison
  - `model_listing.dart` - Shows how to explore and filter available models from providers
  - `capability_factory_methods.dart` - Comprehensive demonstration of type-safe capability building

### Changed

- **xAI Provider**: Enhanced with comprehensive Live Search support
  - Updated `XAIConfig` to include `liveSearch` boolean parameter for simple activation
  - Enhanced `SearchParameters` class with factory methods and better documentation
  - Improved `_buildSearchParameters()` method with automatic default configuration
  - Added `isLiveSearchEnabled` getter for configuration validation
  - Updated provider capabilities to include `LLMCapability.liveSearch`
  - Enhanced factory methods and convenience functions to support Live Search

- **LLM Builder**: Significantly improved web search ergonomics
  - Replaced provider-specific search methods with unified, ergonomic API
  - Added comprehensive web search configuration methods with clear documentation
  - Improved method naming for better developer experience
  - Enhanced parameter validation and type safety
  - Better integration with provider-specific implementations

- **Core Features Examples**: Enhanced with web search demonstration
  - Added `web_search.dart` to core features examples
  - Updated `02_core_features/README.md` with web search documentation
  - Comprehensive examples showing unified API across all supported providers
  - Step-by-step learning path including web search integration

- **Provider Examples**: Updated to use new capability factory methods
  - `elevenlabs/audio_capabilities.dart` - Now uses `buildAudio()` for type-safe audio provider building
  - `openai/image_generation.dart` - Now uses `buildImageGeneration()` for type-safe image provider building
  - Demonstrates migration from runtime type casting to compile-time type safety

### Fixed

- **Provider Capabilities**: Standardized capability interface implementations across all providers
- **Legacy Methods Cleanup**: Removed outdated capability checking methods
  - Removed `supportedCapabilitiesLegacy` (string-based capability lists)
  - Removed `supportsCapability(String)` methods across all providers
  - Unified capability checking through `ProviderCapabilities` interface

## [0.3.0] - 2025-6-10

### Changed

- **Web Platform Support**: Removed `dart:io` dependency to enable Web and WASM compatibility
  - Removed `uploadFileFromPath()` method from OpenAI Files API
  - Removed `filePath` property from `ImageInput` class for cross-platform compatibility
  - Enables WASM compatibility for future Dart Web applications
  - Use `uploadFile()` or `uploadFileFromBytes()` methods instead for cross-platform file uploads
  - Use `ImageInput.fromBytes()` or `ImageInput.fromUrl()` instead of file path-based image inputs

## [0.2.0] - 2025-6-10

### Added

- **Anthropic Files API**: Complete file management support
  - Upload, list, retrieve, and delete files
  - Support for MIME types and downloadable flags
  - Cursor-based pagination with `beforeId`, `afterId`, and `limit`
  - Convenience methods: `uploadFileFromBytes()`, `fileExists()`, `getFileContentAsString()`
  - Batch operations: `deleteFiles()`, `getTotalStorageUsed()`
  - Beta API header support (`anthropic-beta: files-api-2025-04-14`)

- **File Management API**: Cross-provider file operations
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

- **Unified Audio Capability Interface**: Revolutionary audio processing design
  - Single `AudioCapability` interface for all audio operations (TTS, STT, translation)
  - Feature discovery system with `supportedFeatures` property for runtime capability detection
  - `BaseAudioCapability` class providing default implementations for convenience methods
  - Support for streaming TTS, real-time audio sessions, and advanced audio features
  - Enhanced audio models with character-level timing, speaker diarization, and audio events
  - Graceful degradation with `UnsupportedError` for unsupported features
  - Cross-provider audio functionality comparison and benchmarking support

- **DALL-E Image Generation Support**: Complete OpenAI image API implementation
  - Image generation, editing, and variations with DALL-E 2/3
  - Enhanced `ImageGenerationCapability` interface with new methods
  - Support for multiple formats, sizes, and quality options

### Changed

- **All Providers**: Refactored to modular architecture
  - OpenAI, Anthropic, DeepSeek, Groq, xAI, Phind, ElevenLabs providers now use modular design
  - Consistent file structure across all providers
  - Improved separation of concerns (config, client, capabilities)
  - Better error handling and logging

- **Ollama Provider**: Enhanced implementation with full API compliance
  - Fixed temperature parameter handling (was incorrectly excluded)
  - Added complete Ollama-specific parameter support (`numCtx`, `numGpu`, `numThread`, `numa`, `numBatch`, `keepAlive`, `raw`)
  - Enhanced multimodal support with automatic base64 image conversion
  - Improved message type handling and tool calling support
  - Added LLMBuilder convenience methods for Ollama-specific parameters
  - Full compatibility with official Ollama API specification

- **Streaming Configuration**: Removed stream parameters from configs
  - Stream behavior now controlled at method call time (`chat()` vs `chatStream()`)
  - Simplified configuration classes by removing redundant stream parameters
  - More intuitive API design for streaming operations

- **Factory Classes**: Enhanced with full configuration support
  - All factory methods now support complete provider configurations
  - Removed redundant helper methods in favor of base factory functionality
  - Better parameter validation and error handling

- **Audio Capabilities**: Completely redesigned audio processing architecture
  - Replaced separate `TextToSpeechCapability` and `SpeechToTextCapability` interfaces
  - Unified all audio operations under single `AudioCapability` interface
  - Enhanced audio models with advanced features (timing, diarization, events)
  - Improved OpenAI audio support with translation capabilities
  - Enhanced ElevenLabs audio support with streaming and real-time features
  - Better error handling and feature detection for audio operations

- **Image Generation**: Enhanced OpenAI provider with complete DALL-E support
  - Extended `ImageGenerationCapability` interface with editing and variation methods
  - Updated multi-modal examples with real image generation implementations

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

- **Audio Capabilities**: Migrate to unified audio interface
  - Replace `TextToSpeechCapability` and `SpeechToTextCapability` checks with `AudioCapability`
  - Use `provider.supportedFeatures.contains(AudioFeature.textToSpeech)` for feature detection
  - Audio translation now available through `translateAudio()` method (OpenAI only)
  - Enhanced audio models support advanced features like character timing and speaker diarization
  - Convenience methods (`speech()`, `transcribe()`, `translate()`) automatically available

- **Image Generation**: Enhanced capabilities with new features
  - New `editImage()` and `createVariation()` methods available for DALL-E 2
  - Use `provider.supportsImageEditing` and `provider.supportsImageVariations` for feature detection

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
