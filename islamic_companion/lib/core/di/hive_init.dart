// ============================================================
// hive_init.dart
// Centralized Hive initialization: opens all boxes and registers
// all generated TypeAdapters. Called once from main.dart before
// runApp(). Always add new adapters here to keep tracking easy.
// ============================================================

import 'package:hive_flutter/hive_flutter.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/prayer/data/models/prayer_settings_model.dart';
import 'package:islamic_companion/features/namaz_streak/data/models/namaz_day_model.dart';
import 'package:islamic_companion/features/tasbeeh/data/models/tasbeeh_model.dart';
import 'package:islamic_companion/features/ramazan/data/models/ramazan_day_model.dart';
import 'package:islamic_companion/features/zakat/data/models/zakat_record_model.dart';
import 'package:islamic_companion/features/hijri_calendar/data/models/calendar_settings_model.dart';

class HiveInit {
  /// Opens all Hive boxes and registers all TypeAdapters.
  /// Must be called after Hive.initFlutter() in main.dart.
  static Future<void> initialize() async {
    await Hive.initFlutter();
    _registerIfNotDone(() => Hive.registerAdapter(PrayerSettingsModelAdapter()));
    _registerIfNotDone(() => Hive.registerAdapter(NamazDayModelAdapter()));
    _registerIfNotDone(() => Hive.registerAdapter(TasbeehModelAdapter()));
    _registerIfNotDone(() => Hive.registerAdapter(RamazanDayModelAdapter()));
    _registerIfNotDone(() => Hive.registerAdapter(ZakatRecordModelAdapter()));
    _registerIfNotDone(() => Hive.registerAdapter(CalendarSettingsModelAdapter()));

    // ── Open Boxes ────────────────────────────────────────
    await Future.wait([
      Hive.openBox<PrayerSettingsModel>(AppConstants.prayerSettingsBox),
      Hive.openBox<NamazDayModel>(AppConstants.namazStreakBox),
      Hive.openBox<TasbeehModel>(AppConstants.tasbeehBox),
      Hive.openBox<RamazanDayModel>(AppConstants.ramazanBox),
      Hive.openBox<ZakatRecordModel>(AppConstants.zakatBox),
      Hive.openBox<CalendarSettingsModel>(AppConstants.calendarSettingsBox),
      Hive.openBox(AppConstants.appSettingsBox), // dynamic box for misc settings
    ]);
  }

  /// Safely registers adapter only if not already registered.
  static void _registerIfNotDone(void Function() registerFn) {
    try {
      registerFn();
    } catch (_) {
      // Adapter already registered – safe to ignore in hot restart scenarios
    }
  }
}
