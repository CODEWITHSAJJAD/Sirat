// ============================================================
// ramazan_repository.dart
// Abstract interface for Ramazan data persistence.
// ============================================================

import 'package:islamic_companion/features/ramazan/domain/entities/ramazan_day_entity.dart';

abstract class RamazanRepository {
  Future<RamazanDayEntity?> getDay(String dateKey);
  Future<void> saveDay(RamazanDayEntity day);
  Future<List<RamazanDayEntity>> getAllRamazanDays();
  Future<int> getCurrentRozaStreak();
  Future<int> getLongestRozaStreak();
  Future<int> getLifetimeFastCount();
}
