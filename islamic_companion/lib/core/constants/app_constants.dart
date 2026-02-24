// ============================================================
// app_constants.dart
// Core application-wide constants. All feature modules import
// from here to avoid magic strings and scattered literals.
// ============================================================

class AppConstants {
  // App identity
  static const String appName = 'Sirat';
  static const String appVersion = '1.0.0';

  // ── Hive Box Names ────────────────────────────────────────
  static const String prayerSettingsBox = 'prayer_settings';
  static const String namazStreakBox = 'namaz_streak';
  static const String tasbeehBox = 'tasbeeh';
  static const String tasbeehHistoryBox = 'tasbeeh_history'; // Added
  static const String ramazanBox = 'ramazan';
  static const String ramazanHistoryBox = 'ramazan_history'; // Added
  static const String zakatBox = 'zakat';
  static const String zakatHistoryBox = 'zakat_history'; // Added
  static const String calendarSettingsBox = 'calendar_settings';
  static const String appSettingsBox = 'app_settings';

  // ── Hive Type IDs ─────────────────────────────────────────
  // Each Hive model needs a unique typeId (0–223)
  static const int prayerSettingsTypeId = 0;
  static const int namazDayTypeId = 1;
  static const int tasbeehTypeId = 2;
  static const int ramazanDayTypeId = 3;
  static const int zakatRecordTypeId = 4;
  static const int calendarSettingsTypeId = 5;

  // ── Notification Channel IDs ──────────────────────────────
  static const String azanChannelId = 'azan_channel';
  static const String azanChannelName = 'Azan Notifications';
  static const String reminderChannelId = 'reminder_channel';
  static const String reminderChannelName = 'Islamic Reminders';

  // ── Prayer Names ──────────────────────────────────────────
  static const List<String> prayerNames = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  // ── Pakistani Major Cities ────────────────────────────────
  static const List<Map<String, dynamic>> pakistaniCities = [
    {'name': 'Karachi', 'lat': 24.8607, 'lng': 67.0011},
    {'name': 'Lahore', 'lat': 31.5204, 'lng': 74.3587},
    {'name': 'Islamabad', 'lat': 33.6844, 'lng': 73.0479},
    {'name': 'Rawalpindi', 'lat': 33.5651, 'lng': 73.0169},
    {'name': 'Faisalabad', 'lat': 31.4504, 'lng': 73.1350},
    {'name': 'Multan', 'lat': 30.1575, 'lng': 71.5249},
    {'name': 'Peshawar', 'lat': 34.0151, 'lng': 71.5249},
    {'name': 'Quetta', 'lat': 30.1798, 'lng': 66.9750},
    {'name': 'Sialkot', 'lat': 32.4945, 'lng': 74.5229},
    {'name': 'Hyderabad', 'lat': 25.3960, 'lng': 68.3578},
    {'name': 'Gujranwala', 'lat': 32.1877, 'lng': 74.1945},
    {'name': 'Bahawalpur', 'lat': 29.3956, 'lng': 71.6836},
    {'name': 'Sukkur', 'lat': 27.7052, 'lng': 68.8574},
    {'name': 'Abbottabad', 'lat': 34.1463, 'lng': 73.2117},
    {'name': 'Muzaffarabad', 'lat': 34.3700, 'lng': 73.4700},
  ];

  // ── Zakat Constants ───────────────────────────────────────
  static const double zakatRate = 0.025; // 2.5%
  static const double goldNisabGrams = 87.48;
  static const double silverNisabGrams = 612.36;
  static const double defaultGoldRatePerGram = 18000.0;
  static const double defaultSilverRatePerGram = 2200.0;

  // ── Tasbeeh Presets ───────────────────────────────────────
  static const List<Map<String, dynamic>> tasbeehPresets = [
    {'name': 'SubhanAllah', 'arabic': 'سُبْحَانَ اللهِ', 'target': 33},
    {'name': 'Alhamdulillah', 'arabic': 'الْحَمْدُ لِلَّهِ', 'target': 33},
    {'name': 'AllahuAkbar', 'arabic': 'اللهُ أَكْبَرُ', 'target': 34},
    {'name': 'Astaghfirullah', 'arabic': 'أَسْتَغْفِرُ اللهَ', 'target': 100},
    {'name': 'Durood Ibrahim', 'arabic': 'درود ابراہیم', 'target': 100},
  ];

  // ── Islamic Motivational Quotes ───────────────────────────
  static const List<String> streakQuotes = [
    '"Verily, with hardship comes ease." – Quran 94:6',
    '"The best deed is that which is done consistently." – Hadith',
    '"Pray, for prayer restrains from evil." – Quran 29:45',
    '"Indeed, Allah loves those who repent." – Quran 2:222',
    '"Be steadfast in prayer." – Quran 2:238',
  ];
}
