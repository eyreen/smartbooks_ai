// Import Flutter's material package for navigation
import 'package:flutter/material.dart';

/// AppRoutes class manages all navigation routes in the application
/// This provides centralized route management with named routes
class AppRoutes {
  // ============================================
  // ROUTE NAME CONSTANTS
  // Using constants prevents typos when navigating
  // ============================================

  /// Home screen route - Dashboard overview
  static const String home = '/';

  /// Document scanning screen route
  static const String scan = '/scan';

  /// Transaction list screen route
  static const String transactionList = '/transactions';

  /// Transaction detail screen route
  static const String transactionDetail = '/transaction-detail';

  /// Add new transaction screen route
  static const String addTransaction = '/add-transaction';

  /// AI chat assistant screen route
  static const String aiChat = '/ai-chat';

  /// Financial reports screen route
  static const String reports = '/reports';

  /// App settings screen route
  static const String settings = '/settings';

  // ============================================
  // ROUTE GENERATOR
  // ============================================

  /// Generate routes dynamically based on route name
  /// This is called by Navigator when navigating to a named route
  ///
  /// Parameters:
  /// - settings: Contains route name and optional arguments
  ///
  /// Returns: Route object that Navigator uses to display the screen
  ///
  /// Usage in MaterialApp:
  /// MaterialApp(
  ///   onGenerateRoute: AppRoutes.generateRoute,
  /// )
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Switch statement to match route name and return appropriate screen
    switch (settings.name) {
      case home:
        // Home screen - will be implemented later
        // Placeholder is a simple widget that shows a gray box
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );

      case scan:
        // Document scanning screen
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );

      case transactionList:
        // Transaction list screen
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );

      case addTransaction:
        // Add transaction screen
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );

      case aiChat:
        // AI chat screen
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );

      case reports:
        // Reports screen
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );

      // Default case: route not found
      default:
        // Show error screen when route doesn't exist
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
