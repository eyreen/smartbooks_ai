// Import Flutter's material design package - provides UI components
import 'package:flutter/material.dart';

// Import Provider package for state management across the app
import 'package:provider/provider.dart';

// Import our app's custom theme configuration
import 'config/app_theme.dart';

// Import Supabase service for backend/database functionality
import 'data/services/supabase_service.dart';

// Import all providers (state management classes)
import 'providers/transaction_provider.dart';  // Manages transaction data
import 'providers/ai_chat_provider.dart';       // Manages AI chat conversations
import 'providers/theme_provider.dart';         // Manages light/dark theme
import 'providers/reports_provider.dart';       // Manages financial reports

// Import all main screens
import 'screens/home/home_screen.dart';
import 'screens/transactions/transaction_list_screen.dart';
import 'screens/ai_chat/ai_chat_screen.dart';
import 'screens/reports/reports_screen.dart';

/// Entry point of the Flutter application
/// The 'async' keyword allows us to perform asynchronous operations before starting the app
void main() async {
  // Ensure Flutter framework is fully initialized
  // Required when using async operations in main() or before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase backend connection
  // This sets up the connection to our database and authentication
  // 'await' waits for initialization to complete before proceeding
  await SupabaseService.initialize();

  // Start the Flutter app with MyApp as the root widget
  runApp(const MyApp());
}

/// Root widget of the application
/// StatelessWidget because it doesn't need to maintain mutable state
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider allows multiple providers to be injected into the widget tree
    // This makes state management accessible throughout the entire app
    return MultiProvider(
      // List of all providers that will be available app-wide
      providers: [
        // ChangeNotifierProvider creates and provides a state management object
        // ChangeNotifier allows widgets to listen for state changes
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => AiChatProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ],

      // Consumer listens to ThemeProvider changes and rebuilds when theme changes
      child: Consumer<ThemeProvider>(
        // builder is called whenever ThemeProvider notifies of changes
        builder: (context, themeProvider, child) {
          // MaterialApp is the root of the app's widget tree
          return MaterialApp(
            // App title shown in task switcher on mobile
            title: 'SmartBooks AI',

            // Hide debug banner in top-right corner
            debugShowCheckedModeBanner: false,

            // Light theme configuration
            theme: AppTheme.lightTheme,

            // Dark theme configuration
            darkTheme: AppTheme.darkTheme,

            // Current theme mode (light, dark, or system)
            // This value comes from ThemeProvider and can change dynamically
            themeMode: themeProvider.themeMode,

            // Initial screen to display
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}

/// Main navigation screen with bottom navigation bar
/// StatefulWidget because it needs to track which tab is currently selected
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

/// State class for MainNavigationScreen
/// Manages the current tab selection and navigation
class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Track which tab is currently selected (0 = Home, 1 = Transactions, etc.)
  int _currentIndex = 0;

  // List of all screens corresponding to each bottom navigation tab
  // Using 'final' because this list never changes
  final List<Widget> _screens = [
    const HomeScreen(),              // Tab 0: Dashboard/Overview
    const TransactionListScreen(),   // Tab 1: List of all transactions
    const AiChatScreen(),            // Tab 2: AI Assistant chat
    const ReportsScreen(),           // Tab 3: Financial reports and insights
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic app structure (body + bottom navigation)
    return Scaffold(
      // IndexedStack keeps all screens in memory and shows only the selected one
      // This preserves the state of each screen when switching tabs
      // Alternative: just showing _screens[_currentIndex] would rebuild screens
      body: IndexedStack(
        index: _currentIndex,  // Which screen to show
        children: _screens,    // All available screens
      ),

      // Bottom navigation bar for switching between screens
      bottomNavigationBar: BottomNavigationBar(
        // Current selected tab index
        currentIndex: _currentIndex,

        // Called when user taps a navigation item
        onTap: (index) {
          // Update the selected index, which triggers a rebuild
          setState(() {
            _currentIndex = index;
          });
        },

        // fixed type shows all items with labels at all times
        // Alternative: shifting type hides labels for unselected items
        type: BottomNavigationBarType.fixed,

        // Color for the selected (active) navigation item
        selectedItemColor: Theme.of(context).primaryColor,

        // Color for unselected (inactive) navigation items
        unselectedItemColor: Colors.grey,

        // Define all navigation items
        items: const [
          // Home tab
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),     // Unselected icon (outlined)
            activeIcon: Icon(Icons.home),        // Selected icon (filled)
            label: 'Home',                       // Text label
          ),

          // Transactions tab
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),

          // AI Chat tab
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'AI Chat',
          ),

          // Reports tab
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}
