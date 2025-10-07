import 'package:uuid/uuid.dart';

enum MessageRole { user, assistant, system }

class AiMessageModel {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  AiMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory AiMessageModel.create({
    required MessageRole role,
    required String content,
  }) {
    return AiMessageModel(
      id: const Uuid().v4(),
      role: role,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['id'] as String,
      role: MessageRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => MessageRole.assistant,
      ),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;
  bool get isSystem => role == MessageRole.system;
}
