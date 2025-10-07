import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String scan = '/scan';
  static const String transactionList = '/transactions';
  static const String transactionDetail = '/transaction-detail';
  static const String addTransaction = '/add-transaction';
  static const String aiChat = '/ai-chat';
  static const String reports = '/reports';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        // Will be implemented later
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      case scan:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      case transactionList:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      case addTransaction:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      case aiChat:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      case reports:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
