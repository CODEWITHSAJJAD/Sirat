// ============================================================
// ramazan_day_entity.dart
// Domain entity for a single day's Ramadan tracking.
// Contains: roza, taraweeh tracking and streak logic.
// ============================================================

class RamazanDayEntity {
  final String dateKey;     // YYYY-MM-DD Gregorian key
  final int hijriDay;       // 1–30 (Ramadan day number)
  final bool rozaCompleted; // Roza (fast) done today
  final bool taraweehDone;  // Taraweeh prayed tonight

  const RamazanDayEntity({
    required this.dateKey,
    required this.hijriDay,
    this.rozaCompleted = false,
    this.taraweehDone = false,
  });

  RamazanDayEntity copyWith({
    String? dateKey,
    int? hijriDay,
    bool? rozaCompleted,
    bool? taraweehDone,
  }) {
    return RamazanDayEntity(
      dateKey: dateKey ?? this.dateKey,
      hijriDay: hijriDay ?? this.hijriDay,
      rozaCompleted: rozaCompleted ?? this.rozaCompleted,
      taraweehDone: taraweehDone ?? this.taraweehDone,
    );
  }
}
