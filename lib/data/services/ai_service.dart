// Import dart:convert for JSON encoding/decoding
import 'dart:convert';

// Import http package for making API requests
import 'package:http/http.dart' as http;

// Import app constants for API configuration
import '../../core/constants/app_constants.dart';

// Import AI message model for chat functionality
import '../models/ai_message_model.dart';

/// AiService handles all AI-powered features using OpenAI's GPT models
/// This includes document analysis, transaction categorization, chat, and insights
///
/// Uses Singleton pattern - only one instance exists throughout the app lifecycle
class AiService {
  // ============================================
  // SINGLETON PATTERN
  // Ensures only one instance of AiService exists
  // ============================================

  /// Private static instance variable
  /// The ? means it can be null initially
  static AiService? _instance;

  /// Public getter to access the singleton instance
  /// ??= means "if _instance is null, create new instance, otherwise use existing"
  static AiService get instance => _instance ??= AiService._();

  /// Private constructor prevents creating instances from outside
  /// Only this class can call AiService._()
  AiService._();

  // ============================================
  // DOCUMENT ANALYSIS
  // Analyzes scanned receipts/invoices and extracts transaction data
  // ============================================

  /// Analyze a document (receipt/invoice) and extract transaction information
  ///
  /// Parameters:
  /// - extractedText: Text extracted from the document via OCR
  /// - documentType: Type of document (e.g., "receipt", "invoice")
  ///
  /// Returns: JSON string containing merchant, date, amount, category, and items
  ///
  /// Example usage:
  /// final result = await aiService.analyzeDocumentWithGPT(
  ///   extractedText: "Walmart ... Total: $45.99",
  ///   documentType: "receipt",
  /// );
  Future<String> analyzeDocumentWithGPT({
    required String extractedText,
    required String documentType,
  }) async {
    try {
      // Construct a detailed prompt for the AI
      // Triple quotes (''') allow multi-line strings
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

      // Send the prompt to OpenAI and get structured response
      final response = await _sendChatCompletion(prompt);
      return response;
    } catch (e) {
      // Re-throw with more context about what failed
      throw Exception('Failed to analyze document: $e');
    }
  }

  // ============================================
  // TRANSACTION CATEGORIZATION
  // Uses AI to automatically categorize transactions
  // ============================================

  /// Categorize a transaction using AI
  /// This helps users by automatically assigning categories to transactions
  ///
  /// Parameters:
  /// - title: Transaction title (e.g., "Starbucks")
  /// - description: Optional description for better context
  ///
  /// Returns: Category name (e.g., "Food & Dining")
  ///
  /// Example:
  /// final category = await aiService.categorizeTransaction(
  ///   title: "Starbucks Coffee",
  ///   description: "Morning coffee",
  /// );
  /// // Returns: "Food & Dining"
  Future<String> categorizTransaction({
    required String title,
    required String description,
  }) async {
    try {
      // Create prompt asking AI to pick the best category
      final prompt = '''
Categorize this transaction into one of these categories:
${AppConstants.expenseCategories.join(', ')}

Transaction: $title
Description: $description

Return only the category name, nothing else.
''';

      final response = await _sendChatCompletion(prompt);
      // trim() removes any extra whitespace from the response
      return response.trim();
    } catch (e) {
      throw Exception('Failed to categorize transaction: $e');
    }
  }

  // ============================================
  // AI CHAT ASSISTANT
  // Interactive chat for financial questions and insights
  // ============================================

  /// Chat with AI assistant about finances
  /// Maintains conversation context for more natural interactions
  ///
  /// Parameters:
  /// - userMessage: The user's question or message
  /// - conversationHistory: Previous messages in this chat session
  /// - context: Optional financial data to help AI answer questions
  ///
  /// Returns: AI assistant's response
  ///
  /// Example:
  /// final response = await aiService.chatWithAI(
  ///   userMessage: "How much did I spend this month?",
  ///   conversationHistory: previousMessages,
  ///   context: {'total_spent': 1234.56, 'category_breakdown': {...}},
  /// );
  Future<String> chatWithAI({
    required String userMessage,
    required List<AiMessageModel> conversationHistory,
    Map<String, dynamic>? context,
  }) async {
    try {
      // Build the conversation structure for OpenAI
      final messages = [
        // System message sets the AI's role and behavior
        {
          'role': 'system',
          'content': '''You are a helpful AI financial assistant for SmartBooks AI.
You help users understand their spending, answer questions about their transactions,
and provide financial insights. Be concise, friendly, and helpful.

${context != null ? 'Current user context: ${jsonEncode(context)}' : ''}
'''
        },

        // Add all previous messages for context
        // ...spread operator adds all elements from the mapped list
        ...conversationHistory.map((msg) => {
              'role': msg.role.name,      // 'user', 'assistant', or 'system'
              'content': msg.content,
            }),

        // Add the current user message
        {
          'role': 'user',
          'content': userMessage,
        }
      ];

      // Make HTTP POST request to OpenAI API
      final response = await http.post(
        Uri.parse(AppConstants.openAiApiUrl),

        // Headers for authentication and content type
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.openAiApiKey}',
        },

        // Request body with model configuration
        body: jsonEncode({
          'model': AppConstants.openAiModel,  // Which AI model to use
          'messages': messages,                // The conversation
          'temperature': 0.7,                  // Creativity (0-2, higher = more creative)
          'max_tokens': 500,                   // Maximum length of response
        }),
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse JSON response
        final data = jsonDecode(response.body);

        // Extract the AI's message from the response structure
        return data['choices'][0]['message']['content'] as String;
      } else {
        // Request failed, throw error with details
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to chat with AI: $e');
    }
  }

  // ============================================
  // FINANCIAL INSIGHTS GENERATION
  // Analyzes spending patterns and generates actionable insights
  // ============================================

  /// Generate financial insights based on transaction data
  /// Provides personalized recommendations and observations
  ///
  /// Parameters:
  /// - transactions: List of transaction data
  /// - categoryStats: Spending breakdown by category
  ///
  /// Returns: Map containing array of insight strings and timestamp
  ///
  /// Example output:
  /// {
  ///   'insights': [
  ///     'You spent 40% on food this month',
  ///     'Consider reducing shopping expenses'
  ///   ],
  ///   'generated_at': '2024-01-15T10:30:00Z'
  /// }
  Future<Map<String, dynamic>> generateInsights({
    required List<Map<String, dynamic>> transactions,
    required Map<String, double> categoryStats,
  }) async {
    try {
      // Create prompt asking for spending analysis
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

      // Parse the JSON response (should be an array of strings)
      final insights = jsonDecode(response) as List;

      return {
        'insights': insights,
        'generated_at': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // If insights generation fails, return fallback message
      return {
        'insights': [
          'Unable to generate insights at this time',
        ],
        'generated_at': DateTime.now().toIso8601String(),
      };
    }
  }

  // ============================================
  // PRIVATE HELPER METHOD
  // Generic method for sending simple prompts to OpenAI
  // ============================================

  /// Private helper method to send a simple prompt to OpenAI
  /// Used by other methods that don't need full conversation context
  ///
  /// Parameters:
  /// - prompt: The text to send to AI
  ///
  /// Returns: AI's response text
  Future<String> _sendChatCompletion(String prompt) async {
    try {
      // Make HTTP POST request
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
          'temperature': 0.3,  // Lower temperature for more focused responses
          'max_tokens': 500,
        }),
      );

      // Check response status
      if (response.statusCode == 200) {
        // Parse and extract the response text
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
