import 'package:uuid/uuid.dart';

enum DocumentType { receipt, invoice, other }

class DocumentModel {
  final String id;
  final String userId;
  final String fileName;
  final String fileUrl;
  final DocumentType type;
  final String? extractedText;
  final Map<String, dynamic>? extractedData;
  final bool isProcessed;
  final DateTime uploadedAt;
  final DateTime? processedAt;

  DocumentModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.fileUrl,
    required this.type,
    this.extractedText,
    this.extractedData,
    this.isProcessed = false,
    required this.uploadedAt,
    this.processedAt,
  });

  factory DocumentModel.create({
    required String userId,
    required String fileName,
    required String fileUrl,
    required DocumentType type,
  }) {
    return DocumentModel(
      id: const Uuid().v4(),
      userId: userId,
      fileName: fileName,
      fileUrl: fileUrl,
      type: type,
      uploadedAt: DateTime.now(),
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      type: DocumentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DocumentType.other,
      ),
      extractedText: json['extracted_text'] as String?,
      extractedData: json['extracted_data'] as Map<String, dynamic>?,
      isProcessed: json['is_processed'] as bool? ?? false,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      processedAt: json['processed_at'] != null
          ? DateTime.parse(json['processed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'file_name': fileName,
      'file_url': fileUrl,
      'type': type.name,
      'extracted_text': extractedText,
      'extracted_data': extractedData,
      'is_processed': isProcessed,
      'uploaded_at': uploadedAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }

  DocumentModel copyWith({
    String? id,
    String? userId,
    String? fileName,
    String? fileUrl,
    DocumentType? type,
    String? extractedText,
    Map<String, dynamic>? extractedData,
    bool? isProcessed,
    DateTime? uploadedAt,
    DateTime? processedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      type: type ?? this.type,
      extractedText: extractedText ?? this.extractedText,
      extractedData: extractedData ?? this.extractedData,
      isProcessed: isProcessed ?? this.isProcessed,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }
}
