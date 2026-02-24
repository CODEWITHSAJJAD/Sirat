import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamic_companion/core/di/hive_init.dart';
import 'package:islamic_companion/core/di/providers_setup.dart';
import 'package:islamic_companion/core/navigation/app_scaffold.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/features/ramazan/presentation/screens/ramazan_screen.dart';
import 'package:islamic_companion/features/hijri_calendar/presentation/screens/hijri_calendar_screen.dart';
import 'package:islamic_companion/features/zakat/presentation/screens/zakat_screen.dart';
import 'package:islamic_companion/features/prayer/presentation/screens/prayer_times_screen.dart';
import 'package:islamic_companion/features/namaz_streak/presentation/screens/namaz_streak_screen.dart';
import 'package:islamic_companion/features/tasbeeh/presentation/screens/tasbeeh_screen.dart';
import 'package:islamic_companion/features/daily_content/presentation/screens/daily_content_screen.dart';
import 'package:islamic_companion/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── System UI overlay style ───────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // ── Portrait only ─────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Hive database init ────────────────────────────────────
  await HiveInit.initialize();

  // ── Notification service init ─────────────────────────────
  final notificationService = NotificationService();
  await notificationService.initialize();

  // ── Locale data for intl ──────────────────────────────────
  await initializeDateFormatting('en', null);

  runApp(SiratApp(notificationService: notificationService));
}

class SiratApp extends StatelessWidget {
  final NotificationService notificationService;
  const SiratApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(notificationService: notificationService),
      child: MaterialApp(
        title: 'Sirat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,

        // ── Navigation ──────────────────────────────────
        initialRoute: '/',
        routes: {
          '/': (_) => const AppScaffold(),
          '/prayer': (_) => const PrayerTimesScreen(),
          '/streak': (_) => const NamazStreakScreen(),
          '/tasbeeh': (_) => const TasbeehScreen(),
          '/ramazan': (_) => const RamazanScreen(),
          '/calendar': (_) => const HijriCalendarScreen(),
          '/zakat': (_) => const ZakatScreen(),
          '/content': (_) => const DailyContentScreen(),
        },
      ),
    );
  }
}
