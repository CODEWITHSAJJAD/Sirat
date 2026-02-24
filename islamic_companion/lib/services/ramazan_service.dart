// ============================================================
// ramazan_service.dart
// Detects if current Hijri month is Ramadan (month 9).
// Provides Sehr/Iftar times via PrayerTimeService.
// ============================================================

import 'package:hijri/hijri_calendar.dart';

class RamazanService {
  /// Returns true if today is in Hijri month 9 (Ramadan)
  /// Applies moon sighting adjustment for Pakistan (+1 day typically)
  bool isRamadanActive({int moonAdjustment = 0}) {
    final hijri = _getAdjustedHijri(moonAdjustment);
    return hijri.hMonth == 9;
  }

  /// Returns current Hijri month number with adjustment
  int getCurrentHijriMonth({int moonAdjustment = 0}) {
    final hijri = _getAdjustedHijri(moonAdjustment);
    return hijri.hMonth;
  }

  /// Returns today's Ramadan day number (1-30), null if not Ramadan
  int? getRamadanDayNumber({int moonAdjustment = 0}) {
    final hijri = _getAdjustedHijri(moonAdjustment);
    if (hijri.hMonth != 9) return null;
    return hijri.hDay;
  }

  /// Helper to get adjusted Hijri date
  HijriCalendar _getAdjustedHijri(int moonAdjustment) {
    if (moonAdjustment == 0) return HijriCalendar.now();
    final adjusted = DateTime.now().add(Duration(days: moonAdjustment));
    return HijriCalendar.fromDate(adjusted);
  }

  /// Badge threshold check: returns badge label for streak milestone
  String? getBadgeForStreak(int streak) {
    if (streak >= 30) return '🏆 Full Month';
    if (streak >= 15) return '🥈 Half Month';
    if (streak >= 7) return '🥉 7 Days';
    return null;
  }
}
