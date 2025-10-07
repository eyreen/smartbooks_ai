class CategoryModel {
  final String name;
  final String icon;
  final bool isIncome;

  CategoryModel({
    required this.name,
    required this.icon,
    this.isIncome = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] as String,
      icon: json['icon'] as String,
      isIncome: json['is_income'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'is_income': isIncome,
    };
  }
}

class CategoryStats {
  final String category;
  final double amount;
  final int count;
  final double percentage;

  CategoryStats({
    required this.category,
    required this.amount,
    required this.count,
    required this.percentage,
  });

  factory CategoryStats.fromJson(Map<String, dynamic> json) {
    return CategoryStats(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'count': count,
      'percentage': percentage,
    };
  }
}
