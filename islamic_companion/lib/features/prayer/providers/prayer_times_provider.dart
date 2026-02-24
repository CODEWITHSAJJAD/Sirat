// ============================================================
// prayer_times_provider.dart
// ChangeNotifier provider for Prayer Times feature.
// Handles: location detection, prayer calculation, settings
// persistence, countdown timer, and Azan scheduling.
// Business logic lives here — UI stays dumb.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/prayer/data/models/prayer_settings_model.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_settings_entity.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_time_entity.dart';
import 'package:islamic_companion/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:islamic_companion/services/location_service.dart';
import 'package:islamic_companion/services/notification_service.dart';
import 'package:islamic_companion/services/prayer_time_service.dart';

enum PrayerLoadState { idle, loading, loaded, error }

class PrayerTimesProvider extends ChangeNotifier {
  final PrayerRepository _repository;
  final PrayerTimeService _prayerTimeService;
  final LocationService _locationService;
  final NotificationService _notificationService;

  PrayerTimesProvider({
    required PrayerRepository repository,
    required PrayerTimeService prayerService, // Renamed from prayerTimeService
    required LocationService locationService,
    required NotificationService notificationService,
  })  : _repository = repository,
        _prayerTimeService = prayerService,
        _locationService = locationService,
        _notificationService = notificationService;

  // ── State ─────────────────────────────────────────────────
  PrayerLoadState _loadState = PrayerLoadState.idle;
  PrayerTimeEntity? _prayerTimes;
  PrayerSettingsEntity? _settings;
  String _errorMessage = '';
  Duration _nextPrayerCountdown = Duration.zero;

  // ── Getters ───────────────────────────────────────────────
  PrayerLoadState get loadState => _loadState;
  PrayerTimeEntity? get prayerTimes => _prayerTimes;
  PrayerSettingsEntity? get settings => _settings;
  String get errorMessage => _errorMessage;
  bool get isLoading => _loadState == PrayerLoadState.loading;
  Duration get countdown => _nextPrayerCountdown; // Alias for home screen
  PrayerTimeEntity? get currentPrayerTimes => _prayerTimes; // Alias for home screen

  MapEntry<String, DateTime>? get nextPrayer =>
      _prayerTimes?.getNextPrayer(DateTime.now());

  MapEntry<String, DateTime>? get currentPrayer =>
      _prayerTimes?.getCurrentPrayer(DateTime.now());

  String get currentCityName => _settings?.cityName ?? 'Karachi';

  /// Initialize: load settings → get location → calculate prayers
  Future<void> initialize() async {
    _setLoading();

    // Load saved settings or use defaults
    _settings = await _repository.loadSettings();
    if (_settings == null) {
      final defaultModel = PrayerSettingsModel.defaultSettings();
      _settings = defaultModel.toEntity();
      await _repository.saveSettings(_settings!);
    }

    // Auto-detect location if enabled
    if (_settings!.useAutoLocation) {
      await _fetchLocation();
    }

    _calculateAndNotify();
  }

  Future<void> _fetchLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        String? cityName = await _locationService.getCityFromCoordinates(
          position.latitude,
          position.longitude,
        );

        _settings = _settings!.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          cityName: cityName ?? _settings!.cityName,
        );
        await _repository.saveSettings(_settings!);
      }
    } catch (_) {
      // Location failed – use saved/default city coordinates
    }
  }

  /// Recalculate prayer times and schedule Azan notifications
  void _calculateAndNotify() {
    try {
      _prayerTimes = _prayerTimeService.calculate(
        settings: _settings!,
        date: DateTime.now(),
      );
      _loadState = PrayerLoadState.loaded;

      // Schedule Azan if enabled
      if (_settings!.azanEnabled) {
        _notificationService.scheduleAzanNotifications(_prayerTimes!);
      }

      notifyListeners();
      _startCountdownTimer();
    } catch (e) {
      _errorMessage = 'Failed to calculate prayer times.';
      _loadState = PrayerLoadState.error;
      notifyListeners();
    }
  }

  /// Countdown ticks every second – updates UI
  void _startCountdownTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_prayerTimes != null) {
        final next = _prayerTimes!.getNextPrayer(DateTime.now());
        if (next != null) {
          _nextPrayerCountdown = next.value.difference(DateTime.now());
          if (_nextPrayerCountdown.isNegative) {
            // Recalculate prayer times if we've passed all prayers
            _calculateAndNotify();
          }
        } else {
          _nextPrayerCountdown = Duration.zero;
        }
        notifyListeners();
      }
      return true; // Keep running
    });
  }

  /// User manually selects a city from the list
  Future<void> selectCity(Map<String, dynamic> city) async {
    _settings = _settings!.copyWith(
      cityName: city['name'] as String,
      latitude: city['lat'] as double,
      longitude: city['lng'] as double,
      useAutoLocation: false,
    );
    await _repository.saveSettings(_settings!);
    _calculateAndNotify();
  }

  /// Update prayer minute offset
  Future<void> updateOffset(String prayer, int offsetMinutes) async {
    switch (prayer) {
      case 'Fajr':
        _settings = _settings!.copyWith(fajrOffset: offsetMinutes);
        break;
      case 'Dhuhr':
        _settings = _settings!.copyWith(dhuhrOffset: offsetMinutes);
        break;
      case 'Asr':
        _settings = _settings!.copyWith(asrOffset: offsetMinutes);
        break;
      case 'Maghrib':
        _settings = _settings!.copyWith(maghribOffset: offsetMinutes);
        break;
      case 'Isha':
        _settings = _settings!.copyWith(ishaOffset: offsetMinutes);
        break;
    }
    await _repository.saveSettings(_settings!);
    _calculateAndNotify();
  }

  /// Toggle Azan notifications
  Future<void> toggleAzan(bool enabled) async {
    _settings = _settings!.copyWith(azanEnabled: enabled);
    await _repository.saveSettings(_settings!);
    if (!enabled) await _notificationService.cancelAzanNotifications();
    if (enabled && _prayerTimes != null) {
      await _notificationService.scheduleAzanNotifications(_prayerTimes!);
    }
    notifyListeners();
  }

  /// Refresh prayer times (called when app resumes or date changes)
  Future<void> refresh() async => initialize();

  void _setLoading() {
    _loadState = PrayerLoadState.loading;
    notifyListeners();
  }

  /// Returns offset for a given prayer name
  int getOffset(String prayer) {
    switch (prayer) {
      case 'Fajr': return _settings?.fajrOffset ?? 0;
      case 'Dhuhr': return _settings?.dhuhrOffset ?? 0;
      case 'Asr': return _settings?.asrOffset ?? 0;
      case 'Maghrib': return _settings?.maghribOffset ?? 0;
      case 'Isha': return _settings?.ishaOffset ?? 0;
      default: return 0;
    }
  }

  List<Map<String, dynamic>> get cityList => AppConstants.pakistaniCities;
}
