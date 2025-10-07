import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';

class AiInsightsService {
  static AiInsightsService? _instance;
  static AiInsightsService get instance => _instance ??= AiInsightsService._();

  AiInsightsService._();

  /// Generate spending insights from transaction data
  Future<Map<String, dynamic>> generateSpendingInsights({
    required List<TransactionModel> transactions,
    required Map<String, double> categoryStats,
  }) async {
    try {
      final totalIncome = transactions
          .where((t) => t.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount);
      final totalExpense = transactions
          .where((t) => t.isExpense)
          .fold(0.0, (sum, t) => sum + t.amount);

      final prompt = '''
Analyze this financial data and provide insights:

Total Income: \$${totalIncome.toStringAsFixed(2)}
Total Expenses: \$${totalExpense.toStringAsFixed(2)}
Balance: \$${(totalIncome - totalExpense).toStringAsFixed(2)}

Spending by Category:
${categoryStats.entries.map((e) => '- ${e.key}: \$${e.value.toStringAsFixed(2)}').join('\n')}

Number of Transactions: ${transactions.length}

Please provide:
1. 3-5 key insights about spending patterns
2. Potential areas for savings
3. Financial health assessment (Good/Concerning/Critical)

Return as JSON:
{
  "insights": ["insight1", "insight2", ...],
  "savings_tips": ["tip1", "tip2", ...],
  "health_status": "Good/Concerning/Critical",
  "health_message": "brief message"
}
''';

      final response = await _sendRequest(prompt);
      return _safeParseJson(response, {
        'insights': ['Unable to generate insights at this time'],
        'savings_tips': ['Review your spending regularly'],
        'health_status': 'Unknown',
        'health_message': 'Analysis unavailable',
      });
    } catch (e) {
      debugPrint('Error generating insights: $e');
      return {
        'insights': ['Unable to generate insights at this time'],
        'savings_tips': ['Review your spending regularly'],
        'health_status': 'Unknown',
        'health_message': 'Analysis unavailable',
      };
    }
  }

  /// Predict future spending based on historical data
  Future<Map<String, dynamic>> predictFutureSpending({
    required List<TransactionModel> transactions,
  }) async {
    try {
      // Calculate monthly averages
      final monthlyExpenses = <String, double>{};
      for (var transaction in transactions.where((t) => t.isExpense)) {
        final monthKey =
            '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
        monthlyExpenses[monthKey] =
            (monthlyExpenses[monthKey] ?? 0) + transaction.amount;
      }

      final averageMonthly = monthlyExpenses.isEmpty
          ? 0.0
          : monthlyExpenses.values.reduce((a, b) => a + b) /
              monthlyExpenses.length;

      final prompt = '''
Based on this spending history, predict next month's expenses:

Average Monthly Spending: \$${averageMonthly.toStringAsFixed(2)}
Number of Months Analyzed: ${monthlyExpenses.length}
Monthly Breakdown: ${jsonEncode(monthlyExpenses)}

Provide predictions in JSON:
{
  "predicted_amount": 1234.56,
  "confidence": "High/Medium/Low",
  "trend": "Increasing/Stable/Decreasing",
  "trend_percentage": 5.2,
  "recommendations": ["rec1", "rec2"]
}
''';

      final response = await _sendRequest(prompt);
      return _safeParseJson(response, {
        'predicted_amount': averageMonthly,
        'confidence': 'Medium',
        'trend': 'Stable',
        'trend_percentage': 0.0,
        'recommendations': ['Continue monitoring your spending patterns'],
      });
    } catch (e) {
      debugPrint('Error predicting spending: $e');
      return {
        'predicted_amount': 0.0,
        'confidence': 'Low',
        'trend': 'Stable',
        'trend_percentage': 0.0,
        'recommendations': ['Not enough data for prediction'],
      };
    }
  }

  /// Get AI recommendations for budget optimization
  Future<List<String>> getBudgetRecommendations({
    required Map<String, double> categoryStats,
    required double totalIncome,
  }) async {
    try {
      final prompt = '''
Analyze spending patterns and recommend budget optimization:

Monthly Income: \$${totalIncome.toStringAsFixed(2)}
Category Spending:
${categoryStats.entries.map((e) => '- ${e.key}: \$${e.value.toStringAsFixed(2)} (${((e.value / totalIncome) * 100).toStringAsFixed(1)}%)').join('\n')}

Provide 5-7 specific, actionable budget recommendations as JSON array of strings.
Focus on: reducing expenses, better allocation, savings opportunities.

Return as: ["recommendation1", "recommendation2", ...]
''';

      final response = await _sendRequest(prompt);
      try {
        final List<dynamic> recommendations = jsonDecode(response);
        return recommendations.cast<String>();
      } catch (e) {
        debugPrint('Error parsing recommendations: $e');
        return [
          'Review high-spending categories',
          'Set monthly spending limits',
          'Track daily expenses',
          'Consider alternative providers',
          'Build an emergency fund',
        ];
      }
    } catch (e) {
      debugPrint('Error getting budget recommendations: $e');
      return [
        'Review high-spending categories',
        'Set monthly spending limits',
        'Track daily expenses',
        'Consider alternative providers',
        'Build an emergency fund',
      ];
    }
  }

  /// Analyze spending anomalies
  Future<Map<String, dynamic>> detectAnomalies({
    required List<TransactionModel> transactions,
  }) async {
    try {
      // Calculate statistics
      final expenses = transactions.where((t) => t.isExpense).toList();
      if (expenses.isEmpty) {
        return {'anomalies': [], 'message': 'No expenses to analyze'};
      }

      final amounts = expenses.map((e) => e.amount).toList()..sort();
      final average = amounts.reduce((a, b) => a + b) / amounts.length;
      final median = amounts[amounts.length ~/ 2];

      // Find unusual transactions (>2x average)
      final unusual = expenses
          .where((t) => t.amount > average * 2)
          .map((t) => {
                'title': t.title,
                'amount': t.amount,
                'date': t.date.toIso8601String(),
                'category': t.category,
              })
          .toList();

      final prompt = '''
Analyze these spending anomalies:

Average Transaction: \$${average.toStringAsFixed(2)}
Median Transaction: \$${median.toStringAsFixed(2)}
Unusual Transactions (>2x average):
${unusual.map((u) => '- ${u['title']}: \$${u['amount']} on ${u['date']}').join('\n')}

Provide analysis in JSON:
{
  "anomalies": [
    {"transaction": "...", "reason": "...", "severity": "High/Medium/Low"}
  ],
  "summary": "brief summary",
  "action_needed": true/false
}
''';

      final response = await _sendRequest(prompt);
      return _safeParseJson(response, {
        'anomalies': [],
        'summary': 'No significant anomalies detected',
        'action_needed': false,
      });
    } catch (e) {
      debugPrint('Error detecting anomalies: $e');
      return {
        'anomalies': [],
        'summary': 'Unable to detect anomalies',
        'action_needed': false,
      };
    }
  }

  /// Compare spending with previous period
  Future<Map<String, dynamic>> compareWithPrevious({
    required List<TransactionModel> currentTransactions,
    required List<TransactionModel> previousTransactions,
  }) async {
    try {
      final currentTotal = currentTransactions
          .where((t) => t.isExpense)
          .fold(0.0, (sum, t) => sum + t.amount);
      final previousTotal = previousTransactions
          .where((t) => t.isExpense)
          .fold(0.0, (sum, t) => sum + t.amount);

      final difference = currentTotal - previousTotal;
      final percentChange =
          previousTotal > 0 ? (difference / previousTotal) * 100 : 0.0;

      final prompt = '''
Compare spending between two periods:

Current Period: \$${currentTotal.toStringAsFixed(2)}
Previous Period: \$${previousTotal.toStringAsFixed(2)}
Difference: \$${difference.toStringAsFixed(2)} (${percentChange.toStringAsFixed(1)}%)

Provide comparison analysis in JSON:
{
  "comparison_summary": "brief summary",
  "significant_changes": ["change1", "change2"],
  "verdict": "Improved/Worsened/Similar",
  "advice": "actionable advice"
}
''';

      final response = await _sendRequest(prompt);
      return _safeParseJson(response, {
        'comparison_summary': 'Spending patterns are similar to previous period',
        'significant_changes': [],
        'verdict': 'Similar',
        'advice': 'Continue monitoring spending',
      });
    } catch (e) {
      debugPrint('Error comparing periods: $e');
      return {
        'comparison_summary': 'Unable to compare periods',
        'significant_changes': [],
        'verdict': 'Similar',
        'advice': 'Continue monitoring spending',
      };
    }
  }

  /// Interactive Q&A with financial data
  Future<String> askQuestion({
    required String question,
    required List<TransactionModel> transactions,
    required Map<String, double> categoryStats,
  }) async {
    try {
      final totalIncome = transactions
          .where((t) => t.isIncome)
          .fold(0.0, (sum, t) => sum + t.amount);
      final totalExpense = transactions
          .where((t) => t.isExpense)
          .fold(0.0, (sum, t) => sum + t.amount);

      // Sort transactions by amount for easy querying
      final sortedByAmount = List<TransactionModel>.from(transactions)
        ..sort((a, b) => b.amount.compareTo(a.amount));

      // Get top 10 transactions
      final top10 = sortedByAmount.take(10).toList();

      // Get recent transactions (last 10)
      final sortedByDate = List<TransactionModel>.from(transactions)
        ..sort((a, b) => b.date.compareTo(a.date));
      final recent10 = sortedByDate.take(10).toList();

      // Format detailed transaction list
      final transactionList = transactions.map((t) {
        return {
          'title': t.title,
          'amount': t.amount,
          'category': t.category,
          'type': t.type.name,
          'date': t.date.toString().split(' ')[0],
        };
      }).toList();

      final prompt = '''
You are a precise financial analyst. Answer the user's question using ONLY the data provided.
Be mathematically accurate - double-check all calculations.

USER QUESTION: $question

=== COMPLETE FINANCIAL DATA ===

Summary Statistics:
- Total Income: \$${totalIncome.toStringAsFixed(2)}
- Total Expenses: \$${totalExpense.toStringAsFixed(2)}
- Net Balance: \$${(totalIncome - totalExpense).toStringAsFixed(2)}
- Total Transactions: ${transactions.length}

Category Spending:
${categoryStats.entries.map((e) => '- ${e.key}: \$${e.value.toStringAsFixed(2)} (${e.value > 0 ? ((e.value / totalExpense) * 100).toStringAsFixed(1) : 0}%)').join('\n')}

Top 10 Largest Transactions:
${top10.asMap().entries.map((e) => '${e.key + 1}. ${e.value.title} - \$${e.value.amount.toStringAsFixed(2)} (${e.value.category}) [${e.value.date.toString().split(' ')[0]}]').join('\n')}

Recent 10 Transactions:
${recent10.asMap().entries.map((e) => '${e.key + 1}. ${e.value.title} - \$${e.value.amount.toStringAsFixed(2)} (${e.value.category}) [${e.value.date.toString().split(' ')[0]}]').join('\n')}

ALL TRANSACTIONS (Complete List):
${jsonEncode(transactionList)}

=== INSTRUCTIONS ===
1. Be PRECISE with numbers - use the exact amounts from the data above
2. If asked about "highest", "largest", "biggest" - reference the Top 10 list
3. If asked about "recent", "latest", "last" - reference the Recent 10 list
4. Show specific transaction names and amounts
5. For calculations, double-check your math
6. If unsure, search through the complete transactions list
7. Always cite specific transactions by name and amount
8. Format currency as \$X.XX

Answer concisely but with exact numbers and specific examples.
''';

      return await _sendRequest(prompt);
    } catch (e) {
      debugPrint('Error in askQuestion: $e');
      return 'Unable to process your question at this time. Please try again.';
    }
  }

  /// Private method to send request to OpenAI
  Future<String> _sendRequest(String prompt) async {
    final response = await http.post(
      Uri.parse(AppConstants.openAiApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.openAiApiKey}',
      },
      body: jsonEncode({
        'model': AppConstants.openAiModel,
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a precise, accurate financial analyst AI. Your primary directive is ACCURACY.\n\nRules:\n1. Use ONLY the data provided - never make up numbers\n2. Double-check all calculations before responding\n3. When asked for specific numbers (highest, lowest, total), find the EXACT value from the data\n4. Cite specific transaction names and amounts\n5. If data format is JSON, return ONLY valid JSON without markdown\n6. Be mathematically precise - verify your math\n7. If unsure, search through the complete data before answering',
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.3,
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String content = data['choices'][0]['message']['content'] as String;

      // Clean up response - remove markdown code blocks if present
      content = content.trim();
      if (content.startsWith('```json')) {
        content = content.substring(7);
      }
      if (content.startsWith('```')) {
        content = content.substring(3);
      }
      if (content.endsWith('```')) {
        content = content.substring(0, content.length - 3);
      }

      return content.trim();
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }

  /// Helper to safely parse JSON responses
  Map<String, dynamic> _safeParseJson(String response, Map<String, dynamic> fallback) {
    try {
      return jsonDecode(response) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('JSON Parse Error: $e');
      debugPrint('Response was: $response');
      return fallback;
    }
  }
}
