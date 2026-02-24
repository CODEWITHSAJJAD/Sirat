// ============================================================
// zakat_record_model.dart
// Hive-annotated Zakat calculation record model.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/zakat/domain/entities/zakat_entity.dart';

part 'zakat_record_model.g.dart';

@HiveType(typeId: AppConstants.zakatRecordTypeId)
class ZakatRecordModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) int year;
  @HiveField(2) double cashPKR;
  @HiveField(3) double goldGrams;
  @HiveField(4) double silverGrams;
  @HiveField(5) double businessValuePKR;
  @HiveField(6) double goldRatePerGram;
  @HiveField(7) double silverRatePerGram;
  @HiveField(8) double totalAssetsInPKR;
  @HiveField(9) double zakatPayable;
  @HiveField(10) String nisabUsed;
  @HiveField(11) bool isZakatDue;

  ZakatRecordModel({
    required this.id,
    required this.year,
    required this.cashPKR,
    required this.goldGrams,
    required this.silverGrams,
    required this.businessValuePKR,
    required this.goldRatePerGram,
    required this.silverRatePerGram,
    required this.totalAssetsInPKR,
    required this.zakatPayable,
    required this.nisabUsed,
    required this.isZakatDue,
  });

  ZakatEntity toEntity() => ZakatEntity(
        id: id, year: year, cashPKR: cashPKR, goldGrams: goldGrams,
        silverGrams: silverGrams, businessValuePKR: businessValuePKR,
        goldRatePerGram: goldRatePerGram, silverRatePerGram: silverRatePerGram,
        totalAssetsInPKR: totalAssetsInPKR, zakatPayable: zakatPayable,
        nisabUsed: nisabUsed, isZakatDue: isZakatDue,
      );

  factory ZakatRecordModel.fromEntity(ZakatEntity e) => ZakatRecordModel(
        id: e.id, year: e.year, cashPKR: e.cashPKR, goldGrams: e.goldGrams,
        silverGrams: e.silverGrams, businessValuePKR: e.businessValuePKR,
        goldRatePerGram: e.goldRatePerGram, silverRatePerGram: e.silverRatePerGram,
        totalAssetsInPKR: e.totalAssetsInPKR, zakatPayable: e.zakatPayable,
        nisabUsed: e.nisabUsed, isZakatDue: e.isZakatDue,
      );
}
