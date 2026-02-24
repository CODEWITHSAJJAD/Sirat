// ============================================================
// prayer_settings_entity.dart
// Stores user preferences for prayer calculation.
// ============================================================

class PrayerSettingsEntity {
  final String cityName;
  final double latitude;
  final double longitude;
  final bool useAutoLocation;
  final int fajrOffset;   // minutes offset
  final int dhuhrOffset;
  final int asrOffset;
  final int maghribOffset;
  final int ishaOffset;
  final bool azanEnabled;
  final bool vibrationEnabled;

  const PrayerSettingsEntity({
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

  PrayerSettingsEntity copyWith({
    String? cityName,
    double? latitude,
    double? longitude,
    bool? useAutoLocation,
    int? fajrOffset,
    int? dhuhrOffset,
    int? asrOffset,
    int? maghribOffset,
    int? ishaOffset,
    bool? azanEnabled,
    bool? vibrationEnabled,
  }) {
    return PrayerSettingsEntity(
      cityName: cityName ?? this.cityName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      useAutoLocation: useAutoLocation ?? this.useAutoLocation,
      fajrOffset: fajrOffset ?? this.fajrOffset,
      dhuhrOffset: dhuhrOffset ?? this.dhuhrOffset,
      asrOffset: asrOffset ?? this.asrOffset,
      maghribOffset: maghribOffset ?? this.maghribOffset,
      ishaOffset: ishaOffset ?? this.ishaOffset,
      azanEnabled: azanEnabled ?? this.azanEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}
