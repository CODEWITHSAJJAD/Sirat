// ============================================================
// namaz_streak_repository.dart
// Abstract interface for namaz streak persistence.
// ============================================================

import 'package:islamic_companion/features/namaz_streak/domain/entities/namaz_streak_entity.dart';

abstract class NamazStreakRepository {
  Future<NamazStreakEntity> getDay(String dateKey);
  Future<void> saveDay(NamazStreakEntity day);
  Future<List<NamazStreakEntity>> getMonthDays(int year, int month);
  Future<int> getCurrentStreak();
  Future<int> getLongestStreak();
}
