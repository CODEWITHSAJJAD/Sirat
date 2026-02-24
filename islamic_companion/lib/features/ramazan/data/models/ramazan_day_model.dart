// ============================================================
// ramazan_day_model.dart
// Hive-annotated model for a single Ramazan day record.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/ramazan/domain/entities/ramazan_day_entity.dart';

part 'ramazan_day_model.g.dart';

@HiveType(typeId: AppConstants.ramazanDayTypeId)
class RamazanDayModel extends HiveObject {
  @HiveField(0)
  String dateKey;

  @HiveField(1)
  int hijriDay;

  @HiveField(2)
  bool rozaCompleted;

  @HiveField(3)
  bool taraweehDone;

  RamazanDayModel({
    required this.dateKey,
    required this.hijriDay,
    this.rozaCompleted = false,
    this.taraweehDone = false,
  });

  RamazanDayEntity toEntity() => RamazanDayEntity(
        dateKey: dateKey,
        hijriDay: hijriDay,
        rozaCompleted: rozaCompleted,
        taraweehDone: taraweehDone,
      );

  factory RamazanDayModel.fromEntity(RamazanDayEntity e) => RamazanDayModel(
        dateKey: e.dateKey,
        hijriDay: e.hijriDay,
        rozaCompleted: e.rozaCompleted,
        taraweehDone: e.taraweehDone,
      );
}
