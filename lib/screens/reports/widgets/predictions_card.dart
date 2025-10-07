import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/common/custom_card.dart';

class PredictionsCard extends StatelessWidget {
  final Map<String, dynamic> predictions;

  const PredictionsCard({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    final predictedAmount =
        (predictions['predicted_amount'] as num?)?.toDouble() ?? 0.0;
    final confidence = predictions['confidence'] ?? 'Unknown';
    final trend = predictions['trend'] ?? 'Stable';
    final trendPercentage =
        (predictions['trend_percentage'] as num?)?.toDouble() ?? 0.0;
    final recommendations =
        predictions['recommendations'] as List<dynamic>? ?? [];

    Color trendColor;
    IconData trendIcon;

    switch (trend) {
      case 'Increasing':
        trendColor = AppTheme.errorColor;
        trendIcon = Icons.trending_up;
        break;
      case 'Decreasing':
        trendColor = AppTheme.successColor;
        trendIcon = Icons.trending_down;
        break;
      default:
        trendColor = Colors.blue;
        trendIcon = Icons.trending_flat;
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
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Spending Prediction',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Prediction Amount
          Center(
            child: Column(
              children: [
                Text(
                  'Next Month Estimate',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  CurrencyFormatter.format(predictedAmount),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Confidence and Trend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip(
                context,
                label: 'Confidence',
                value: confidence,
                color: _getConfidenceColor(confidence),
              ),
              _buildInfoChip(
                context,
                label: 'Trend',
                value: '$trend ${trendPercentage.toStringAsFixed(1)}%',
                color: trendColor,
                icon: trendIcon,
              ),
            ],
          ),

          if (recommendations.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Recommendations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...recommendations.map((rec) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.arrow_right,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
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

  Widget _buildInfoChip(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(String confidence) {
    switch (confidence) {
      case 'High':
        return AppTheme.successColor;
      case 'Medium':
        return AppTheme.warningColor;
      case 'Low':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }
}
