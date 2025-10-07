import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../config/app_theme.dart';
import '../../widgets/common/loading_widget.dart';
import '../scan/scan_document_screen.dart';
import 'widgets/stats_card.dart';
import 'widgets/category_chart.dart';
import 'widgets/recent_transactions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.transactions.isEmpty) {
                return const LoadingWidget(message: 'Loading your data...');
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppTheme.backgroundColor,
                    elevation: 0,
                    floating: true,
                    snap: true,
                    expandedHeight: 80,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'SmartBooks AI',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                title: 'Income',
                                amount: provider.totalIncome,
                                icon: Icons.arrow_downward,
                                color: AppTheme.successColor,
                                backgroundColor: Colors.green.shade50,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatsCard(
                                title: 'Expense',
                                amount: provider.totalExpense,
                                icon: Icons.arrow_upward,
                                color: AppTheme.errorColor,
                                backgroundColor: Colors.red.shade50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        StatsCard(
                          title: 'Balance',
                          amount: provider.balance,
                          icon: Icons.account_balance_wallet,
                          color: AppTheme.primaryColor,
                          backgroundColor: Colors.purple.shade50,
                        ),
                        const SizedBox(height: 24),
                        if (provider.categoryStats.isNotEmpty)
                          CategoryChart(
                            categoryData: provider.categoryStats,
                          ),
                        const SizedBox(height: 24),
                        RecentTransactions(
                          transactions: provider.transactions,
                          onViewAll: () {
                            // Navigate to transactions list
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanDocumentScreen(),
            ),
          );
        },
        icon: const Icon(Icons.camera_alt),
        label: const Text('Scan'),
      ),
    );
  }
}
