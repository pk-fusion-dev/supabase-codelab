
class FileModel {
  final String name;
  final String id;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime lastAccessedAt;
  final Metadata metadata;

  FileModel({
    required this.name,
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.lastAccessedAt,
    required this.metadata,
  });

  // Factory method to create an instance from JSON
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      name: json['name'] as String,
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastAccessedAt: DateTime.parse(json['last_accessed_at'] as String),
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'last_accessed_at': lastAccessedAt.toIso8601String(),
      'metadata': metadata.toJson(),
    };
  }
}

class Metadata {
  final String eTag;
  final int size;
  final String mimetype;
  final String cacheControl;
  final DateTime lastModified;
  final int contentLength;
  final int httpStatusCode;

  Metadata({
    required this.eTag,
    required this.size,
    required this.mimetype,
    required this.cacheControl,
    required this.lastModified,
    required this.contentLength,
    required this.httpStatusCode,
  });

  // Factory method to create an instance from JSON
  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      eTag: json['eTag'] as String,
      size: json['size'] as int,
      mimetype: json['mimetype'] as String,
      cacheControl: json['cacheControl'] as String,
      lastModified: DateTime.parse(json['lastModified'] as String),
      contentLength: json['contentLength'] as int,
      httpStatusCode: json['httpStatusCode'] as int,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'eTag': eTag,
      'size': size,
      'mimetype': mimetype,
      'cacheControl': cacheControl,
      'lastModified': lastModified.toIso8601String(),
      'contentLength': contentLength,
      'httpStatusCode': httpStatusCode,
    };
  }
}
