// Import UUID package for generating unique IDs
import 'package:uuid/uuid.dart';

/// Enum defining the two types of transactions
/// Enums provide type-safe constants - can only be one of these values
enum TransactionType {
  income,   // Money coming in
  expense   // Money going out
}

/// TransactionModel represents a financial transaction in the app
/// This is a data model (pure data, no UI logic)
/// It stores information about income or expense transactions
class TransactionModel {
  // ============================================
  // FIELDS - All transaction properties
  // Using 'final' makes these fields immutable (can't change after creation)
  // ============================================

  /// Unique identifier for this transaction
  final String id;

  /// ID of the user who owns this transaction
  final String userId;

  /// Transaction title/name (e.g., "Grocery Shopping", "Salary")
  final String title;

  /// Transaction amount in dollars
  final double amount;

  /// Category this transaction belongs to
  /// (e.g., "Food & Dining", "Salary")
  final String category;

  /// Type of transaction (income or expense)
  final TransactionType type;

  /// Date when the transaction occurred
  final DateTime date;

  /// Optional notes/description about the transaction
  /// The ? means this can be null
  final String? description;

  /// Optional ID linking to a scanned document (receipt/invoice)
  final String? documentId;

  /// Whether this transaction was created by AI (from receipt scanning)
  final bool isAiGenerated;

  /// When this transaction record was first created
  final DateTime createdAt;

  /// When this transaction record was last modified
  final DateTime updatedAt;

  // ============================================
  // DEFAULT CONSTRUCTOR
  // ============================================

  /// Constructor requires all non-null fields
  /// Optional fields (description, documentId) can be omitted
  TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.description,              // Optional
    this.documentId,               // Optional
    this.isAiGenerated = false,    // Default value
    required this.createdAt,
    required this.updatedAt,
  });

  // ============================================
  // FACTORY CONSTRUCTOR - Create new transaction
  // ============================================

  /// Factory constructor to create a new transaction
  /// Automatically generates ID and timestamps
  /// Use this when creating a transaction from user input
  ///
  /// Example:
  /// final transaction = TransactionModel.create(
  ///   userId: 'user123',
  ///   title: 'Coffee',
  ///   amount: 4.50,
  ///   category: 'Food & Dining',
  ///   type: TransactionType.expense,
  ///   date: DateTime.now(),
  /// );
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
    // Get current time for timestamps
    final now = DateTime.now();

    // Create and return a new TransactionModel
    return TransactionModel(
      id: const Uuid().v4(),    // Generate random UUID (e.g., "550e8400-e29b-41d4-a716-446655440000")
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

  // ============================================
  // FACTORY CONSTRUCTOR - From JSON
  // ============================================

  /// Create a TransactionModel from JSON data
  /// Used when loading transactions from database or API
  ///
  /// Example JSON:
  /// {
  ///   "id": "123",
  ///   "user_id": "user456",
  ///   "title": "Lunch",
  ///   "amount": 15.50,
  ///   "category": "Food & Dining",
  ///   "type": "expense",
  ///   "date": "2024-01-15T12:00:00Z"
  /// }
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      // Cast each JSON value to the correct type
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,

      // Convert numeric value to double (handles both int and double)
      amount: (json['amount'] as num).toDouble(),

      category: json['category'] as String,

      // Find the matching enum value by name
      // 'firstWhere' searches for matching enum
      // 'orElse' provides fallback if no match found
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,  // Default to expense if invalid
      ),

      // Parse ISO 8601 date string to DateTime
      date: DateTime.parse(json['date'] as String),

      // Optional fields with null safety
      description: json['description'] as String?,
      documentId: json['document_id'] as String?,

      // Use ?? (null-coalescing operator) to provide default if null
      isAiGenerated: json['is_ai_generated'] as bool? ?? false,

      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // ============================================
  // TO JSON METHOD
  // ============================================

  /// Convert this TransactionModel to JSON format
  /// Used when saving transactions to database or API
  ///
  /// Returns a Map that can be converted to JSON string
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'type': type.name,                       // Convert enum to string
      'date': date.toIso8601String(),         // Convert DateTime to ISO string
      'description': description,
      'document_id': documentId,
      'is_ai_generated': isAiGenerated,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ============================================
  // COPY WITH METHOD
  // ============================================

  /// Create a copy of this transaction with some fields changed
  /// Since all fields are final, we can't modify them directly
  /// Instead, we create a new instance with updated values
  ///
  /// Example:
  /// final updated = transaction.copyWith(
  ///   amount: 25.00,           // Change amount
  ///   updatedAt: DateTime.now(), // Update timestamp
  /// );
  /// // All other fields remain the same
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
      // Use provided value if not null (?? means "if null, use original value")
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

  // ============================================
  // GETTER METHODS - Computed properties
  // ============================================

  /// Check if this is an income transaction
  /// Returns true if type is income, false otherwise
  bool get isIncome => type == TransactionType.income;

  /// Check if this is an expense transaction
  /// Returns true if type is expense, false otherwise
  bool get isExpense => type == TransactionType.expense;
}
