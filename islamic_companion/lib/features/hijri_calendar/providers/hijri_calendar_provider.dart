// ============================================================
// hijri_calendar_provider.dart
// ChangeNotifier for Hijri Calendar feature.
// Provides: dual date display, events for selected day,
// moon adjustment toggle, full Islamic events list.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islamic_companion/services/hijri_calendar_service.dart';

class HijriCalendarProvider extends ChangeNotifier {
  final HijriCalendarService _service;

  HijriCalendarProvider({required HijriCalendarService service})
      : _service = service;

  // ── State ──────────────────────────────────────────────────
  HijriCalendar? _currentHijri;
  DateTime _selectedGregorian = DateTime.now();
  HijriCalendar? _selectedHijri;
  List<String> _selectedDayEvents = [];
  int _moonAdjustment = 0;

  // ── Getters ───────────────────────────────────────────────
  HijriCalendar? get currentHijri => _currentHijri;
  DateTime get selectedGregorian => _selectedGregorian;
  HijriCalendar? get selectedHijri => _selectedHijri;
  List<String> get selectedDayEvents => _selectedDayEvents;
  int get moonAdjustment => _moonAdjustment;
  List<Map<String, dynamic>> get allEvents => _service.getPakistanIslamicEvents();

  String get hijriMonthName =>
      _currentHijri != null ? _service.getHijriMonthName(_currentHijri!.hMonth) : '';

  String getHijriMonthName(int month) => _service.getHijriMonthName(month);

  Future<void> load() async {
    // Ensure preferences are initialized before reading values
    await _service.ensureInit();
    _moonAdjustment = _service.moonAdjustment;
    _currentHijri = _service.getCurrentHijriDate();
    _selectedHijri = _currentHijri;
    _selectedDayEvents = _service.getEventsForDay(
      _currentHijri!.hMonth,
      _currentHijri!.hDay,
    );
    notifyListeners();
  }

  void selectDay(DateTime gregorian) {
    _selectedGregorian = gregorian;
    _selectedHijri = _service.toHijri(gregorian);
    _selectedDayEvents = _service.getEventsForDay(
      _selectedHijri!.hMonth,
      _selectedHijri!.hDay,
    );
    notifyListeners();
  }

  Future<void> adjustMoon(int delta) async {
    // Only allow -1, 0, +1
    final newVal = (_moonAdjustment + delta).clamp(-1, 1);
    await _service.setMoonAdjustment(newVal);
    _moonAdjustment = newVal;
    _currentHijri = _service.getCurrentHijriDate();
    // Also update selected day info with new adjustment
    _selectedHijri = _service.toHijri(_selectedGregorian);
    _selectedDayEvents = _service.getEventsForDay(
      _selectedHijri!.hMonth,
      _selectedHijri!.hDay,
    );
    notifyListeners();
  }

  /// Returns true if a given Gregorian date has an Islamic event
  bool hasEventOnGregorianDay(DateTime date) {
    final h = _service.toHijri(date);
    return _service.getEventsForDay(h.hMonth, h.hDay).isNotEmpty;
  }
}
