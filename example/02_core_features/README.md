# 🟡 Core Features

Master the essential functionality of LLM Dart. These examples cover the most important features you'll use in real applications.

## 📚 Learning Path

### Step 1: Master Basic Chat (10 minutes)
**[chat_basics.dart](chat_basics.dart)** - Foundation of all AI interactions
- Simple conversations
- Message history management
- Response handling
- Usage statistics

### Step 2: Real-time Streaming (15 minutes)
**[streaming_chat.dart](streaming_chat.dart)** - Live response streaming
- Stream events handling
- Real-time UI updates
- Performance optimization
- Error recovery

### Step 3: Tool Integration (20 minutes)
**[tool_calling.dart](tool_calling.dart)** - Function calling and execution
- Define custom functions
- Handle tool calls
- Multi-step workflows
- Error handling in tools

### Step 4: Structured Data (15 minutes)
**[structured_output.dart](structured_output.dart)** - JSON and schema output
- JSON schema definition
- Data validation
- Type-safe responses
- Complex data structures

### Step 5: Production Ready (10 minutes)
**[error_handling.dart](error_handling.dart)** - Robust error management
- Error types and handling
- Retry strategies
- Graceful degradation
- Monitoring and logging

## 🎯 What You'll Master

After completing these examples, you'll be able to:

- ✅ Build conversational AI applications
- ✅ Create real-time streaming interfaces
- ✅ Integrate AI with external tools and APIs
- ✅ Handle structured data and validation
- ✅ Build production-ready error handling

## 🚀 Running Examples

```bash
# Set your preferred provider's API key
export OPENAI_API_KEY="your-key"
export GROQ_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"

# Run examples in order
dart run chat_basics.dart
dart run streaming_chat.dart
dart run tool_calling.dart
dart run structured_output.dart
dart run error_handling.dart
```

## 💡 Key Concepts

### Chat Basics
- **Messages**: User, assistant, and system messages
- **Context**: Maintaining conversation history
- **Responses**: Text, usage statistics, and metadata

### Streaming
- **Events**: Text deltas, tool calls, completion events
- **Performance**: Reduced perceived latency
- **UX**: Real-time feedback for users

### Tool Calling
- **Functions**: Define what the AI can do
- **Parameters**: Structured input validation
- **Execution**: Safe function calling
- **Results**: Feeding results back to AI

### Structured Output
- **Schemas**: JSON schema definitions
- **Validation**: Automatic data validation
- **Types**: Type-safe data handling
- **Complex Data**: Nested objects and arrays

### Error Handling
- **Types**: Authentication, rate limits, network errors
- **Recovery**: Retry logic and fallbacks
- **Monitoring**: Logging and alerting
- **UX**: Graceful error messages

## 📖 Next Steps

After mastering core features:

1. **[Advanced Features](../03_advanced_features/)** - Reasoning, multi-modal, custom providers
2. **[Use Cases](../05_use_cases/)** - Real-world application examples
3. **[Provider Specific](../04_providers/)** - Deep dive into specific providers
4. **[Integration](../06_integration/)** - Flutter, web, CLI integration

## 🔗 Related Examples

- **Beginner**: [Getting Started](../01_getting_started/) - Basic setup and provider comparison
- **Advanced**: [Reasoning Models](../03_advanced_features/reasoning_models.dart) - AI thinking processes
- **Real-world**: [Chatbot](../05_use_cases/chatbot.dart) - Complete chatbot implementation

---

**💡 Tip**: These core features form the foundation of most AI applications. Master them before moving to advanced topics!
