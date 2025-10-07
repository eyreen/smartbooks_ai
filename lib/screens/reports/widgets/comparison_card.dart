import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../widgets/common/custom_card.dart';

class ComparisonCard extends StatelessWidget {
  final Map<String, dynamic> comparison;

  const ComparisonCard({super.key, required this.comparison});

  @override
  Widget build(BuildContext context) {
    final summary = comparison['comparison_summary'] ?? '';
    final changes = comparison['significant_changes'] as List<dynamic>? ?? [];
    final verdict = comparison['verdict'] ?? 'Similar';
    final advice = comparison['advice'] ?? '';

    Color verdictColor;
    IconData verdictIcon;

    switch (verdict) {
      case 'Improved':
        verdictColor = AppTheme.successColor;
        verdictIcon = Icons.trending_down;
        break;
      case 'Worsened':
        verdictColor = AppTheme.errorColor;
        verdictIcon = Icons.trending_up;
        break;
      default:
        verdictColor = Colors.blue;
        verdictIcon = Icons.trending_flat;
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.compare_arrows,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Period Comparison',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Verdict Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: verdictColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: verdictColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(verdictIcon, color: verdictColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending $verdict',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: verdictColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (summary.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          summary,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (changes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Significant Changes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...changes.map((change) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 8,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        change.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          if (advice.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.tips_and_updates,
                  color: AppTheme.warningColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    advice,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
