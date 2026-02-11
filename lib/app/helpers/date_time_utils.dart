import 'package:intl/intl.dart';

class DateTimeUtils {
  // Date format constants
  static const String kFormatMonthDay = "MMM dd";
  static const String kFormatISODateTime = "yyyy-MM-ddTHH:mm:ss.SSSZ";
  static const String kFormatFullDate = "EEE dd MMM, yyyy";
  static const String kFormatTime = "HH:mm";
  static const String kFormatDay = "dd";
  static const String kFormatWeekOfDay = "E";
  static const String kFormatJournalDate = "EEE, dd MMM";
  static const String kFormatJournalDateKey = "yyyy-MM-dd";
  static const String dobFormat = "yyyy-MM-dd";
  static const String dobUIFormat = "MMM dd, yyyy";
  static const String mediaPlayerFormatKey = "mm:ss";
  static const String creditDateTimeFormat = "yyyy-MM-ddTHH:mm:ss";
  static const String creditDateTimeOutputFormat = "hh:mm a, MMM dd";

  // Cache DateFormat instances for better performance
  static final Map<String, DateFormat> _formatters = {};

  /// Gets or creates a DateFormat instance for the given format
  static DateFormat _getFormatter(String format) {
    return _formatters.putIfAbsent(format, () => DateFormat(format));
  }

  /// Returns the start of the week (Monday) for the given date
  static DateTime getStartOfWeek(DateTime date) {
    final daysFromMonday = (date.weekday - DateTime.monday) % 7;
    return date.subtract(Duration(days: daysFromMonday));
  }

  /// Returns the current date time
  static DateTime getNow() {
    return DateTime.now();
  }

  /// Formats a DateTime using the specified format
  ///
  /// Returns formatted string or empty string if formatting fails
  static String formatDate(String format, DateTime? dateTime) {
    if (dateTime == null) return '';

    try {
      final formatter = _getFormatter(format);
      return formatter.format(dateTime);
    } catch (e) {
      _logError('Error formatting date', e);
      return '';
    }
  }

  /// Converts a date string from one format to another
  ///
  /// Returns formatted string or empty string if parsing/formatting fails
  static String formatResponseDate(
      String oldFormat, String newFormat, String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';

    try {
      final inputFormatter = _getFormatter(oldFormat);
      final outputFormatter = _getFormatter(newFormat);

      final parsedDate = inputFormatter.parse(dateTime, true);
      return outputFormatter.format(parsedDate.toLocal());
    } catch (e) {
      _logError('Error converting date format', e);
      return '';
    }
  }

  static DateTime formatResponseDateTime(String dateFormat, String? dateTime) {
    final inputFormatter = _getFormatter(dateFormat);
    final parsedDate = inputFormatter.parse(dateTime!, true);
    return parsedDate;
  }

  /// Utility method for UTC conversion
  static DateTime toUTC(DateTime dateTime) {
    return dateTime.isUtc ? dateTime : dateTime.toUtc();
  }

  /// Utility method for local conversion
  static DateTime toLocal(DateTime dateTime) {
    return dateTime.isUtc ? dateTime.toLocal() : dateTime;
  }

  /// Returns true if two dates are the same day
  static bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;

    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Logs errors in debug mode
  static void _logError(String message, Object error) {
    assert(() {
      return true;
    }());
  }

  static String mediaPlayerFormat(Duration duration) {
    return DateFormat(mediaPlayerFormatKey)
        .format(DateTime(0, 0, 0, 0, 0, duration.inSeconds));
  }

  static String getTimeZoneOffset() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    final hours = offset.inHours.abs();
    final minutes = offset.inMinutes.remainder(60).abs();
    final sign = offset.isNegative ? '-' : '+';

    return 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';
  }

  static String getTimeAgo(String createdAt) {
    try {
      final created = DateTime.parse(createdAt).toLocal();
      final now = DateTime.now();
      final diff = now.difference(created);

      if (diff.inSeconds < 60) {
        return 'now';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}d ago';
      } else if (diff.inDays < 30) {
        final weeks = (diff.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (diff.inDays < 365) {
        final months = (diff.inDays / 30).floor();
        return '${months}mo ago';
      } else {
        final years = (diff.inDays / 365).floor();
        return '${years}y ago';
      }
    } catch (e) {
      return '';
    }
  }
}
