import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../core/chat_provider.dart';
import '../../core/llm_error.dart';
import '../../models/file_models.dart';
import 'client.dart';
import 'config.dart';

/// OpenAI File Management capability implementation
///
/// This module handles file upload, listing, retrieval, and deletion
/// for OpenAI providers.
class OpenAIFiles implements FileManagementCapability {
  final OpenAIClient client;
  final OpenAIConfig config;

  OpenAIFiles(this.client, this.config);

  @override
  Future<OpenAIFile> uploadFile(CreateFileRequest request) async {
    final formData = FormData();

    formData.files.add(
      MapEntry(
        'file',
        MultipartFile.fromBytes(
          request.file,
          filename: request.filename,
        ),
      ),
    );

    formData.fields.add(MapEntry('purpose', request.purpose.value));

    final responseData = await client.postForm('files', formData);
    return OpenAIFile.fromJson(responseData);
  }

  @override
  Future<ListFilesResponse> listFiles([ListFilesQuery? query]) async {
    String endpoint = 'files';

    if (query != null) {
      final queryParams = <String, String>{};
      if (query.purpose != null) queryParams['purpose'] = query.purpose!.value;
      if (query.limit != null) queryParams['limit'] = query.limit.toString();
      if (query.order != null) queryParams['order'] = query.order!;
      if (query.after != null) queryParams['after'] = query.after!;

      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }
    }

    final responseData = await client.get(endpoint);
    return ListFilesResponse.fromJson(responseData);
  }

  @override
  Future<OpenAIFile> retrieveFile(String fileId) async {
    final responseData = await client.get('files/$fileId');
    return OpenAIFile.fromJson(responseData);
  }

  @override
  Future<DeleteFileResponse> deleteFile(String fileId) async {
    final responseData = await client.delete('files/$fileId');
    return DeleteFileResponse.fromJson(responseData);
  }

  @override
  Future<List<int>> getFileContent(String fileId) async {
    return await client.getRaw('files/$fileId/content');
  }

  /// Get file content as string
  Future<String> getFileContentAsString(String fileId) async {
    final bytes = await getFileContent(fileId);
    return String.fromCharCodes(bytes);
  }

  /// Check if a file exists
  Future<bool> fileExists(String fileId) async {
    try {
      await retrieveFile(fileId);
      return true;
    } catch (e) {
      if (e is ResponseFormatError && e.message.contains('404')) {
        return false;
      }
      rethrow;
    }
  }

  /// Get file size in bytes
  Future<int?> getFileSize(String fileId) async {
    try {
      final file = await retrieveFile(fileId);
      return file.bytes;
    } catch (e) {
      return null;
    }
  }

  /// List files by purpose
  Future<List<OpenAIFile>> listFilesByPurpose(FilePurpose purpose) async {
    final response = await listFiles(ListFilesQuery(purpose: purpose));
    return response.data;
  }

  /// Upload file from bytes with automatic filename
  Future<OpenAIFile> uploadFileFromBytes(
    List<int> bytes,
    FilePurpose purpose, {
    String? filename,
  }) async {
    return uploadFile(CreateFileRequest(
      file: Uint8List.fromList(bytes),
      purpose: purpose,
      filename: filename ?? 'file_${DateTime.now().millisecondsSinceEpoch}',
    ));
  }

  /// Upload file from path
  Future<OpenAIFile> uploadFileFromPath(
    String filePath,
    FilePurpose purpose, {
    String? filename,
  }) async {
    final fileBytes = await File(filePath).readAsBytes();
    return uploadFile(CreateFileRequest(
      file: fileBytes,
      purpose: purpose,
      filename: filename ?? filePath.split('/').last,
    ));
  }

  /// Batch delete files
  Future<List<DeleteFileResponse>> deleteFiles(List<String> fileIds) async {
    final results = <DeleteFileResponse>[];

    for (final fileId in fileIds) {
      try {
        final result = await deleteFile(fileId);
        results.add(result);
      } catch (e) {
        // Continue with other files even if one fails
        results.add(DeleteFileResponse(
          id: fileId,
          object: 'file',
          deleted: false,
        ));
      }
    }

    return results;
  }

  /// Get total storage used
  Future<int> getTotalStorageUsed() async {
    final response = await listFiles();
    return response.data
        .map((file) => file.bytes)
        .fold<int>(0, (sum, bytes) => sum + bytes);
  }

  /// Clean up old files (older than specified days)
  Future<List<DeleteFileResponse>> cleanupOldFiles(int olderThanDays) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: olderThanDays));
    final response = await listFiles();

    final oldFiles = response.data.where((file) {
      final fileDate =
          DateTime.fromMillisecondsSinceEpoch(file.createdAt * 1000);
      return fileDate.isBefore(cutoffDate);
    }).toList();

    if (oldFiles.isEmpty) {
      return [];
    }

    return await deleteFiles(oldFiles.map((f) => f.id).toList());
  }
}
