# SmartBooks AI - Quick Setup Guide

## 📋 Step-by-Step Setup (For Students)

### Step 1: Verify Flutter Installation
```bash
flutter doctor
```
Make sure all checkmarks are green.

### Step 2: Get Dependencies
```bash
cd C:\Users\User\Downloads\flutter_test\smartbooks_ai
flutter pub get
```

### Step 3: Set Up Supabase (Free)

1. **Create Account**
   - Visit https://supabase.com
   - Sign up with GitHub/Google
   - Create new project (choose free tier)

2. **Create Tables**
   - Go to SQL Editor in Supabase dashboard
   - Copy and run this SQL:

```sql
-- Transactions Table
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
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

-- Documents Table
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
  file_name TEXT NOT NULL,
  file_url TEXT NOT NULL,
  type TEXT NOT NULL,
  extracted_text TEXT,
  extracted_data JSONB,
  is_processed BOOLEAN DEFAULT FALSE,
  uploaded_at TIMESTAMP DEFAULT NOW(),
  processed_at TIMESTAMP
);

-- Insert sample data for testing
INSERT INTO transactions (title, amount, category, type, date) VALUES
('Starbucks Coffee', 5.50, 'Food & Dining', 'expense', NOW()),
('Uber Ride', 15.00, 'Transportation', 'expense', NOW() - INTERVAL '1 day'),
('Grocery Shopping', 87.32, 'Groceries', 'expense', NOW() - INTERVAL '2 days'),
('Netflix Subscription', 15.99, 'Entertainment', 'expense', NOW() - INTERVAL '3 days'),
('Salary', 3000.00, 'Salary', 'income', NOW() - INTERVAL '5 days'),
('Amazon Purchase', 49.99, 'Shopping', 'expense', NOW() - INTERVAL '7 days'),
('Gym Membership', 35.00, 'Healthcare', 'expense', NOW() - INTERVAL '10 days');
```

3. **Get API Keys**
   - Go to Settings → API
   - Copy **Project URL** (looks like: `https://xxx.supabase.co`)
   - Copy **anon public** key (long string)

### Step 4: Set Up OpenAI (Paid - $5 minimum)

1. **Create Account**
   - Visit https://platform.openai.com
   - Sign up and verify email
   - Go to Billing → Add payment method
   - Add $5-$10 credits

2. **Create API Key**
   - Go to API Keys section
   - Click "Create new secret key"
   - Copy the key (starts with `sk-`)
   - **Save it immediately** (you can't see it again!)

### Step 5: Configure the App

1. **Open** `lib/core/constants/app_constants.dart`

2. **Replace these lines:**
```dart
// BEFORE:
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';

// AFTER:
static const String supabaseUrl = 'https://xxxxx.supabase.co'; // Your URL
static const String supabaseAnonKey = 'eyJhbGc...'; // Your anon key
static const String openAiApiKey = 'sk-proj-...'; // Your OpenAI key
```

3. **Open** `lib/main.dart`

4. **Uncomment line 17:**
```dart
// BEFORE:
// await SupabaseService.initialize();

// AFTER:
await SupabaseService.initialize();
```

### Step 6: Run the App

```bash
flutter run
```

Choose your device (Android emulator, iOS simulator, or physical device).

---

## 🧪 Testing Without APIs (Demo Mode)

If you don't want to set up APIs yet, you can test with mock data:

1. **Keep Supabase initialization commented** in `main.dart`
2. **Comment out API calls** in providers
3. **Use sample data** directly in the UI

Example for `transaction_provider.dart`:
```dart
Future<void> loadTransactions() async {
  _isLoading = true;
  notifyListeners();

  // Mock data instead of API call
  _transactions = [
    TransactionModel.create(
      userId: 'demo',
      title: 'Coffee Shop',
      amount: 5.50,
      category: 'Food & Dining',
      type: TransactionType.expense,
      date: DateTime.now(),
    ),
    // Add more...
  ];

  _isLoading = false;
  notifyListeners();
}
```

---

## 🎯 What You'll See

### Home Screen
- 3 colored cards showing Income, Expense, Balance
- Pie chart showing spending by category
- List of recent transactions
- Floating "Scan" button (UI only for now)

### Transactions Screen
- Full list of all transactions
- Each transaction shows icon, title, category, date, and amount
- Color coded (green for income, red for expense)

### AI Chat Screen
- Chat interface with suggested questions
- Send messages to AI assistant
- Get responses about your spending
- **Note**: Requires OpenAI API key to work

### Reports Screen
- Placeholder screen (Coming soon)

---

## 📱 App Features Status

✅ **Working:**
- Modern UI with animations
- Dashboard with real-time stats
- Transaction list
- Category charts
- AI chat interface
- Theme support (light/dark)
- State management
- Supabase integration
- OpenAI GPT integration
- OCR service setup

⏳ **Not Yet Implemented:**
- Camera scanning screen
- Manual transaction entry form
- Transaction editing
- Detailed reports
- Export functionality
- Document storage

---

## 🐛 Troubleshooting

### App won't build
```bash
flutter clean
flutter pub get
flutter run
```

### "No MaterialLocalizations found" error
- Restart the app
- Make sure all imports are correct

### Supabase connection error
- Check your URL and anon key
- Make sure initialization is uncommented
- Verify internet connection
- Check Supabase project is active

### OpenAI API error
- Verify API key is correct
- Check you have credits ($5+ recommended)
- Test API key at https://platform.openai.com/playground

### Charts not showing
- Make sure you have transactions in database
- Check category names match the constants
- Restart the app

---

## 💰 Cost Estimate

| Service | Free Tier | Student Usage |
|---------|-----------|---------------|
| **Supabase** | 500MB database, 1GB storage | ✅ More than enough |
| **OpenAI API** | No free tier | ~$2-5 for testing |
| **Google ML Kit** | Free on-device | ✅ Completely free |
| **Flutter** | Open source | ✅ Free |

**Total Cost for Learning**: $5-10 for OpenAI credits (one-time)

---

## 📚 Next Steps After Setup

1. **Explore the code structure** - Check each file and understand the architecture
2. **Modify the theme** - Change colors in `app_theme.dart`
3. **Add more categories** - Update `app_constants.dart`
4. **Create the scanning screen** - Implement camera capture
5. **Add transaction form** - Build manual entry screen
6. **Enhance AI prompts** - Improve responses in `ai_service.dart`
7. **Add more charts** - Implement line charts for trends
8. **Export feature** - Generate PDF reports

---

## 🤝 Getting Help

1. **Read the code comments** - Most files have explanations
2. **Check Flutter docs** - https://docs.flutter.dev
3. **Supabase docs** - https://supabase.com/docs
4. **OpenAI docs** - https://platform.openai.com/docs

---

**Happy Coding! 🚀**

*Built with Flutter & AI for educational purposes*
