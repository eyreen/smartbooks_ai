import 'package:flutter/foundation.dart';
import '../data/models/ai_message_model.dart';
import '../data/services/ai_service.dart';
import '../data/services/supabase_service.dart';

class AiChatProvider extends ChangeNotifier {
  final AiService _aiService = AiService.instance;
  final SupabaseService _supabaseService = SupabaseService.instance;

  final List<AiMessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<AiMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = AiMessageModel.create(
      role: MessageRole.user,
      content: content,
    );
    _messages.add(userMessage);
    notifyListeners();

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get user context (recent transactions, stats)
      final stats = await _supabaseService.getMonthlyStats();
      final categoryStats = await _supabaseService.getCategoryStats();

      final context = {
        'monthly_income': stats['income'],
        'monthly_expense': stats['expense'],
        'balance': stats['balance'],
        'category_breakdown': categoryStats,
      };

      // Get AI response
      final response = await _aiService.chatWithAI(
        userMessage: content,
        conversationHistory: _messages.take(_messages.length - 1).toList(),
        context: context,
      );

      // Add assistant message
      final assistantMessage = AiMessageModel.create(
        role: MessageRole.assistant,
        content: response,
      );
      _messages.add(assistantMessage);
      _error = null;
    } catch (e) {
      _error = e.toString();
      // Add error message
      final errorMessage = AiMessageModel.create(
        role: MessageRole.assistant,
        content: 'Sorry, I encountered an error. Please try again.',
      );
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
