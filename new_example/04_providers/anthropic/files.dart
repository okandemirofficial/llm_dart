import 'dart:typed_data';
import 'package:llm_dart/llm_dart.dart';

/// Example demonstrating Anthropic Files API usage
///
/// This example shows how to:
/// - Upload files to Anthropic
/// - List files in workspace
/// - Get file metadata
/// - Download file content
/// - Delete files
///
/// **Note:** Anthropic Files API is currently in beta and requires
/// the `anthropic-beta: files-api-2025-04-14` header.
void main() async {
  // Create Anthropic provider
  final provider = createAnthropicProvider(
    apiKey: 'your-anthropic-api-key',
    model: 'claude-3-5-sonnet-20241022',
  );

  try {
    // Example 1: Upload a text file
    print('=== Uploading a text file ===');
    final textContent = 'Hello, this is a test file for Anthropic Files API!';
    final textBytes = Uint8List.fromList(textContent.codeUnits);

    final uploadRequest = FileUploadRequest(
      file: textBytes,
      filename: 'test.txt',
    );

    final uploadedFile = await provider.uploadFile(uploadRequest);
    print('Uploaded file: ${uploadedFile.filename}');
    print('File ID: ${uploadedFile.id}');
    print('Size: ${uploadedFile.sizeBytes} bytes');
    print('MIME type: ${uploadedFile.mimeType}');
    print('Created: ${uploadedFile.createdAt}');
    print('Downloadable: ${uploadedFile.downloadable}');

    // Example 2: Upload file from bytes with automatic filename
    print('\n=== Uploading with automatic filename ===');
    final jsonContent = '{"message": "Hello from JSON file"}';
    final jsonBytes = jsonContent.codeUnits;

    final autoFile = await provider.uploadFileFromBytes(
      jsonBytes,
      filename: 'data.json',
    );
    print('Auto-uploaded file: ${autoFile.filename} (${autoFile.id})');

    // Example 3: List all files
    print('\n=== Listing all files ===');
    final fileList = await provider.listFiles();
    print('Total files: ${fileList.data.length}');
    print('Has more: ${fileList.hasMore}');

    for (final file in fileList.data) {
      print('- ${file.filename} (${file.id}) - ${file.sizeBytes} bytes');
    }

    // Example 4: List files with pagination
    print('\n=== Listing files with pagination ===');
    final paginatedQuery = FileListQuery(
      limit: 5,
      // beforeId: 'some-file-id',  // For pagination
      // afterId: 'some-file-id',   // For pagination
    );

    final paginatedList = await provider.listFiles(paginatedQuery);
    print('Paginated results: ${paginatedList.data.length} files');
    if (paginatedList.firstId != null) {
      print('First ID: ${paginatedList.firstId}');
    }
    if (paginatedList.lastId != null) {
      print('Last ID: ${paginatedList.lastId}');
    }

    // Example 5: Get file metadata
    print('\n=== Getting file metadata ===');
    final metadata = await provider.getFileMetadata(uploadedFile.id);
    print('File metadata for ${metadata.filename}:');
    print('- ID: ${metadata.id}');
    print('- Size: ${metadata.sizeBytes} bytes');
    print('- MIME type: ${metadata.mimeType}');
    print('- Created: ${metadata.createdAt}');

    // Example 6: Download file content
    print('\n=== Downloading file content ===');
    final downloadedBytes = await provider.downloadFile(uploadedFile.id);
    final downloadedText = String.fromCharCodes(downloadedBytes);
    print('Downloaded content: $downloadedText');

    // Example 7: Get file content as string (convenience method)
    print('\n=== Getting file content as string ===');
    final contentString =
        await provider.getFileContentAsString(uploadedFile.id);
    print('Content as string: $contentString');

    // Example 8: Check if file exists
    print('\n=== Checking file existence ===');
    final exists = await provider.fileExists(uploadedFile.id);
    print('File exists: $exists');

    final nonExistentExists = await provider.fileExists('non-existent-id');
    print('Non-existent file exists: $nonExistentExists');

    // Example 9: Get total storage used
    print('\n=== Getting total storage usage ===');
    final totalStorage = await provider.getTotalStorageUsed();
    print('Total storage used: $totalStorage bytes');

    // Example 10: Batch delete files
    print('\n=== Batch deleting files ===');
    final fileIds = [uploadedFile.id, autoFile.id];
    final deleteResults = await provider.deleteFiles(fileIds);

    for (final entry in deleteResults.entries) {
      print('Delete ${entry.key}: ${entry.value ? "Success" : "Failed"}');
    }

    // Example 11: Single file deletion
    print('\n=== Single file deletion ===');
    // Upload another file for deletion demo
    final tempFile = await provider.uploadFileFromBytes(
      'Temporary file content'.codeUnits,
      filename: 'temp.txt',
    );

    final deleteResult = await provider.deleteFile(tempFile.id);
    print(
        'Delete ${tempFile.filename}: ${deleteResult.deleted ? "Success" : "Failed"}');

    // Example 12: Using files in chat (conceptual)
    print('\n=== Using files in chat (conceptual) ===');
    print(
        'Note: To use uploaded files in chat, reference them in your messages.');
    print(
        'The exact implementation depends on how Anthropic integrates files with chat.');

    // This would be the general approach:
    // final messages = [
    //   ChatMessage.user('Please analyze the content of file: ${uploadedFile.id}'),
    // ];
    // final response = await provider.chat(messages);
  } catch (e) {
    print('Error: $e');
  }
}

/// Example of error handling with file operations
void demonstrateErrorHandling() async {
  final provider = createAnthropicProvider(
    apiKey: 'your-anthropic-api-key',
    model: 'claude-3-5-sonnet-20241022',
  );

  try {
    // Try to get metadata for non-existent file
    await provider.getFileMetadata('non-existent-file-id');
  } catch (e) {
    print('Expected error for non-existent file: $e');
  }

  try {
    // Try to download non-existent file
    await provider.downloadFile('non-existent-file-id');
  } catch (e) {
    print('Expected error for non-existent download: $e');
  }

  try {
    // Try to delete non-existent file
    final result = await provider.deleteFile('non-existent-file-id');
    print(
        'Delete non-existent file result: ${result.deleted}'); // Should be false
  } catch (e) {
    print('Error deleting non-existent file: $e');
  }
}

/// Example of working with different file types
void demonstrateFileTypes() async {
  final provider = createAnthropicProvider(
    apiKey: 'your-anthropic-api-key',
    model: 'claude-3-5-sonnet-20241022',
  );

  // Text file
  final textFile = await provider.uploadFileFromBytes(
    'This is a plain text file.'.codeUnits,
    filename: 'document.txt',
  );
  print('Text file uploaded: ${textFile.mimeType}');

  // JSON file
  final jsonFile = await provider.uploadFileFromBytes(
    '{"key": "value", "number": 42}'.codeUnits,
    filename: 'data.json',
  );
  print('JSON file uploaded: ${jsonFile.mimeType}');

  // CSV file
  final csvFile = await provider.uploadFileFromBytes(
    'name,age,city\nJohn,30,NYC\nJane,25,LA'.codeUnits,
    filename: 'data.csv',
  );
  print('CSV file uploaded: ${csvFile.mimeType}');

  // Clean up
  await provider.deleteFiles([textFile.id, jsonFile.id, csvFile.id]);
}
