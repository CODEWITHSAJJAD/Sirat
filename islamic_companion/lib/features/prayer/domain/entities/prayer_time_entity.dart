// ============================================================
// prayer_time_entity.dart
// Pure domain entity — no Hive annotations, no Flutter deps.
// Represents a single prayer time session for a day.
// ============================================================

class PrayerTimeEntity {
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime sunrise;
  final String cityName;
  final DateTime date;

  const PrayerTimeEntity({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
    required this.cityName,
    required this.date,
  });

  /// Returns all 5 prayer times as a named list (Fajr → Isha)
  List<MapEntry<String, DateTime>> get allPrayers => [
    MapEntry('Fajr', fajr),
    MapEntry('Dhuhr', dhuhr),
    MapEntry('Asr', asr),
    MapEntry('Maghrib', maghrib),
    MapEntry('Isha', isha),
  ];

  /// Returns the next upcoming prayer from [now]
  MapEntry<String, DateTime>? getNextPrayer(DateTime now) {
    for (final entry in allPrayers) {
      if (entry.value.isAfter(now)) return entry;
    }
    return null; // All prayers done for today → next is tomorrow's Fajr
  }

  /// Returns the currently active prayer (the most recent one passed)
  MapEntry<String, DateTime>? getCurrentPrayer(DateTime now) {
    MapEntry<String, DateTime>? current;
    for (final entry in allPrayers) {
      if (entry.value.isBefore(now) || entry.value.isAtSameMomentAs(now)) {
        current = entry;
      }
    }
    return current;
  }
}
