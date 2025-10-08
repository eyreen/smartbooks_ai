// Import intl package for date formatting
import 'package:intl/intl.dart';

/// DateFormatter provides utility methods for formatting dates
/// This ensures consistent date display throughout the app
class DateFormatter {
  // ============================================
  // DATE FORMATTING METHODS
  // ============================================

  /// Format a date with optional custom format
  ///
  /// Parameters:
  /// - date: The DateTime to format
  /// - format: Optional custom format string (defaults to 'MMM dd, yyyy')
  ///
  /// Examples:
  /// formatDate(DateTime(2024, 1, 15)) returns "Jan 15, 2024"
  /// formatDate(DateTime(2024, 1, 15), format: 'yyyy-MM-dd') returns "2024-01-15"
  static String formatDate(DateTime date, {String? format}) {
    return DateFormat(format ?? 'MMM dd, yyyy').format(date);
  }

  /// Format date as month and year only
  ///
  /// Example:
  /// formatMonthYear(DateTime(2024, 1, 15)) returns "January 2024"
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Format date in short format (numeric)
  ///
  /// Example:
  /// formatShortDate(DateTime(2024, 1, 15)) returns "15/01/24"
  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }

  /// Format time in 12-hour format with AM/PM
  ///
  /// Example:
  /// formatTime(DateTime(2024, 1, 15, 14, 30)) returns "02:30 PM"
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  // ============================================
  // RELATIVE DATE METHODS
  // ============================================

  /// Get relative date string (e.g., "Today", "2 days ago")
  /// This makes dates more human-readable
  ///
  /// Examples:
  /// - Same day: "Today"
  /// - 1 day ago: "Yesterday"
  /// - 3 days ago: "3 days ago"
  /// - 2 weeks ago: "2 weeks ago"
  /// - 3 months ago: "3 months ago"
  /// - 2 years ago: "2 years ago"
  static String getRelativeDate(DateTime date) {
    // Get current time
    final now = DateTime.now();

    // Calculate time difference
    final difference = now.difference(date);

    // Return appropriate string based on how long ago the date was
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // Less than a week: show days
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      // Less than a month: show weeks
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      // Less than a year: show months
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      // More than a year: show years
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Format a date range as a string
  /// Useful for displaying report periods
  ///
  /// Example:
  /// formatDateRange(DateTime(2024, 1, 1), DateTime(2024, 1, 31))
  /// returns "Jan 01 - Jan 31, 2024"
  static String formatDateRange(DateTime start, DateTime end) {
    final startFormatted = DateFormat('MMM dd').format(start);
    final endFormatted = DateFormat('MMM dd, yyyy').format(end);
    return '$startFormatted - $endFormatted';
  }

  // ============================================
  // DATE COMPARISON METHODS
  // ============================================

  /// Check if a date is today
  ///
  /// Example:
  /// isToday(DateTime.now()) returns true
  /// isToday(DateTime(2024, 1, 1)) returns false (unless today is Jan 1, 2024)
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    // Compare year, month, and day (ignore time)
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if a date is in the current month
  ///
  /// Example:
  /// isThisMonth(DateTime(2024, 1, 15)) returns true if current month is January 2024
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    // Compare year and month only
    return date.year == now.year && date.month == now.month;
  }

  // ============================================
  // DATE RANGE CALCULATION METHODS
  // ============================================

  /// Get the first day of the month for a given date
  ///
  /// Example:
  /// getStartOfMonth(DateTime(2024, 1, 15)) returns DateTime(2024, 1, 1, 0, 0, 0)
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the last moment of the month for a given date
  /// Sets day to 0 of next month (which gives last day of current month)
  ///
  /// Example:
  /// getEndOfMonth(DateTime(2024, 1, 15)) returns DateTime(2024, 1, 31, 23, 59, 59)
  static DateTime getEndOfMonth(DateTime date) {
    // Month + 1 with day 0 gives last day of current month
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  /// Get the start of the week (Monday) for a given date
  /// weekday: 1 = Monday, 7 = Sunday
  ///
  /// Example:
  /// If date is Wednesday (weekday=3), subtracts 2 days to get Monday
  static DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get the end of the week (Sunday) for a given date
  ///
  /// Example:
  /// If date is Wednesday (weekday=3), adds 4 days to get Sunday
  static DateTime getEndOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }
}
