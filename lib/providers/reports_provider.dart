import 'package:flutter/foundation.dart';
import '../data/services/ai_insights_service.dart';
import '../data/services/supabase_service.dart';

class ReportsProvider extends ChangeNotifier {
  final AiInsightsService _aiService = AiInsightsService.instance;
  final SupabaseService _supabaseService = SupabaseService.instance;

  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? _insights;
  Map<String, dynamic>? _predictions;
  List<String>? _recommendations;
  Map<String, dynamic>? _anomalies;
  Map<String, dynamic>? _comparison;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get insights => _insights;
  Map<String, dynamic>? get predictions => _predictions;
  List<String>? get recommendations => _recommendations;
  Map<String, dynamic>? get anomalies => _anomalies;
  Map<String, dynamic>? get comparison => _comparison;

  /// Load all reports data
  Future<void> loadReports() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch transactions
      final transactions = await _supabaseService.getTransactions();
      final categoryStats = await _supabaseService.getCategoryStats();
      final monthlyStats = await _supabaseService.getMonthlyStats();

      if (transactions.isEmpty) {
        _error = 'No transactions found. Add some transactions to see reports.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Generate all AI insights in parallel
      final results = await Future.wait([
        _aiService.generateSpendingInsights(
          transactions: transactions,
          categoryStats: categoryStats,
        ),
        _aiService.predictFutureSpending(transactions: transactions),
        _aiService.getBudgetRecommendations(
          categoryStats: categoryStats,
          totalIncome: monthlyStats['income'] ?? 0,
        ),
        _aiService.detectAnomalies(transactions: transactions),
      ]);

      _insights = results[0] as Map<String, dynamic>;
      _predictions = results[1] as Map<String, dynamic>;
      _recommendations = results[2] as List<String>;
      _anomalies = results[3] as Map<String, dynamic>;

      // Load comparison if we have historical data
      final now = DateTime.now();
      final lastMonthStart = DateTime(now.year, now.month - 1, 1);
      final lastMonthEnd = DateTime(now.year, now.month, 0);
      final previousTransactions = await _supabaseService.getTransactions(
        startDate: lastMonthStart,
        endDate: lastMonthEnd,
      );

      if (previousTransactions.isNotEmpty) {
        _comparison = await _aiService.compareWithPrevious(
          currentTransactions: transactions,
          previousTransactions: previousTransactions,
        );
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to load reports: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ask a custom question
  Future<String> askQuestion(String question) async {
    try {
      final transactions = await _supabaseService.getTransactions();
      final categoryStats = await _supabaseService.getCategoryStats();

      return await _aiService.askQuestion(
        question: question,
        transactions: transactions,
        categoryStats: categoryStats,
      );
    } catch (e) {
      return 'Unable to answer your question at this time.';
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void refresh() {
    loadReports();
  }
}
