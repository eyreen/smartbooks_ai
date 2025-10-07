import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../widgets/common/custom_card.dart';

class AnomaliesCard extends StatelessWidget {
  final Map<String, dynamic> anomalies;

  const AnomaliesCard({super.key, required this.anomalies});

  @override
  Widget build(BuildContext context) {
    final anomaliesList = anomalies['anomalies'] as List<dynamic>? ?? [];
    final summary = anomalies['summary'] ?? '';
    final actionNeeded = anomalies['action_needed'] as bool? ?? false;

    if (anomaliesList.isEmpty && summary.isEmpty) {
      return const SizedBox.shrink();
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
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber,
                  color: AppTheme.warningColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Unusual Spending Detected',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (actionNeeded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Action Needed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (summary.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              summary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (anomaliesList.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...anomaliesList.map((anomaly) {
              final transaction = anomaly['transaction'] ?? '';
              final reason = anomaly['reason'] ?? '';
              final severity = anomaly['severity'] ?? 'Low';

              Color severityColor;
              switch (severity) {
                case 'High':
                  severityColor = AppTheme.errorColor;
                  break;
                case 'Medium':
                  severityColor = AppTheme.warningColor;
                  break;
                default:
                  severityColor = Colors.blue;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: severityColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: severityColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            severity,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            transaction,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reason,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
