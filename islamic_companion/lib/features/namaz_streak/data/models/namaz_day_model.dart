// ============================================================
// namaz_day_model.dart
// Hive-annotated model for a single day's namaz record.
// Key in box = YYYY-MM-DD date string.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/namaz_streak/domain/entities/namaz_streak_entity.dart';

part 'namaz_day_model.g.dart';

@HiveType(typeId: AppConstants.namazDayTypeId)
class NamazDayModel extends HiveObject {
  @HiveField(0)
  String dateKey;

  @HiveField(1)
  bool fajr;

  @HiveField(2)
  bool dhuhr;

  @HiveField(3)
  bool asr;

  @HiveField(4)
  bool maghrib;

  @HiveField(5)
  bool isha;

  NamazDayModel({
    required this.dateKey,
    this.fajr = false,
    this.dhuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
  });

  NamazStreakEntity toEntity() => NamazStreakEntity(
        dateKey: dateKey,
        fajr: fajr,
        dhuhr: dhuhr,
        asr: asr,
        maghrib: maghrib,
        isha: isha,
      );

  factory NamazDayModel.fromEntity(NamazStreakEntity e) => NamazDayModel(
        dateKey: e.dateKey,
        fajr: e.fajr,
        dhuhr: e.dhuhr,
        asr: e.asr,
        maghrib: e.maghrib,
        isha: e.isha,
      );
}
