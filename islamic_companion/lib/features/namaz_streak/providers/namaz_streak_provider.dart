// ============================================================
// namaz_streak_provider.dart
// ChangeNotifier for Namaz Streak feature.
// Handles: marking individual prayers, streak calculation,
// monthly analytics, and motivational quotes on full-day.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/namaz_streak/domain/entities/namaz_streak_entity.dart';
import 'package:islamic_companion/features/namaz_streak/domain/repositories/namaz_streak_repository.dart';

class NamazStreakProvider extends ChangeNotifier {
  final NamazStreakRepository _repository;

  NamazStreakProvider({required NamazStreakRepository repository})
      : _repository = repository;

  // ── State ─────────────────────────────────────────────────
  NamazStreakEntity _today = NamazStreakEntity(dateKey: '');
  int _currentStreak = 0;
  int _longestStreak = 0;
  List<NamazStreakEntity> _monthDays = [];
  bool _isLoading = false;
  String _motivationalQuote = '';

  // ── Getters ───────────────────────────────────────────────
  NamazStreakEntity get today => _today;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  List<NamazStreakEntity> get monthDays => _monthDays;
  bool get isLoading => _isLoading;
  String get motivationalQuote => _motivationalQuote;

  /// Load today's record and streak data
  Future<void> loadToday() async {
    _isLoading = true;
    notifyListeners();

    final today = DateTime.now();
    final dateKey = today.toHiveKey();

    _today = await _repository.getDay(dateKey);
    _currentStreak = await _repository.getCurrentStreak();
    _longestStreak = await _repository.getLongestStreak();
    await _loadCurrentMonth();

    _isLoading = false;
    notifyListeners();
  }

  /// Toggle a specific prayer's completion status
  Future<void> togglePrayer(String prayerName, bool value) async {
    final wasFullDay = _today.isFullDay;

    NamazStreakEntity updated;
    switch (prayerName) {
      case 'Fajr':
        updated = _today.copyWith(fajr: value);
        break;
      case 'Dhuhr':
        updated = _today.copyWith(dhuhr: value);
        break;
      case 'Asr':
        updated = _today.copyWith(asr: value);
        break;
      case 'Maghrib':
        updated = _today.copyWith(maghrib: value);
        break;
      case 'Isha':
        updated = _today.copyWith(isha: value);
        break;
      default:
        return;
    }

    _today = updated;
    await _repository.saveDay(_today);

    // Recalculate streaks
    _currentStreak = await _repository.getCurrentStreak();
    _longestStreak = await _repository.getLongestStreak();

    // Show motivational quote on achieving full-day streak
    if (!wasFullDay && _today.isFullDay) {
      _motivationalQuote = _getRandomQuote();
    } else {
      _motivationalQuote = '';
    }

    await _loadCurrentMonth();
    notifyListeners();
  }

  Future<void> _loadCurrentMonth() async {
    final now = DateTime.now();
    _monthDays = await _repository.getMonthDays(now.year, now.month);
  }

  String _getRandomQuote() {
    final quotes = List<String>.from(AppConstants.streakQuotes);
    quotes.shuffle();
    return quotes.first;
  }

  bool getPrayerStatus(String prayerName) {
    switch (prayerName) {
      case 'Fajr': return _today.fajr;
      case 'Dhuhr': return _today.dhuhr;
      case 'Asr': return _today.asr;
      case 'Maghrib': return _today.maghrib;
      case 'Isha': return _today.isha;
      default: return false;
    }
  }
}
