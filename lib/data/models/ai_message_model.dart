// Import UUID package for generating unique message IDs
import 'package:uuid/uuid.dart';

/// Enum defining the roles in an AI conversation
/// Each message has a role that determines who sent it
enum MessageRole {
  user,       // Message from the user
  assistant,  // Message from the AI assistant
  system      // System message (sets AI behavior/context)
}

/// AiMessageModel represents a single message in an AI chat conversation
/// This is used in the AI chat feature to track conversation history
class AiMessageModel {
  // ============================================
  // FIELDS
  // ============================================

  /// Unique identifier for this message
  final String id;

  /// Role of the message sender (user, assistant, or system)
  final MessageRole role;

  /// Text content of the message
  final String content;

  /// When this message was created
  final DateTime timestamp;

  // ============================================
  // CONSTRUCTOR
  // ============================================

  /// Default constructor requiring all fields
  AiMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  // ============================================
  // FACTORY CONSTRUCTOR - Create new message
  // ============================================

  /// Factory constructor to create a new message
  /// Automatically generates ID and timestamp
  ///
  /// Example:
  /// final userMessage = AiMessageModel.create(
  ///   role: MessageRole.user,
  ///   content: 'How much did I spend this month?',
  /// );
  factory AiMessageModel.create({
    required MessageRole role,
    required String content,
  }) {
    return AiMessageModel(
      id: const Uuid().v4(),      // Generate unique ID
      role: role,
      content: content,
      timestamp: DateTime.now(),  // Current time
    );
  }

  // ============================================
  // FACTORY CONSTRUCTOR - From JSON
  // ============================================

  /// Create an AiMessageModel from JSON data
  /// Used when loading chat history from storage
  ///
  /// Example JSON:
  /// {
  ///   "id": "123",
  ///   "role": "user",
  ///   "content": "Hello",
  ///   "timestamp": "2024-01-15T10:30:00Z"
  /// }
  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['id'] as String,

      // Find matching enum value by name
      role: MessageRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => MessageRole.assistant,  // Default if invalid
      ),

      content: json['content'] as String,

      // Parse ISO 8601 date string
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // ============================================
  // TO JSON METHOD
  // ============================================

  /// Convert this message to JSON format
  /// Used when saving chat history
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,                       // Convert enum to string
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to string
    };
  }

  // ============================================
  // GETTER METHODS - Role checkers
  // ============================================

  /// Check if this message is from the user
  bool get isUser => role == MessageRole.user;

  /// Check if this message is from the AI assistant
  bool get isAssistant => role == MessageRole.assistant;

  /// Check if this is a system message
  bool get isSystem => role == MessageRole.system;
}
