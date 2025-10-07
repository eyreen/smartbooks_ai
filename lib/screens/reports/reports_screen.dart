import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';
import '../../config/app_theme.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_card.dart';
import 'widgets/insights_card.dart';
import 'widgets/predictions_card.dart';
import 'widgets/recommendations_card.dart';
import 'widgets/anomalies_card.dart';
import 'widgets/comparison_card.dart';
import 'widgets/ai_ask_section.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReports();
    });
  }

  Future<void> _loadReports() async {
    final provider = Provider.of<ReportsProvider>(context, listen: false);
    await provider.loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.analytics, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('AI Reports & Insights'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ReportsProvider>(context, listen: false).refresh();
            },
            tooltip: 'Refresh Reports',
          ),
        ],
      ),
      body: Consumer<ReportsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Generating AI insights...');
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      provider.error!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadReports,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadReports,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Your Financial Overview',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI-powered analysis of your spending patterns',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Financial Health Status
                  if (provider.insights != null)
                    _buildHealthStatus(context, provider.insights!),
                  const SizedBox(height: 24),

                  // Key Insights
                  if (provider.insights != null)
                    InsightsCard(insights: provider.insights!),
                  const SizedBox(height: 16),

                  // Predictions
                  if (provider.predictions != null)
                    PredictionsCard(predictions: provider.predictions!),
                  const SizedBox(height: 16),

                  // Recommendations
                  if (provider.recommendations != null)
                    RecommendationsCard(
                        recommendations: provider.recommendations!),
                  const SizedBox(height: 16),

                  // Anomalies Detection
                  if (provider.anomalies != null)
                    AnomaliesCard(anomalies: provider.anomalies!),
                  const SizedBox(height: 16),

                  // Period Comparison
                  if (provider.comparison != null)
                    ComparisonCard(comparison: provider.comparison!),
                  const SizedBox(height: 16),

                  // AI Ask Section
                  const AiAskSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthStatus(
      BuildContext context, Map<String, dynamic> insights) {
    final status = insights['health_status'] ?? 'Unknown';
    final message = insights['health_message'] ?? '';

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'Good':
        statusColor = AppTheme.successColor;
        statusIcon = Icons.check_circle;
        break;
      case 'Concerning':
        statusColor = AppTheme.warningColor;
        statusIcon = Icons.warning;
        break;
      case 'Critical':
        statusColor = AppTheme.errorColor;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return CustomCard(
      color: statusColor.withOpacity(0.1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Health: $status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
