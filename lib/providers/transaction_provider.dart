import 'package:flutter/foundation.dart';
import '../data/models/transaction_model.dart';
import '../data/services/supabase_service.dart';

class TransactionProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService.instance;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<TransactionModel> get expenseTransactions =>
      _transactions.where((t) => t.isExpense).toList();

  List<TransactionModel> get incomeTransactions =>
      _transactions.where((t) => t.isIncome).toList();

  double get totalIncome =>
      incomeTransactions.fold(0, (sum, t) => sum + t.amount);

  double get totalExpense =>
      expenseTransactions.fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, double> get categoryStats {
    final Map<String, double> stats = {};
    for (var transaction in expenseTransactions) {
      stats[transaction.category] =
          (stats[transaction.category] ?? 0) + transaction.amount;
    }
    return stats;
  }

  Future<void> loadTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _supabaseService.getTransactions(
        startDate: startDate,
        endDate: endDate,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      final newTransaction = await _supabaseService.createTransaction(transaction);
      _transactions.insert(0, newTransaction);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final updatedTransaction =
          await _supabaseService.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _supabaseService.deleteTransaction(transactionId);
      _transactions.removeWhere((t) => t.id == transactionId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<TransactionModel> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
