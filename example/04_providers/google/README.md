# Google Provider Examples

这个目录包含了Google (Gemini) provider的具体使用示例，展示了Google特有的功能和最佳实践。

## 📁 文件结构

- `embeddings.dart` - Google文本嵌入模型使用示例

## 🔢 Embeddings (文本嵌入)

Google提供高质量的文本嵌入模型，通过Gemini API访问。

### 支持的模型

- `text-embedding-004` - 最新的嵌入模型，支持多种任务类型
- `text-embedding-003` - 之前版本的嵌入模型

### 基本用法

```dart
import 'package:llm_dart/llm_dart.dart';

// 创建嵌入provider
final provider = await ai()
    .google()
    .apiKey('your-google-api-key')
    .model('text-embedding-004')
    .buildEmbedding();

// 生成嵌入
final embeddings = await provider.embed([
  'Hello, world!',
  'This is a test sentence.',
]);

print('Generated ${embeddings.length} embeddings');
print('Dimensions: ${embeddings.first.length}');
```

### Google特有的参数

Google嵌入API支持多种任务特定的参数：

#### 任务类型 (Task Type)

```dart
final provider = await ai()
    .google((google) => google
        .embeddingTaskType('SEMANTIC_SIMILARITY'))
    .apiKey(apiKey)
    .model('text-embedding-004')
    .buildEmbedding();
```

支持的任务类型：
- `SEMANTIC_SIMILARITY` - 语义相似性计算
- `RETRIEVAL_QUERY` - 检索查询
- `RETRIEVAL_DOCUMENT` - 检索文档
- `CLASSIFICATION` - 分类任务
- `CLUSTERING` - 聚类任务
- `QUESTION_ANSWERING` - 问答任务
- `FACT_VERIFICATION` - 事实验证
- `CODE_RETRIEVAL_QUERY` - 代码检索查询

#### 文档标题 (仅用于RETRIEVAL_DOCUMENT)

```dart
final provider = await ai()
    .google((google) => google
        .embeddingTaskType('RETRIEVAL_DOCUMENT')
        .embeddingTitle('Technical Documentation'))
    .apiKey(apiKey)
    .model('text-embedding-004')
    .buildEmbedding();
```

#### 输出维度

```dart
final provider = await ai()
    .google((google) => google
        .embeddingDimensions(512))  // 减少维度
    .apiKey(apiKey)
    .model('text-embedding-004')
    .buildEmbedding();
```

### 便利工厂函数

```dart
// 使用默认设置创建嵌入provider
final provider = createGoogleEmbeddingProvider(
  apiKey: 'your-api-key',
);

// 使用自定义参数和Google配置
final customProvider = await ai()
    .google((google) => google
        .embeddingTaskType('SEMANTIC_SIMILARITY')
        .embeddingDimensions(768))
    .apiKey('your-api-key')
    .model('text-embedding-004')
    .buildEmbedding();
```

### 批量处理

Google API自动处理单个和批量请求：

```dart
// 单个文本 - 使用embedContent端点
final singleEmbedding = await provider.embed(['Single text']);

// 多个文本 - 使用batchEmbedContents端点
final batchEmbeddings = await provider.embed([
  'First text',
  'Second text',
  'Third text',
]);
```

### 语义搜索示例

```dart
// 文档库
final documents = [
  'Machine learning algorithms learn from data',
  'Deep learning uses neural networks',
  'Natural language processing handles text',
];

// 创建文档嵌入
final docEmbeddings = await provider.embed(documents);

// 搜索查询
final queryEmbedding = await provider.embed(['neural networks']);

// 计算相似度并排序
final similarities = <double>[];
for (final docEmb in docEmbeddings) {
  final similarity = cosineSimilarity(queryEmbedding.first, docEmb);
  similarities.add(similarity);
}

// 找到最相似的文档
final bestMatch = similarities.indexOf(similarities.reduce(math.max));
print('Best match: ${documents[bestMatch]}');
```

### 错误处理

```dart
try {
  final embeddings = await provider.embed(['test text']);
  print('Success: ${embeddings.length} embeddings generated');
} on AuthError catch (e) {
  print('Authentication failed: ${e.message}');
} on ResponseFormatError catch (e) {
  print('Invalid response format: ${e.message}');
} on LLMError catch (e) {
  print('LLM error: ${e.message}');
}
```

### 最佳实践

1. **选择合适的任务类型**：根据你的用例选择最合适的`embeddingTaskType`
2. **批量处理**：对于多个文本，一次性处理比逐个处理更高效
3. **维度优化**：如果不需要全维度，可以使用`embeddingDimensions`减少维度
4. **文档标题**：对于检索任务，提供文档标题可以提高嵌入质量
5. **错误处理**：始终包含适当的错误处理逻辑

### 性能考虑

- Google的嵌入API支持批量处理，可以显著提高吞吐量
- `text-embedding-004`是最新模型，提供最佳质量
- 考虑使用缓存来避免重复计算相同文本的嵌入

## 🔗 相关链接

- [Google AI Embeddings API文档](https://ai.google.dev/api/embeddings)
- [Gemini API参考](https://ai.google.dev/api)
- [核心功能示例](../../02_core_features/embeddings.dart)

## 📖 下一步

尝试运行示例：

```bash
dart run example/04_providers/google/embeddings.dart
```

探索其他功能：
- [语义搜索](../../03_advanced_features/semantic_search.dart)
- [核心功能](../../02_core_features/)
