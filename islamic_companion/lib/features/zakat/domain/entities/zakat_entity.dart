// ============================================================
// zakat_entity.dart
// Domain entity for a Zakat calculation record.
// ============================================================

class ZakatEntity {
  final String id;         // timestamp-based key
  final int year;          // Gregorian year of calculation
  final double cashPKR;
  final double goldGrams;
  final double silverGrams;
  final double businessValuePKR;
  final double goldRatePerGram;    // PKR price at time of calc
  final double silverRatePerGram;
  final double totalAssetsInPKR;
  final double zakatPayable;       // 2.5% of total
  final String nisabUsed;          // 'gold' or 'silver'
  final bool isZakatDue;

  const ZakatEntity({
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
}
