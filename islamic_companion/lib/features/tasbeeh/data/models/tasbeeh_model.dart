// ============================================================
// tasbeeh_model.dart
// Hive-annotated model for a Tasbeeh session.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/tasbeeh/domain/entities/tasbeeh_entity.dart';

part 'tasbeeh_model.g.dart';

@HiveType(typeId: AppConstants.tasbeehTypeId)
class TasbeehModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String arabic;

  @HiveField(3)
  int targetCount;

  @HiveField(4)
  int currentCount;

  @HiveField(5)
  String dateKey;

  @HiveField(6)
  bool isCompleted;

  TasbeehModel({
    required this.id,
    required this.name,
    required this.arabic,
    required this.targetCount,
    required this.currentCount,
    required this.dateKey,
    this.isCompleted = false,
  });

  TasbeehEntity toEntity() => TasbeehEntity(
        id: id,
        name: name,
        arabic: arabic,
        targetCount: targetCount,
        currentCount: currentCount,
        dateKey: dateKey,
        isCompleted: isCompleted,
      );

  factory TasbeehModel.fromEntity(TasbeehEntity e) => TasbeehModel(
        id: e.id,
        name: e.name,
        arabic: e.arabic,
        targetCount: e.targetCount,
        currentCount: e.currentCount,
        dateKey: e.dateKey,
        isCompleted: e.isCompleted,
      );
}
