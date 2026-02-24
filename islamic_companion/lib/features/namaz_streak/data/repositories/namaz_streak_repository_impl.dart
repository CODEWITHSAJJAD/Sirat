// ============================================================
// namaz_streak_repository_impl.dart
// Hive-backed NamazStreakRepository implementation.
// Uses date string (YYYY-MM-DD) as the box key.
// Streak logic: walks backwards from today counting full days.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/namaz_streak/data/models/namaz_day_model.dart';
import 'package:islamic_companion/features/namaz_streak/domain/entities/namaz_streak_entity.dart';
import 'package:islamic_companion/features/namaz_streak/domain/repositories/namaz_streak_repository.dart';

class NamazStreakRepositoryImpl implements NamazStreakRepository {
  final Box<NamazDayModel> _box;

  NamazStreakRepositoryImpl(this._box);

  @override
  Future<NamazStreakEntity> getDay(String dateKey) async {
    final model = _box.get(dateKey);
    return model?.toEntity() ??
        NamazStreakEntity(dateKey: dateKey); // empty entity if no record
  }

  @override
  Future<void> saveDay(NamazStreakEntity day) async {
    final model = NamazDayModel.fromEntity(day);
    await _box.put(day.dateKey, model);
  }

  @override
  Future<List<NamazStreakEntity>> getMonthDays(int year, int month) async {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final results = <NamazStreakEntity>[];
    for (int d = 1; d <= daysInMonth; d++) {
      final key = DateTime(year, month, d).toHiveKey();
      final model = _box.get(key);
      results.add(model?.toEntity() ?? NamazStreakEntity(dateKey: key));
    }
    return results;
  }

  @override
  Future<int> getCurrentStreak() async {
    int streak = 0;
    DateTime cursor = DateTime.now();

    while (true) {
      final key = cursor.toHiveKey();
      final model = _box.get(key);
      if (model == null || !model.toEntity().isFullDay) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  @override
  Future<int> getLongestStreak() async {
    if (_box.isEmpty) return 0;

    // Sort all keys chronologically
    final keys = _box.keys.toList()..sort();
    int longest = 0;
    int current = 0;
    DateTime? prev;

    for (final key in keys) {
      final model = _box.get(key);
      if (model == null) continue;
      final date = DateTime.tryParse(key as String);
      if (date == null) continue;

      if (model.toEntity().isFullDay) {
        if (prev != null && date.difference(prev).inDays == 1) {
          current++;
        } else {
          current = 1;
        }
        if (current > longest) longest = current;
        prev = date;
      } else {
        prev = null;
        current = 0;
      }
    }
    return longest;
  }
}
