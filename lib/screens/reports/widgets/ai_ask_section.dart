import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_theme.dart';
import '../../../providers/reports_provider.dart';
import '../../../widgets/common/custom_card.dart';

class AiAskSection extends StatefulWidget {
  const AiAskSection({super.key});

  @override
  State<AiAskSection> createState() => _AiAskSectionState();
}

class _AiAskSectionState extends State<AiAskSection> {
  final TextEditingController _questionController = TextEditingController();
  final List<Map<String, String>> _conversation = [];
  bool _isAsking = false;

  final List<String> _quickQuestions = [
    'What can I do to save more money?',
    'Am I spending too much on food?',
    'How does my spending compare to last month?',
    'What\'s my average daily expense?',
    'Should I be concerned about my spending?',
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion(String question) async {
    if (question.trim().isEmpty) return;

    setState(() {
      _conversation.add({'role': 'user', 'content': question});
      _isAsking = true;
      _questionController.clear();
    });

    try {
      final provider = Provider.of<ReportsProvider>(context, listen: false);
      final answer = await provider.askQuestion(question);

      setState(() {
        _conversation.add({'role': 'assistant', 'content': answer});
      });
    } catch (e) {
      setState(() {
        _conversation.add({
          'role': 'assistant',
          'content': 'Sorry, I couldn\'t process your question. Please try again.'
        });
      });
    } finally {
      setState(() {
        _isAsking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: AppTheme.secondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ask AI Anything',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Get personalized financial advice',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 16),

          // Quick Questions
          if (_conversation.isEmpty) ...[
            Text(
              'Quick Questions:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickQuestions.map((q) {
                return ActionChip(
                  label: Text(q),
                  onPressed: () => _askQuestion(q),
                  backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                  side: BorderSide(
                    color: AppTheme.secondaryColor.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Conversation History
          if (_conversation.isNotEmpty) ...[
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                child: Column(
                  children: _conversation.map((message) {
                    final isUser = message['role'] == 'user';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.secondaryColor,
                              child: Icon(
                                Icons.smart_toy,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message['content']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isUser
                                          ? Colors.white
                                          : AppTheme.textPrimaryColor,
                                    ),
                              ),
                            ),
                          ),
                          if (isUser) ...[
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_conversation.length >= 2)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _conversation.clear();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Start New Conversation'),
              ),
            const SizedBox(height: 8),
          ],

          // Input Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: 'Ask about your finances...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: _askQuestion,
                  enabled: !_isAsking,
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.secondaryColor,
                child: _isAsking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () => _askQuestion(_questionController.text),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
