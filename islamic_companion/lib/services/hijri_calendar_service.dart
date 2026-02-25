// ============================================================
// hijri_calendar_service.dart
// Wraps the Hijri package. Provides: current Hijri date,
// Gregorian↔Hijri conversion, Pakistani Islamic events list.
// Moon adjustment saved in SharedPreferences for persistence.
// ============================================================

import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HijriCalendarService {
  static const String _moonAdjustmentKey = 'moon_sighting_adjustment';
  SharedPreferences? _prefs;

  Future<void> ensureInit() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  int get moonAdjustment {
    // Ensure prefs are initialized if this is called before initialization completes
    // This will return 0 if not yet loaded; load() will refresh the value after ensureInit.
    return _prefs?.getInt(_moonAdjustmentKey) ?? 0;
  }

  /// Current Hijri date with moon adjustment applied
  HijriCalendar getCurrentHijriDate() {
    final now = HijriCalendar.now();
    final adjustment = moonAdjustment;
    if (adjustment == 0) return now;

    // Apply +/- 1 day adjustment by converting to Gregorian and back
    final gregorian = DateTime.now().add(Duration(days: adjustment));
    return HijriCalendar.fromDate(gregorian);
  }

  DateTime gregorianNow() => DateTime.now();

  /// Convert a Gregorian date to Hijri with moon adjustment applied
  HijriCalendar toHijri(DateTime date) {
    final adjustment = moonAdjustment;
    if (adjustment == 0) {
      return HijriCalendar.fromDate(date);
    }
    // Apply adjustment by adding/subtracting days
    final adjustedDate = date.add(Duration(days: adjustment));
    return HijriCalendar.fromDate(adjustedDate);
  }

  /// Convert Hijri to Gregorian
  DateTime toGregorian(int hYear, int hMonth, int hDay) {
    final h = HijriCalendar()
      ..hYear = hYear
      ..hMonth = hMonth
      ..hDay = hDay;
    return h.hijriToGregorian(hYear, hMonth, hDay);
  }

  Future<void> setMoonAdjustment(int days) async {
    await ensureInit();
    await _prefs?.setInt(_moonAdjustmentKey, days);
  }

  /// Ensure preferences are initialized (public for providers to call during load)
  Future<void> loadMoonAdjustment() async {
    await ensureInit();
  }

  /// Full Hijri month name
  String getHijriMonthName(int month) {
    const months = [
      'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Shaban',
      'Ramadan', 'Shawwal', 'Dhul Qadah', 'Dhul Hijjah',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  /// Pakistani Islamic holidays (static, offline)
  List<Map<String, dynamic>> getPakistanIslamicEvents() {
    return [
      {'name': '12 Rabi al-Awwal (Milad un Nabi)', 'hMonth': 3, 'hDay': 12},
      {'name': '27 Rajab (Shab-e-Miraj)', 'hMonth': 7, 'hDay': 27},
      {'name': '15 Shaban (Shab-e-Barat)', 'hMonth': 8, 'hDay': 15},
      {'name': '1 Ramadan (Start of Ramadan)', 'hMonth': 9, 'hDay': 1},
      {'name': '27 Ramadan (Laylat al-Qadr)', 'hMonth': 9, 'hDay': 27},
      {'name': '1 Shawwal (Eid ul Fitr)', 'hMonth': 10, 'hDay': 1},
      {'name': '9 Dhul Hijjah (Day of Arafah)', 'hMonth': 12, 'hDay': 9},
      {'name': '10 Dhul Hijjah (Eid ul Adha)', 'hMonth': 12, 'hDay': 10},
      {'name': '1 Muharram (Islamic New Year)', 'hMonth': 1, 'hDay': 1},
      {'name': '10 Muharram (Ashura)', 'hMonth': 1, 'hDay': 10},
    ];
  }

  /// Returns events for specific Hijri month/day
  List<String> getEventsForDay(int hMonth, int hDay) {
    return getPakistanIslamicEvents()
        .where((e) => e['hMonth'] == hMonth && e['hDay'] == hDay)
        .map((e) => e['name'] as String)
        .toList();
  }
}
