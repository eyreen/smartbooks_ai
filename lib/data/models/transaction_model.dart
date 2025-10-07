import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime date;
  final String? description;
  final String? documentId;
  final bool isAiGenerated;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.description,
    this.documentId,
    this.isAiGenerated = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.create({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required TransactionType type,
    required DateTime date,
    String? description,
    String? documentId,
    bool isAiGenerated = false,
  }) {
    final now = DateTime.now();
    return TransactionModel(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      amount: amount,
      category: category,
      type: type,
      date: date,
      description: description,
      documentId: documentId,
      isAiGenerated: isAiGenerated,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      documentId: json['document_id'] as String?,
      isAiGenerated: json['is_ai_generated'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'type': type.name,
      'date': date.toIso8601String(),
      'description': description,
      'document_id': documentId,
      'is_ai_generated': isAiGenerated,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    String? category,
    TransactionType? type,
    DateTime? date,
    String? description,
    String? documentId,
    bool? isAiGenerated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
      description: description ?? this.description,
      documentId: documentId ?? this.documentId,
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
}
