// ============================================================
// hijri_calendar_service.dart
// Wraps the Hijri package. Provides: current Hijri date,
// Gregorian↔Hijri conversion, Pakistani Islamic events list.
// Moon adjustment (+/- 1 day) saved in Hive CalendarSettings.
// ============================================================

import 'package:hijri/hijri_calendar.dart';
import 'package:hive/hive.dart';
import 'package:islamic_companion/features/hijri_calendar/data/models/calendar_settings_model.dart';

class HijriCalendarService {
  final Box<CalendarSettingsModel> _box;
  static const String _settingsKey = 'cal_settings';

  HijriCalendarService(this._box);

  int get moonAdjustment => _box.get(_settingsKey)?.moonAdjustment ?? 0;

  /// Current Hijri date with moon adjustment applied
  HijriCalendar getCurrentHijriDate() {
    final now = HijriCalendar.now();
    if (moonAdjustment == 0) return now;

    // Apply +/- 1 day adjustment by converting to Gregorian and back
    final gregorian = DateTime.now().add(Duration(days: moonAdjustment));
    return HijriCalendar.fromDate(gregorian);
  }

  DateTime gregorianNow() => DateTime.now();

  /// Convert a Gregorian date to Hijri
  HijriCalendar toHijri(DateTime date) {
    return HijriCalendar.fromDate(date);
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
    final model = _box.get(_settingsKey) ??
        CalendarSettingsModel(moonAdjustment: 0);
    model.moonAdjustment = days;
    await _box.put(_settingsKey, model);
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
      {'name': '12 Rabi al-Awwal (Milad un Nabi ﷺ)', 'hMonth': 3, 'hDay': 12},
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
