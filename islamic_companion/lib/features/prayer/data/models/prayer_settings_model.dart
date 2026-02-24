// ============================================================
// prayer_settings_model.dart
// Hive-annotated model for persisting prayer settings locally.
// Run: flutter pub run build_runner build
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_settings_entity.dart';

part 'prayer_settings_model.g.dart';

@HiveType(typeId: AppConstants.prayerSettingsTypeId)
class PrayerSettingsModel extends HiveObject {
  @HiveField(0)
  String cityName;

  @HiveField(1)
  double latitude;

  @HiveField(2)
  double longitude;

  @HiveField(3)
  bool useAutoLocation;

  @HiveField(4)
  int fajrOffset;

  @HiveField(5)
  int dhuhrOffset;

  @HiveField(6)
  int asrOffset;

  @HiveField(7)
  int maghribOffset;

  @HiveField(8)
  int ishaOffset;

  @HiveField(9)
  bool azanEnabled;

  @HiveField(10)
  bool vibrationEnabled;

  PrayerSettingsModel({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    this.useAutoLocation = true,
    this.fajrOffset = 0,
    this.dhuhrOffset = 0,
    this.asrOffset = 0,
    this.maghribOffset = 0,
    this.ishaOffset = 0,
    this.azanEnabled = true,
    this.vibrationEnabled = true,
  });

  /// Convert Hive model → domain entity
  PrayerSettingsEntity toEntity() => PrayerSettingsEntity(
        cityName: cityName,
        latitude: latitude,
        longitude: longitude,
        useAutoLocation: useAutoLocation,
        fajrOffset: fajrOffset,
        dhuhrOffset: dhuhrOffset,
        asrOffset: asrOffset,
        maghribOffset: maghribOffset,
        ishaOffset: ishaOffset,
        azanEnabled: azanEnabled,
        vibrationEnabled: vibrationEnabled,
      );

  /// Convert domain entity → Hive model (factory)
  factory PrayerSettingsModel.fromEntity(PrayerSettingsEntity entity) =>
      PrayerSettingsModel(
        cityName: entity.cityName,
        latitude: entity.latitude,
        longitude: entity.longitude,
        useAutoLocation: entity.useAutoLocation,
        fajrOffset: entity.fajrOffset,
        dhuhrOffset: entity.dhuhrOffset,
        asrOffset: entity.asrOffset,
        maghribOffset: entity.maghribOffset,
        ishaOffset: entity.ishaOffset,
        azanEnabled: entity.azanEnabled,
        vibrationEnabled: entity.vibrationEnabled,
      );

  /// Default Karachi settings for first launch
  factory PrayerSettingsModel.defaultSettings() => PrayerSettingsModel(
        cityName: 'Karachi',
        latitude: 24.8607,
        longitude: 67.0011,
        useAutoLocation: true,
      );
}
