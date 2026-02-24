// ============================================================
// prayer_repository_impl.dart
// Hive-backed implementation of PrayerRepository.
// Key: 'settings' (single settings object per app install).
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/features/prayer/data/models/prayer_settings_model.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_settings_entity.dart';
import 'package:islamic_companion/features/prayer/domain/repositories/prayer_repository.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final Box<PrayerSettingsModel> _box;
  static const String _settingsKey = 'settings';

  PrayerRepositoryImpl(this._box);

  @override
  Future<PrayerSettingsEntity?> loadSettings() async {
    final model = _box.get(_settingsKey);
    return model?.toEntity();
  }

  @override
  Future<void> saveSettings(PrayerSettingsEntity settings) async {
    final model = PrayerSettingsModel.fromEntity(settings);
    await _box.put(_settingsKey, model);
  }
}
