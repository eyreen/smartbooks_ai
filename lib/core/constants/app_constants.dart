/// AppConstants class contains all constant values used throughout the app
/// This centralizes configuration, making it easy to update values in one place
/// Using constants prevents typos and makes the code more maintainable
class AppConstants {
  // ============================================
  // APP INFORMATION
  // ============================================

  /// Application name displayed in the app
  static const String appName = 'SmartBooks AI';

  /// Current version of the application
  static const String appVersion = '1.0.0';

  // ============================================
  // SUPABASE CONFIGURATION
  // Supabase is the backend database and authentication service
  // ============================================

  /// Supabase project URL - get this from your Supabase dashboard
  /// Replace 'YOUR_SUPABASE_URL' with your actual project URL
  /// Example: 'https://xxxxx.supabase.co'
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';

  /// Supabase anonymous key - public key for client-side access
  /// This key is safe to expose in client code
  /// Get this from your Supabase project settings
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // ============================================
  // OPENAI API CONFIGURATION
  // For AI-powered features like chat and insights
  // ============================================

  /// OpenAI API key for authentication
  /// Get this from platform.openai.com/api-keys
  /// IMPORTANT: In production, store this securely on backend, not in client code
  static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';

  /// OpenAI model to use for AI requests
  /// 'gpt-4o-mini' is cost-effective and fast
  /// Alternatives: 'gpt-4', 'gpt-3.5-turbo'
  static const String openAiModel = 'gpt-4o-mini';

  // ============================================
  // API ENDPOINTS
  // ============================================

  /// OpenAI API endpoint for chat completions
  /// This is the URL we send AI requests to
  static const String openAiApiUrl =
      'https://api.openai.com/v1/chat/completions';

  // ============================================
  // TRANSACTION CATEGORIES
  // Predefined categories for organizing transactions
  // ============================================

  /// List of expense categories
  /// Users can categorize their spending into these groups
  static const List<String> expenseCategories = [
    'Food & Dining',      // Restaurants, cafes, food delivery
    'Transportation',     // Gas, public transit, ride-sharing
    'Shopping',           // Clothing, electronics, general shopping
    'Entertainment',      // Movies, games, concerts
    'Bills & Utilities',  // Electricity, water, internet, phone
    'Healthcare',         // Doctor visits, medicine, insurance
    'Education',          // Tuition, books, courses
    'Travel',             // Flights, hotels, vacation expenses
    'Groceries',          // Supermarket, food shopping
    'Other',              // Miscellaneous expenses
  ];

  /// List of income categories
  /// Users can categorize their income sources
  static const List<String> incomeCategories = [
    'Salary',          // Regular job income
    'Freelance',       // Contract work, gigs
    'Business',        // Business profits
    'Investment',      // Dividends, interest, capital gains
    'Other Income',    // Miscellaneous income
  ];

  // ============================================
  // DATE FORMATS
  // Standardized date formatting throughout the app
  // ============================================

  /// Full date format: "Jan 15, 2024"
  static const String dateFormat = 'MMM dd, yyyy';

  /// Month and year format: "January 2024"
  static const String monthYearFormat = 'MMMM yyyy';

  /// Short date format: "15/01/24"
  static const String shortDateFormat = 'dd/MM/yy';

  // ============================================
  // PAGINATION
  // Controls how many items load at once
  // ============================================

  /// Number of transactions to load per page
  /// Lower numbers = faster loading, more frequent pagination
  /// Higher numbers = fewer page loads, more initial load time
  static const int transactionsPerPage = 20;

  // ============================================
  // IMAGE PROCESSING
  // Settings for image compression and quality
  // ============================================

  /// Maximum width for processed images (in pixels)
  /// Images larger than this will be resized to save storage/bandwidth
  static const int maxImageWidth = 1920;

  /// Maximum height for processed images (in pixels)
  static const int maxImageHeight = 1080;

  /// Image quality for compression (0-100)
  /// 85 provides good balance between quality and file size
  static const int imageQuality = 85;

  // ============================================
  // CURRENCY SETTINGS
  // Default currency configuration
  // ============================================

  /// ISO currency code
  static const String defaultCurrency = 'USD';

  /// Currency symbol to display
  static const String currencySymbol = '\$';

  // ============================================
  // AI CHAT SUGGESTED QUESTIONS
  // Pre-written questions users can tap to ask the AI
  // ============================================

  /// List of suggested questions for the AI chat feature
  /// These appear as quick-action buttons in the chat interface
  static const List<String> aiSuggestedQuestions = [
    'How much did I spend this month?',
    'What\'s my biggest expense category?',
    'Show me all food expenses',
    'Give me spending insights',
    'How much did I earn this month?',
  ];
}

/// CategoryIcons maps category names to emoji icons
/// This provides visual representation for each transaction category
class CategoryIcons {
  /// Map of category name to emoji icon
  /// Used to display icons next to categories throughout the app
  static const Map<String, String> icons = {
    // Expense category icons
    'Food & Dining': '🍽️',
    'Transportation': '🚗',
    'Shopping': '🛍️',
    'Entertainment': '🎬',
    'Bills & Utilities': '💡',
    'Healthcare': '🏥',
    'Education': '📚',
    'Travel': '✈️',
    'Groceries': '🛒',
    'Other': '📌',

    // Income category icons
    'Salary': '💰',
    'Freelance': '💼',
    'Business': '🏢',
    'Investment': '📈',
    'Other Income': '💵',
  };
}

/// SupabaseTables contains the names of all database tables
/// Using constants prevents typos when querying the database
class SupabaseTables {
  /// Table storing all transaction records
  static const String transactions = 'transactions';

  /// Table storing uploaded document images (receipts, invoices)
  static const String documents = 'documents';

  /// Table storing user account information
  static const String users = 'users';
}
