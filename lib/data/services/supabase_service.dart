import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';
import '../models/document_model.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  // Auth Methods
  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  String? get userId => currentUser?.id;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Transaction Methods
  Future<List<TransactionModel>> getTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Build base query
      dynamic queryBuilder = client
          .from(SupabaseTables.transactions)
          .select();

      // Apply filters - use demo user ID if not authenticated
      final currentUserId = userId ?? '00000000-0000-0000-0000-000000000000';
      queryBuilder = queryBuilder.eq('user_id', currentUserId);

      if (startDate != null) {
        queryBuilder = queryBuilder.gte('date', startDate.toIso8601String());
      }
      if (endDate != null) {
        queryBuilder = queryBuilder.lte('date', endDate.toIso8601String());
      }

      // Apply order and limit
      queryBuilder = queryBuilder.order('date', ascending: false);

      if (limit != null) {
        queryBuilder = queryBuilder.limit(limit);
      }

      final response = await queryBuilder;
      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final response = await client
          .from(SupabaseTables.transactions)
          .insert(transaction.toJson())
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    try {
      final response = await client
          .from(SupabaseTables.transactions)
          .update(transaction.toJson())
          .eq('id', transaction.id)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await client
          .from(SupabaseTables.transactions)
          .delete()
          .eq('id', transactionId);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Document Methods
  Future<List<DocumentModel>> getDocuments({int? limit}) async {
    try {
      final currentUserId = userId ?? '00000000-0000-0000-0000-000000000000';
      var query = client
          .from(SupabaseTables.documents)
          .select()
          .eq('user_id', currentUserId)
          .order('uploaded_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return (response as List)
          .map((json) => DocumentModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  Future<DocumentModel> createDocument(DocumentModel document) async {
    try {
      final response = await client
          .from(SupabaseTables.documents)
          .insert(document.toJson())
          .select()
          .single();

      return DocumentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  Future<DocumentModel> updateDocument(DocumentModel document) async {
    try {
      final response = await client
          .from(SupabaseTables.documents)
          .update(document.toJson())
          .eq('id', document.id)
          .select()
          .single();

      return DocumentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Storage Methods
  Future<String> uploadImage(String filePath, String fileName) async {
    try {
      // Read file as bytes
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      final currentUserId = userId ?? '00000000-0000-0000-0000-000000000000';

      // Upload to Supabase storage
      await client.storage
          .from('documents')
          .uploadBinary('$currentUserId/$fileName', bytes);

      // Get public URL
      final publicUrl = client.storage
          .from('documents')
          .getPublicUrl('$currentUserId/$fileName');

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Statistics Methods
  Future<Map<String, double>> getCategoryStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final transactions = await getTransactions(
        startDate: startDate,
        endDate: endDate,
      );

      final Map<String, double> stats = {};
      for (var transaction in transactions) {
        if (transaction.isExpense) {
          stats[transaction.category] =
              (stats[transaction.category] ?? 0) + transaction.amount;
        }
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to fetch category stats: $e');
    }
  }

  Future<Map<String, double>> getMonthlyStats() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final transactions = await getTransactions(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );

    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    return {
      'income': totalIncome,
      'expense': totalExpense,
      'balance': totalIncome - totalExpense,
    };
  }
}
