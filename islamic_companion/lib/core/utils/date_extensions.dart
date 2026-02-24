// ============================================================
// date_extensions.dart
// Date/time utility functions used across all feature modules.
// Using extension methods for clean, idiomatic Dart.
// ============================================================

import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Returns true if this date is the same calendar day as [other]
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns true if this date is yesterday relative to [other]
  bool isYesterdayOf(DateTime other) {
    final yesterday = other.subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Format: "Monday, 24 Feb 2026"
  String toDisplayDate() => DateFormat('EEEE, d MMM yyyy').format(this);

  /// Format: "24 Feb"
  String toShortDate() => DateFormat('d MMM').format(this);

  /// Format: "04:30 AM"
  String toTimeString() => DateFormat('hh:mm a').format(this);

  /// Format: "HH:mm" 24-hour
  String to24HourTimeString() => DateFormat('HH:mm').format(this);

  /// ISO date string for Hive key (YYYY-MM-DD)
  String toHiveKey() => DateFormat('yyyy-MM-dd').format(this);

  /// Returns start of the day (midnight)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the first day of the current month
  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  /// Returns total days in the month
  int get daysInMonth => DateTime(year, month + 1, 0).day;
}

/// Format a Duration as HH:MM:SS countdown string
String formatCountdown(Duration duration) {
  if (duration.isNegative) return '00:00:00';
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

/// Returns the number of days between two dates (ignoring time)
int daysBetween(DateTime from, DateTime to) {
  final f = DateTime(from.year, from.month, from.day);
  final t = DateTime(to.year, to.month, to.day);
  return t.difference(f).inDays;
}
