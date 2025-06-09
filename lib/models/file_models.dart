import 'dart:convert';
import 'dart:typed_data';

/// File purpose enumeration for OpenAI Files API
enum FilePurpose {
  /// For fine-tuning jobs
  fineTune('fine-tune'),

  /// For assistants
  assistants('assistants'),

  /// For vision tasks
  vision('vision'),

  /// For batch processing
  batch('batch'),

  /// For user data
  userData('user_data');

  const FilePurpose(this.value);
  final String value;

  static FilePurpose fromString(String value) {
    switch (value) {
      case 'fine-tune':
        return FilePurpose.fineTune;
      case 'assistants':
        return FilePurpose.assistants;
      case 'vision':
        return FilePurpose.vision;
      case 'batch':
        return FilePurpose.batch;
      case 'user_data':
        return FilePurpose.userData;
      default:
        throw ArgumentError('Unknown file purpose: $value');
    }
  }
}

/// File status enumeration
enum FileStatus {
  uploaded('uploaded'),
  processed('processed'),
  error('error');

  const FileStatus(this.value);
  final String value;

  static FileStatus fromString(String value) {
    switch (value) {
      case 'uploaded':
        return FileStatus.uploaded;
      case 'processed':
        return FileStatus.processed;
      case 'error':
        return FileStatus.error;
      default:
        throw ArgumentError('Unknown file status: $value');
    }
  }
}

/// Represents a file object from OpenAI Files API
class OpenAIFile {
  /// The file identifier, which can be referenced in the API endpoints.
  final String id;

  /// The size of the file, in bytes.
  final int bytes;

  /// The Unix timestamp (in seconds) for when the file was created.
  final int createdAt;

  /// The name of the file.
  final String filename;

  /// The object type, which is always "file".
  final String object;

  /// The intended purpose of the file.
  final FilePurpose purpose;

  /// The current status of the file, which can be either uploaded, processed, or error.
  final FileStatus? status;

  /// Additional details about the status of the file.
  final String? statusDetails;

  const OpenAIFile({
    required this.id,
    required this.bytes,
    required this.createdAt,
    required this.filename,
    this.object = 'file',
    required this.purpose,
    this.status,
    this.statusDetails,
  });

  factory OpenAIFile.fromJson(Map<String, dynamic> json) {
    return OpenAIFile(
      id: json['id'] as String,
      bytes: json['bytes'] as int,
      createdAt: json['created_at'] as int,
      filename: json['filename'] as String,
      object: json['object'] as String? ?? 'file',
      purpose: FilePurpose.fromString(json['purpose'] as String),
      status: json['status'] != null
          ? FileStatus.fromString(json['status'] as String)
          : null,
      statusDetails: json['status_details'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bytes': bytes,
      'created_at': createdAt,
      'filename': filename,
      'object': object,
      'purpose': purpose.value,
      if (status != null) 'status': status!.value,
      if (statusDetails != null) 'status_details': statusDetails,
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenAIFile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Request for creating a file
class CreateFileRequest {
  /// The file to upload.
  final Uint8List file;

  /// The name of the file to upload.
  final String filename;

  /// The intended purpose of the uploaded file.
  final FilePurpose purpose;

  const CreateFileRequest({
    required this.file,
    required this.filename,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'purpose': purpose.value,
    };
  }
}

/// Response for listing files
class ListFilesResponse {
  /// The list of files.
  final List<OpenAIFile> data;

  /// The object type, which is always "list".
  final String object;

  const ListFilesResponse({
    required this.data,
    this.object = 'list',
  });

  factory ListFilesResponse.fromJson(Map<String, dynamic> json) {
    return ListFilesResponse(
      data: (json['data'] as List)
          .map((item) => OpenAIFile.fromJson(item as Map<String, dynamic>))
          .toList(),
      object: json['object'] as String? ?? 'list',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((file) => file.toJson()).toList(),
      'object': object,
    };
  }
}

/// Response for deleting a file
class DeleteFileResponse {
  /// The file identifier.
  final String id;

  /// The object type, which is always "file".
  final String object;

  /// Whether the file was successfully deleted.
  final bool deleted;

  const DeleteFileResponse({
    required this.id,
    this.object = 'file',
    required this.deleted,
  });

  factory DeleteFileResponse.fromJson(Map<String, dynamic> json) {
    return DeleteFileResponse(
      id: json['id'] as String,
      object: json['object'] as String? ?? 'file',
      deleted: json['deleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'deleted': deleted,
    };
  }
}

/// Query parameters for listing files
class ListFilesQuery {
  /// Only return files with the given purpose.
  final FilePurpose? purpose;

  /// A limit on the number of objects to be returned.
  final int? limit;

  /// Sort order by the created_at timestamp of the objects.
  final String? order;

  /// A cursor for use in pagination.
  final String? after;

  const ListFilesQuery({
    this.purpose,
    this.limit,
    this.order,
    this.after,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (purpose != null) params['purpose'] = purpose!.value;
    if (limit != null) params['limit'] = limit;
    if (order != null) params['order'] = order;
    if (after != null) params['after'] = after;

    return params;
  }
}
