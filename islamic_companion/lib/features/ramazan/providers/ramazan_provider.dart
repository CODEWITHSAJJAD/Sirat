// ============================================================
// ramazan_provider.dart
// ChangeNotifier for Ramazan module.
// Handles: Ramadan detection, Sehr/Iftar times, roza tracking,
// taraweeh toggle, streak calculation, badge logic, reminders.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_settings_entity.dart';
import 'package:islamic_companion/features/ramazan/domain/entities/ramazan_day_entity.dart';
import 'package:islamic_companion/features/ramazan/domain/repositories/ramazan_repository.dart';
import 'package:islamic_companion/services/notification_service.dart';
import 'package:islamic_companion/services/prayer_time_service.dart';
import 'package:islamic_companion/services/ramazan_service.dart';

class RamazanProvider extends ChangeNotifier {
  final RamazanRepository _repository;
  final RamazanService _ramazanService;
  final NotificationService _notificationService;

  RamazanProvider({
    required RamazanRepository repository,
    required RamazanService ramazanService,
    required NotificationService notificationService,
  })  : _repository = repository,
        _ramazanService = ramazanService,
        _notificationService = notificationService;

  // ── State ──────────────────────────────────────────────────
  bool _isRamadan = false;
  int? _ramadanDayNumber;
  RamazanDayEntity? _today;
  DateTime? _sahrTime;
  DateTime? _iftarTime;
  int _rozaStreak = 0;
  int _longestStreak = 0;
  int _lifetimeFasts = 0;
  List<RamazanDayEntity> _allDays = [];
  bool _isLoading = false;
  int _moonAdjustment = 0; // For Pakistan: typically +1 day

  // ── Getters ───────────────────────────────────────────────
  bool get isRamadan => _isRamadan;
  int? get ramadanDayNumber => _ramadanDayNumber;
  RamazanDayEntity? get today => _today;
  DateTime? get sahrTime => _sahrTime;
  DateTime? get iftarTime => _iftarTime;
  int get rozaStreak => _rozaStreak;
  int get longestStreak => _longestStreak;
  int get lifetimeFasts => _lifetimeFasts;
  List<RamazanDayEntity> get allDays => _allDays;
  bool get isLoading => _isLoading;
  bool get rozaCompleted => _today?.rozaCompleted ?? false;
  bool get taraweehDone => _today?.taraweehDone ?? false;
  int get moonAdjustment => _moonAdjustment;

  String? get rozaBadge => _ramazanService.getBadgeForStreak(_rozaStreak);

  /// Set moon sighting adjustment (+1 or -1 day for Pakistan)
  void setMoonAdjustment(int days) {
    _moonAdjustment = days;
    _refreshRamadanStatus();
  }

  void _refreshRamadanStatus() {
    _isRamadan = _ramazanService.isRamadanActive(moonAdjustment: _moonAdjustment);
    _ramadanDayNumber = _ramazanService.getRamadanDayNumber(moonAdjustment: _moonAdjustment);
    notifyListeners();
  }

  bool get isSehrTime {
    if (_sahrTime == null || _iftarTime == null) return false;
    final now = DateTime.now();
    return now.isAfter(_sahrTime!) && now.isBefore(_iftarTime!);
  }

  bool get isIftarTimePassed {
    if (_iftarTime == null) return false;
    return DateTime.now().isAfter(_iftarTime!);
  }

  Duration get timeToIftar {
    if (_iftarTime == null) return Duration.zero;
    final diff = _iftarTime!.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  Duration get timeToSahr {
    if (_sahrTime == null) return Duration.zero;
    final diff = _sahrTime!.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get currentFastPhase {
    if (_sahrTime == null || _iftarTime == null) return 'Sehr';
    final now = DateTime.now();
    if (now.isBefore(_sahrTime!)) {
      return 'Sehr';
    } else if (now.isAfter(_sahrTime!) && now.isBefore(_iftarTime!)) {
      return 'Iftar';
    } else {
      return 'Sehr';
    }
  }

  Duration get activeCountdown {
    return currentFastPhase == 'Sehr' ? timeToSahr : timeToIftar;
  }

  DateTime? get activeTime {
    return currentFastPhase == 'Sehr' ? _sahrTime : _iftarTime;
  }

  Future<void> initialize({PrayerSettingsEntity? prayerSettings}) async {
    _isLoading = true;
    notifyListeners();

    _isRamadan = _ramazanService.isRamadanActive(moonAdjustment: _moonAdjustment);
    _ramadanDayNumber = _ramazanService.getRamadanDayNumber(moonAdjustment: _moonAdjustment);

    final dateKey = DateTime.now().toHiveKey();
    _today = await _repository.getDay(dateKey) ??
        RamazanDayEntity(
          dateKey: dateKey,
          hijriDay: _ramadanDayNumber ?? 0,
        );

    _rozaStreak = await _repository.getCurrentRozaStreak();
    _longestStreak = await _repository.getLongestRozaStreak();
    _lifetimeFasts = await _repository.getLifetimeFastCount();
    _allDays = await _repository.getAllRamazanDays();

    // Calculate Sehr/Iftar if prayer settings are available
    if (prayerSettings != null) {
      final prayerTimeService = PrayerTimeService();
      final prayers = prayerTimeService.calculate(
          settings: prayerSettings, date: DateTime.now());
      _sahrTime = prayers.fajr;
      _iftarTime = prayers.maghrib;

      if (_isRamadan) {
        await _notificationService.scheduleSahrReminder(_sahrTime!);
        await _notificationService.scheduleIftarReminder(_iftarTime!);
      }
    }

    _isLoading = false;
    notifyListeners();

    // Always start countdown refresh for Sehr/Iftar times
    _startCountdowns();
  }

  void _startCountdowns() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      notifyListeners();
      return true; // Always keep running
    });
  }

  Future<void> toggleRoza(bool value) async {
    if (_today == null) return;
    _today = _today!.copyWith(rozaCompleted: value);
    await _repository.saveDay(_today!);
    _rozaStreak = await _repository.getCurrentRozaStreak();
    _longestStreak = await _repository.getLongestRozaStreak();
    _lifetimeFasts = await _repository.getLifetimeFastCount();
    _allDays = await _repository.getAllRamazanDays();
    notifyListeners();
  }

  Future<void> toggleTaraweeh(bool value) async {
    if (_today == null) return;
    _today = _today!.copyWith(taraweehDone: value);
    await _repository.saveDay(_today!);
    notifyListeners();
  }

  Future<void> updatePrayerSettings(PrayerSettingsEntity? settings) async {
    if (settings == null) return;
    
    // Always calculate Sehr/Iftar times when settings are provided
    final prayerTimeService = PrayerTimeService();
    final prayers = prayerTimeService.calculate(
        settings: settings, date: DateTime.now());
    _sahrTime = prayers.fajr;
    _iftarTime = prayers.maghrib;

    if (_isRamadan) {
      await _notificationService.scheduleSahrReminder(_sahrTime!);
      await _notificationService.scheduleIftarReminder(_iftarTime!);
    }
    notifyListeners();
  }
}
