# SmartBooks AI - AI-Powered Accounting Assistant

A modern Flutter application demonstrating AI-powered document intelligence for accounting and expense management. Built for educational purposes to showcase integration of OCR, GPT APIs, and real-time database.

## 🎯 Features

### Core Features
- **📸 Smart Document Scanning**: Camera-based receipt/invoice capture with AI-powered OCR
- **🤖 AI Document Processing**: Automatic data extraction (merchant, amount, date, category)
- **💬 AI Chat Assistant**: Natural language queries about expenses and spending
- **📊 Real-time Dashboard**: Visual analytics with charts and statistics
- **💰 Transaction Management**: Track income and expenses with categorization
- **📈 Spending Insights**: AI-generated financial insights and recommendations
- **🎨 Modern UI**: Clean, professional interface with smooth animations

### AI Capabilities
1. **OCR (Optical Character Recognition)**: Extract text from images using Google ML Kit
2. **GPT-4 Integration**: Intelligent document understanding and categorization
3. **Natural Language Processing**: Chat with your financial data
4. **Smart Categorization**: Automatic expense category prediction
5. **Spending Insights**: AI-powered financial analysis

## 🏗️ Architecture

```
lib/
├── config/                  # App configuration
│   ├── app_theme.dart      # Modern theme with light/dark mode
│   └── routes.dart         # Navigation routes
├── core/                    # Core utilities
│   ├── constants/          # App constants and configuration
│   └── utils/              # Helper functions (formatters, validators)
├── data/                    # Data layer
│   ├── models/             # Data models (Transaction, Document, etc.)
│   ├── services/           # Services (Supabase, AI, OCR)
│   └── repositories/       # Data repositories (future)
├── providers/               # State management (Provider pattern)
│   ├── transaction_provider.dart
│   ├── ai_chat_provider.dart
│   └── theme_provider.dart
├── screens/                 # UI screens
│   ├── home/               # Dashboard screen
│   ├── transactions/       # Transaction management
│   ├── ai_chat/           # AI chat interface
│   └── reports/           # Analytics and reports
└── widgets/                 # Reusable widgets
    └── common/             # Common UI components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.3.0)
- Dart SDK
- Android Studio / VS Code
- An Android/iOS device or emulator

### Installation

1. **Install dependencies**
```bash
flutter pub get
```

2. **Set up Supabase** (Backend Database)
   - Go to [https://supabase.com](https://supabase.com)
   - Create a new project
   - Create the following tables:

   **transactions table:**
   ```sql
   CREATE TABLE transactions (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID NOT NULL,
     title TEXT NOT NULL,
     amount DECIMAL(10, 2) NOT NULL,
     category TEXT NOT NULL,
     type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
     date TIMESTAMP NOT NULL,
     description TEXT,
     document_id UUID,
     is_ai_generated BOOLEAN DEFAULT FALSE,
     created_at TIMESTAMP DEFAULT NOW(),
     updated_at TIMESTAMP DEFAULT NOW()
   );
   ```

   **documents table:**
   ```sql
   CREATE TABLE documents (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID NOT NULL,
     file_name TEXT NOT NULL,
     file_url TEXT NOT NULL,
     type TEXT NOT NULL,
     extracted_text TEXT,
     extracted_data JSONB,
     is_processed BOOLEAN DEFAULT FALSE,
     uploaded_at TIMESTAMP DEFAULT NOW(),
     processed_at TIMESTAMP
   );
   ```

   - Get your **Project URL** and **Anon Key** from Settings > API

3. **Set up OpenAI API**
   - Go to [https://platform.openai.com](https://platform.openai.com)
   - Create an API key
   - Copy the API key

4. **Configure API Keys**
   - Open `lib/core/constants/app_constants.dart`
   - Replace the placeholder values:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';
   ```

5. **Enable Supabase in main.dart**
   - Open `lib/main.dart`
   - Uncomment line 17:
   ```dart
   await SupabaseService.initialize();
   ```

6. **Run the app**
```bash
flutter run
```

## 📱 App Screens

### 1. Home Dashboard
- Total income, expense, and balance cards
- Category spending pie chart
- Recent transactions list
- Quick scan button

### 2. Transactions
- Full transaction history
- Filter and search
- Add manual transactions
- Transaction details

### 3. AI Chat
- Natural language queries
- Suggested questions
- Real-time financial insights
- Context-aware responses

### 4. Reports
- Coming soon: Detailed analytics and reports

## 🔧 Key Technologies

### Flutter Packages
- **provider** - State management
- **supabase_flutter** - Backend database and auth
- **google_mlkit_text_recognition** - OCR
- **http** - API calls to OpenAI
- **camera** - Document capture
- **image_picker** - Image selection
- **fl_chart** - Charts and graphs
- **google_fonts** - Typography
- **intl** - Internationalization
- **lottie** - Animations

### External Services
- **Supabase**: Backend database, auth, and storage
- **OpenAI GPT-4**: AI processing and chat
- **Google ML Kit**: On-device OCR

## 💡 Usage Examples

### Adding a Transaction
1. Tap the "Scan" button on the home screen
2. Take a photo of a receipt
3. AI will extract data automatically
4. Review and confirm the transaction

### Chatting with AI
1. Go to "AI Chat" tab
2. Ask questions like:
   - "How much did I spend this month?"
   - "What's my biggest expense category?"
   - "Show me all food expenses"
3. Get instant AI-powered insights

### Viewing Analytics
1. Check the home dashboard for overview
2. View category breakdown in the pie chart
3. Browse recent transactions

## 🎓 Learning Outcomes

Students building this project will learn:
- ✅ Clean architecture and folder structure
- ✅ State management with Provider
- ✅ REST API integration (OpenAI)
- ✅ Database operations (Supabase)
- ✅ Camera and image processing
- ✅ OCR implementation
- ✅ AI/ML integration
- ✅ Data visualization with charts
- ✅ Modern UI/UX design
- ✅ Async programming in Dart

## 🔐 Security Notes

**Important**: Never commit API keys to version control!
- Use environment variables in production
- Keep `app_constants.dart` out of git (add to .gitignore)
- Use Supabase Row Level Security (RLS) policies
- Implement proper authentication before production use

## 🐛 Common Issues

### Issue: "No Supabase URL found"
**Solution**: Make sure you've added your Supabase credentials in `app_constants.dart` and uncommented the initialization in `main.dart`.

### Issue: OCR not working
**Solution**: Ensure camera permissions are granted. On Android, check `AndroidManifest.xml` for camera permissions.

### Issue: OpenAI API errors
**Solution**:
- Check if your API key is valid
- Ensure you have credits in your OpenAI account
- Check your internet connection

## 🚀 Future Enhancements

- [ ] Document scanning screen with camera
- [ ] Manual transaction entry form
- [ ] Detailed reports and analytics
- [ ] Export to PDF/CSV
- [ ] Budget tracking
- [ ] Recurring transactions
- [ ] Multi-currency support
- [ ] Receipt image storage
- [ ] Advanced filtering and search
- [ ] Data synchronization
- [ ] Offline mode

## 📄 License

This project is created for educational purposes. Feel free to use and modify for learning.

---

**Built with ❤️ using Flutter, AI, and modern development practices**

*This is a demo application for educational purposes. Not intended for production use without proper security implementation.*
