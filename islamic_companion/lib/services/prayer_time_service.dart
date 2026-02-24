// ============================================================
// prayer_time_service.dart
// Wraps the Adhan Dart library. Calculates prayer times using
// Hanafi method (default for Pakistan). Returns PrayerTimeEntity.
// ============================================================

import 'package:adhan/adhan.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_time_entity.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_settings_entity.dart';

class PrayerTimeService {
  /// Calculate prayer times for a given [date] and [settings].
  /// Uses Hanafi madhab (high Asr) as per Pakistani tradition.
  PrayerTimeEntity calculate({
    required PrayerSettingsEntity settings,
    required DateTime date,
  }) {
    final coordinates = Coordinates(settings.latitude, settings.longitude);

    // Hanafi calculation parameters for Pakistan
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final dateComponents = DateComponents(date.year, date.month, date.day);
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    // Apply user-defined minute offsets
    return PrayerTimeEntity(
      fajr: _applyOffset(prayerTimes.fajr!, settings.fajrOffset),
      dhuhr: _applyOffset(prayerTimes.dhuhr!, settings.dhuhrOffset),
      asr: _applyOffset(prayerTimes.asr!, settings.asrOffset),
      maghrib: _applyOffset(prayerTimes.maghrib!, settings.maghribOffset),
      isha: _applyOffset(prayerTimes.isha!, settings.ishaOffset),
      sunrise: prayerTimes.sunrise!,
      cityName: settings.cityName,
      date: date,
    );
  }

  /// Returns Sehr time (same as Fajr) for Ramadan
  DateTime getSehrTime(PrayerSettingsEntity settings, DateTime date) {
    return calculate(settings: settings, date: date).fajr;
  }

  /// Returns Iftar time (same as Maghrib) for Ramadan
  DateTime getIftarTime(PrayerSettingsEntity settings, DateTime date) {
    return calculate(settings: settings, date: date).maghrib;
  }

  DateTime _applyOffset(DateTime time, int offsetMinutes) {
    return time.add(Duration(minutes: offsetMinutes));
  }
}
