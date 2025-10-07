class AppConstants {
  static const String appName = 'SmartBooks AI';
  static const String appVersion = '1.0.0';

  // Supabase Configuration (Replace with your actual credentials)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // OpenAI Configuration (Replace with your actual API key)
  static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String openAiModel = 'gpt-4o-mini';

  // API Endpoints
  static const String openAiApiUrl =
      'https://api.openai.com/v1/chat/completions';

  // Transaction Categories
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Groceries',
    'Other',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Business',
    'Investment',
    'Other Income',
  ];

  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String monthYearFormat = 'MMMM yyyy';
  static const String shortDateFormat = 'dd/MM/yy';

  // Pagination
  static const int transactionsPerPage = 20;

  // Image Processing
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;

  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';

  // AI Chat
  static const List<String> aiSuggestedQuestions = [
    'How much did I spend this month?',
    'What\'s my biggest expense category?',
    'Show me all food expenses',
    'Give me spending insights',
    'How much did I earn this month?',
  ];
}

class CategoryIcons {
  static const Map<String, String> icons = {
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
    'Salary': '💰',
    'Freelance': '💼',
    'Business': '🏢',
    'Investment': '📈',
    'Other Income': '💵',
  };
}

class SupabaseTables {
  static const String transactions = 'transactions';
  static const String documents = 'documents';
  static const String users = 'users';
}
