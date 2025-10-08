/// CategoryModel represents a transaction category
/// Categories help organize transactions (e.g., "Food & Dining", "Salary")
class CategoryModel {
  // ============================================
  // FIELDS
  // ============================================

  /// Category name (e.g., "Food & Dining", "Transportation")
  final String name;

  /// Emoji icon for the category (e.g., "🍽️", "🚗")
  final String icon;

  /// Whether this is an income category
  /// true = income category (e.g., "Salary")
  /// false = expense category (e.g., "Food")
  final bool isIncome;

  // ============================================
  // CONSTRUCTOR
  // ============================================

  /// Constructor with default value for isIncome
  CategoryModel({
    required this.name,
    required this.icon,
    this.isIncome = false,  // Defaults to expense category
  });

  // ============================================
  // FACTORY CONSTRUCTOR - From JSON
  // ============================================

  /// Create a CategoryModel from JSON data
  ///
  /// Example JSON:
  /// {
  ///   "name": "Food & Dining",
  ///   "icon": "🍽️",
  ///   "is_income": false
  /// }
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] as String,
      icon: json['icon'] as String,
      // Use ?? operator to default to false if null
      isIncome: json['is_income'] as bool? ?? false,
    );
  }

  // ============================================
  // TO JSON METHOD
  // ============================================

  /// Convert this category to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'is_income': isIncome,
    };
  }
}

/// CategoryStats holds statistical data about a specific category
/// Used in reports and charts to show spending/income breakdown
class CategoryStats {
  // ============================================
  // FIELDS
  // ============================================

  /// Category name
  final String category;

  /// Total amount for this category
  final double amount;

  /// Number of transactions in this category
  final int count;

  /// Percentage of total transactions/amount
  /// (e.g., 25.5 means this category is 25.5% of total)
  final double percentage;

  // ============================================
  // CONSTRUCTOR
  // ============================================

  /// Constructor requiring all fields
  CategoryStats({
    required this.category,
    required this.amount,
    required this.count,
    required this.percentage,
  });

  // ============================================
  // FACTORY CONSTRUCTOR - From JSON
  // ============================================

  /// Create CategoryStats from JSON data
  ///
  /// Example JSON:
  /// {
  ///   "category": "Food & Dining",
  ///   "amount": 450.50,
  ///   "count": 12,
  ///   "percentage": 25.5
  /// }
  factory CategoryStats.fromJson(Map<String, dynamic> json) {
    return CategoryStats(
      category: json['category'] as String,

      // Convert number to double (handles both int and double)
      amount: (json['amount'] as num).toDouble(),

      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  // ============================================
  // TO JSON METHOD
  // ============================================

  /// Convert this stats object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'count': count,
      'percentage': percentage,
    };
  }
}
