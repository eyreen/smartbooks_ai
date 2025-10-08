// Import intl package for internationalization and number formatting
import 'package:intl/intl.dart';

/// CurrencyFormatter provides utility methods for formatting currency values
/// This ensures consistent currency display throughout the app
class CurrencyFormatter {
  // ============================================
  // PRIVATE FORMATTER INSTANCE
  // ============================================

  /// Private NumberFormat instance for currency formatting
  /// '_' prefix makes it private to this class
  /// final means it's initialized once and never changes
  /// static means one instance is shared across all uses of this class
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: '\$',      // Dollar sign
    decimalDigits: 2,  // Always show 2 decimal places (e.g., $123.45)
  );

  // ============================================
  // FORMATTING METHODS
  // ============================================

  /// Format amount with currency symbol and decimals
  ///
  /// Example:
  /// format(1234.56) returns "$1,234.56"
  /// format(100) returns "$100.00"
  static String format(double amount) {
    return _formatter.format(amount);
  }

  /// Format amount without currency symbol (numbers only)
  /// Useful for input fields or when symbol is shown separately
  ///
  /// Example:
  /// formatWithoutSymbol(1234.56) returns "1,234.56"
  /// formatWithoutSymbol(100) returns "100.00"
  static String formatWithoutSymbol(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }

  /// Format large amounts in compact form (K for thousands, M for millions)
  /// Great for dashboard stats and charts where space is limited
  ///
  /// Examples:
  /// formatCompact(1500) returns "$1.5K"
  /// formatCompact(2500000) returns "$2.5M"
  /// formatCompact(250) returns "$250.00" (no abbreviation for small amounts)
  static String formatCompact(double amount) {
    // Check if amount is in millions (>= 1,000,000)
    if (amount >= 1000000) {
      // Divide by 1 million and round to 1 decimal place
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    }
    // Check if amount is in thousands (>= 1,000)
    else if (amount >= 1000) {
      // Divide by 1 thousand and round to 1 decimal place
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }
    // For amounts less than 1000, show full format
    return format(amount);
  }

  /// Parse a string into a double amount
  /// Removes all non-numeric characters except decimal point
  /// Useful for converting user input text to numbers
  ///
  /// Examples:
  /// parse("$1,234.56") returns 1234.56
  /// parse("1234.56") returns 1234.56
  /// parse("invalid") returns 0.0 (error case)
  static double parse(String amount) {
    try {
      // Use RegExp (Regular Expression) to remove all characters
      // except digits (\d) and decimal point (.)
      // [^\d.] means "match anything that is NOT a digit or decimal point"
      final cleaned = amount.replaceAll(RegExp(r'[^\d.]'), '');

      // Parse the cleaned string to a double
      return double.parse(cleaned);
    } catch (e) {
      // If parsing fails (invalid input), return 0.0
      return 0.0;
    }
  }

  /// Format amount with + or - sign prefix
  /// Useful for showing income (+) vs expense (-) or profit/loss
  ///
  /// Examples:
  /// formatWithSign(100) returns "+$100.00" (positive)
  /// formatWithSign(-50) returns "-$50.00" (negative)
  /// formatWithSign(0) returns "+$0.00" (zero is considered positive)
  static String formatWithSign(double amount) {
    // Get absolute value (remove negative sign) and format it
    final formatted = format(amount.abs());

    // Add appropriate sign prefix
    if (amount >= 0) {
      return '+$formatted';  // Positive: add +
    } else {
      return '-$formatted';  // Negative: add -
    }
  }
}
