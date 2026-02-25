// ============================================================
// providers_setup.dart
// MultiProvider tree assembled here. All feature providers are
// registered in this single file, keeping main.dart clean.
// ============================================================

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/services/location_service.dart';
import 'package:islamic_companion/services/prayer_time_service.dart';
import 'package:islamic_companion/services/notification_service.dart';
import 'package:islamic_companion/services/ramazan_service.dart';
import 'package:islamic_companion/services/zakat_calculator_service.dart';
import 'package:islamic_companion/services/daily_content_service.dart';
import 'package:islamic_companion/services/hijri_calendar_service.dart';

import 'package:islamic_companion/features/prayer/data/models/prayer_settings_model.dart';
import 'package:islamic_companion/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:islamic_companion/features/prayer/providers/prayer_times_provider.dart';

import 'package:islamic_companion/features/namaz_streak/data/models/namaz_day_model.dart';
import 'package:islamic_companion/features/namaz_streak/data/repositories/namaz_streak_repository_impl.dart';
import 'package:islamic_companion/features/namaz_streak/providers/namaz_streak_provider.dart';

import 'package:islamic_companion/features/tasbeeh/data/models/tasbeeh_model.dart';
import 'package:islamic_companion/features/tasbeeh/data/repositories/tasbeeh_repository_impl.dart';
import 'package:islamic_companion/features/tasbeeh/providers/tasbeeh_provider.dart';

import 'package:islamic_companion/features/ramazan/data/models/ramazan_day_model.dart';
import 'package:islamic_companion/features/ramazan/data/repositories/ramazan_repository_impl.dart';
import 'package:islamic_companion/features/ramazan/providers/ramazan_provider.dart';

import 'package:islamic_companion/features/zakat/data/models/zakat_record_model.dart';
import 'package:islamic_companion/features/zakat/data/repositories/zakat_repository_impl.dart';
import 'package:islamic_companion/features/zakat/providers/zakat_provider.dart';

import 'package:islamic_companion/features/hijri_calendar/data/models/calendar_settings_model.dart';
import 'package:islamic_companion/features/hijri_calendar/providers/hijri_calendar_provider.dart';

import 'package:islamic_companion/features/daily_content/providers/daily_content_provider.dart';

List<SingleChildWidget> buildProviders({
  required NotificationService notificationService,
}) {
  return [
    // ── Services & Repositories ───────────────────────────
    Provider<NotificationService>.value(value: notificationService),
    Provider<LocationService>(create: (_) => LocationService()),
    Provider<PrayerTimeService>(create: (_) => PrayerTimeService()),
    Provider<RamazanService>(create: (_) => RamazanService()),
    Provider<DailyContentService>(create: (_) => DailyContentService()),
    Provider<ZakatCalculatorService>(create: (_) => ZakatCalculatorService()),
    Provider<HijriCalendarService>(create: (_) => HijriCalendarService()),
    
    // ── Feature Providers ─────────────────────────────────
    
    // 1. Prayer Times
    ChangeNotifierProvider<PrayerTimesProvider>(
      create: (context) => PrayerTimesProvider(
        prayerService: context.read<PrayerTimeService>(),
        locationService: context.read<LocationService>(),
        repository: PrayerRepositoryImpl(
          Hive.box<PrayerSettingsModel>(AppConstants.prayerSettingsBox),
        ),
        notificationService: notificationService,
      )..initialize(),
    ),

    // 6. Hijri Calendar - must be before Ramadan
    ChangeNotifierProvider<HijriCalendarProvider>(
      create: (context) => HijriCalendarProvider(
        service: context.read<HijriCalendarService>(),
      )..load(),
    ),

    // 4. Ramazan Module - depends on HijriCalendarProvider
    ChangeNotifierProxyProvider<PrayerTimesProvider, RamazanProvider>(
      create: (context) => RamazanProvider(
        repository: RamazanRepositoryImpl(
          Hive.box<RamazanDayModel>(AppConstants.ramazanBox),
        ),
        ramazanService: context.read<RamazanService>(),
        notificationService: notificationService,
        hijriService: context.read<HijriCalendarService>(),
      )..initialize(prayerSettings: null),
      update: (context, prayerProvider, ramazanProvider) {
        if (prayerProvider.settings != null && ramazanProvider != null) {
          ramazanProvider.updatePrayerSettings(prayerProvider.settings);
        }
        return ramazanProvider!;
      },
    ),

    // 2. Namaz Streak
    ChangeNotifierProvider<NamazStreakProvider>(
      create: (context) => NamazStreakProvider(
        repository: NamazStreakRepositoryImpl(
          Hive.box<NamazDayModel>(AppConstants.namazStreakBox),
        ),
      )..loadToday(),
    ),

    // 3. Tasbeeh History
    ChangeNotifierProxyProvider<PrayerTimesProvider, TasbeehProvider>(
      create: (context) => TasbeehProvider(
        repository: TasbeehRepositoryImpl(
          Hive.box<TasbeehModel>(AppConstants.tasbeehBox),
        ),
      )..loadAll(),
      update: (context, prayerProvider, tasbeehProvider) => tasbeehProvider!,
    ),

    // 4. Ramazan Module

    // 5. Zakat Calculator
    ChangeNotifierProvider<ZakatProvider>(
      create: (context) => ZakatProvider(
        repository: ZakatRepositoryImpl(
          Hive.box<ZakatRecordModel>(AppConstants.zakatBox),
        ),
        calculator: context.read<ZakatCalculatorService>(),
      )..loadHistory(),
    ),

    // 7. Daily Content
    ChangeNotifierProvider<DailyContentProvider>(
      create: (context) => DailyContentProvider(
        service: context.read<DailyContentService>(),
      )..load(),
    ),
  ];
}
