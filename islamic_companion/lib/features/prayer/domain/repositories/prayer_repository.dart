// ============================================================
// prayer_repository.dart
// Abstract interface for prayer settings persistence.
// The UI/providers depend on this abstraction — NOT the Hive impl.
// ============================================================

import 'package:islamic_companion/features/prayer/domain/entities/prayer_settings_entity.dart';

abstract class PrayerRepository {
  /// Load saved prayer settings (returns null if first launch)
  Future<PrayerSettingsEntity?> loadSettings();

  /// Persist updated settings to local storage
  Future<void> saveSettings(PrayerSettingsEntity settings);
}
