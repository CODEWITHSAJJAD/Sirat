// ============================================================
// tasbeeh_entity.dart
// Domain entity for a single tasbeeh session.
// ============================================================

class TasbeehEntity {
  final String id;           // UUID or timestamp-based key
  final String name;         // e.g. "SubhanAllah"
  final String arabic;       // Arabic text
  final int targetCount;     // e.g. 33, 34, 100
  final int currentCount;    // current tap count
  final String dateKey;      // YYYY-MM-DD
  final bool isCompleted;

  const TasbeehEntity({
    required this.id,
    required this.name,
    required this.arabic,
    required this.targetCount,
    required this.currentCount,
    required this.dateKey,
    this.isCompleted = false,
  });

  bool get isTargetReached => currentCount >= targetCount;

  TasbeehEntity copyWith({
    String? id,
    String? name,
    String? arabic,
    int? targetCount,
    int? currentCount,
    String? dateKey,
    bool? isCompleted,
  }) {
    return TasbeehEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      arabic: arabic ?? this.arabic,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      dateKey: dateKey ?? this.dateKey,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
