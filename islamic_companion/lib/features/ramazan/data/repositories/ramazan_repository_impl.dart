// ============================================================
// ramazan_repository_impl.dart
// Hive-backed Ramazan repository.
// Streak logic: consecutive days with rozaCompleted = true.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/ramazan/data/models/ramazan_day_model.dart';
import 'package:islamic_companion/features/ramazan/domain/entities/ramazan_day_entity.dart';
import 'package:islamic_companion/features/ramazan/domain/repositories/ramazan_repository.dart';

class RamazanRepositoryImpl implements RamazanRepository {
  final Box<RamazanDayModel> _box;
  RamazanRepositoryImpl(this._box);

  @override
  Future<RamazanDayEntity?> getDay(String dateKey) async {
    return _box.get(dateKey)?.toEntity();
  }

  @override
  Future<void> saveDay(RamazanDayEntity day) async {
    await _box.put(day.dateKey, RamazanDayModel.fromEntity(day));
  }

  @override
  Future<List<RamazanDayEntity>> getAllRamazanDays() async {
    return _box.values.map((m) => m.toEntity()).toList()
      ..sort((a, b) => a.dateKey.compareTo(b.dateKey));
  }

  @override
  Future<int> getCurrentRozaStreak() async {
    int streak = 0;
    DateTime cursor = DateTime.now();
    while (true) {
      final model = _box.get(cursor.toHiveKey());
      if (model == null || !model.rozaCompleted) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  @override
  Future<int> getLongestRozaStreak() async {
    if (_box.isEmpty) return 0;
    final keys = _box.keys.toList()..sort();
    int longest = 0, current = 0;
    DateTime? prev;
    for (final rawKey in keys) {
      final key = rawKey as String;
      final model = _box.get(key);
      if (model == null) continue;
      final date = DateTime.tryParse(key);
      if (date == null) continue;
      if (model.rozaCompleted) {
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

  @override
  Future<int> getLifetimeFastCount() async {
    return _box.values.where((m) => m.rozaCompleted).length;
  }
}
