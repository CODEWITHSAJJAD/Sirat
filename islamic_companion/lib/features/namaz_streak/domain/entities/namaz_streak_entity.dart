// ============================================================
// namaz_streak_entity.dart
// Domain entity for a single day's namaz tracking.
// Pure Dart — no Hive, no Flutter dependencies.
// ============================================================

class NamazStreakEntity {
  final String dateKey; // YYYY-MM-DD
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;

  const NamazStreakEntity({
    required this.dateKey,
    this.fajr = false,
    this.dhuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
  });

  /// True if all 5 prayers are completed
  bool get isFullDay => fajr && dhuhr && asr && maghrib && isha;

  /// Count of completed prayers today
  int get completedCount =>
      [fajr, dhuhr, asr, maghrib, isha].where((p) => p).length;

  NamazStreakEntity copyWith({
    String? dateKey,
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
  }) {
    return NamazStreakEntity(
      dateKey: dateKey ?? this.dateKey,
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}
