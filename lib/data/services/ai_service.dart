import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/ai_message_model.dart';

class AiService {
  static AiService? _instance;
  static AiService get instance => _instance ??= AiService._();

  AiService._();

  Future<String> analyzeDocumentWithGPT({
    required String extractedText,
    required String documentType,
  }) async {
    try {
      final prompt = '''
Analyze this $documentType and extract the following information in JSON format:
- merchant: the vendor/merchant name
- date: transaction date in ISO format (YYYY-MM-DD)
- amount: total amount as a number
- category: categorize into one of these: ${AppConstants.expenseCategories.join(', ')}
- items: array of purchased items (if available)

Receipt/Invoice text:
$extractedText

Return only valid JSON without any markdown formatting or code blocks.
''';

      final response = await _sendChatCompletion(prompt);
      return response;
    } catch (e) {
      throw Exception('Failed to analyze document: $e');
    }
  }

  Future<String> categorizTransaction({
    required String title,
    required String description,
  }) async {
    try {
      final prompt = '''
Categorize this transaction into one of these categories:
${AppConstants.expenseCategories.join(', ')}

Transaction: $title
Description: $description

Return only the category name, nothing else.
''';

      final response = await _sendChatCompletion(prompt);
      return response.trim();
    } catch (e) {
      throw Exception('Failed to categorize transaction: $e');
    }
  }

  Future<String> chatWithAI({
    required String userMessage,
    required List<AiMessageModel> conversationHistory,
    Map<String, dynamic>? context,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': '''You are a helpful AI financial assistant for SmartBooks AI.
You help users understand their spending, answer questions about their transactions,
and provide financial insights. Be concise, friendly, and helpful.

${context != null ? 'Current user context: ${jsonEncode(context)}' : ''}
'''
        },
        ...conversationHistory.map((msg) => {
              'role': msg.role.name,
              'content': msg.content,
            }),
        {
          'role': 'user',
          'content': userMessage,
        }
      ];

      final response = await http.post(
        Uri.parse(AppConstants.openAiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.openAiApiKey}',
        },
        body: jsonEncode({
          'model': AppConstants.openAiModel,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to chat with AI: $e');
    }
  }

  Future<Map<String, dynamic>> generateInsights({
    required List<Map<String, dynamic>> transactions,
    required Map<String, double> categoryStats,
  }) async {
    try {
      final prompt = '''
Analyze these financial statistics and provide insights:

Total Transactions: ${transactions.length}
Category Breakdown: ${jsonEncode(categoryStats)}

Provide 3-5 actionable insights about spending patterns, suggestions for saving,
or notable trends. Format as JSON array of strings.

Example: ["You spent 40% on food this month", "Consider reducing shopping expenses"]

Return only valid JSON array.
''';

      final response = await _sendChatCompletion(prompt);
      final insights = jsonDecode(response) as List;
      return {
        'insights': insights,
        'generated_at': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'insights': [
          'Unable to generate insights at this time',
        ],
        'generated_at': DateTime.now().toIso8601String(),
      };
    }
  }

  Future<String> _sendChatCompletion(String prompt) async {
    try {
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
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send chat completion: $e');
    }
  }
}
