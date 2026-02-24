// ============================================================
// zakat_calculator_service.dart
// Core Zakat calculation logic. Offline, no network needed.
// Uses gold-based nisab by default (Hanafi — more conservative).
// ============================================================

import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/zakat/domain/entities/zakat_entity.dart';

class ZakatCalculatorService {
  /// Calculate Zakat given asset inputs and current gold/silver rates.
  /// [goldRatePerGram] and [silverRatePerGram] are in PKR.
  ZakatEntity calculate({
    required double cashPKR,
    required double goldGrams,
    required double silverGrams,
    required double businessValuePKR,
    required double goldRatePerGram,
    required double silverRatePerGram,
  }) {
    // ── Nisab Calculation ──────────────────────────────────
    final goldNisabPKR =
        AppConstants.goldNisabGrams * goldRatePerGram;       // 87.48g × rate
    final silverNisabPKR =
        AppConstants.silverNisabGrams * silverRatePerGram;   // 612.36g × rate

    // Use the lower of the two (silver nisab) to maximize Zakat obligation
    // Note: Scholars differ — silver nisab used here (more common in Pakistan)
    final nisabThreshold = silverNisabPKR;
    final nisabUsed = 'Silver (612.36g)';

    // ── Total Assets ───────────────────────────────────────
    final goldValuePKR = goldGrams * goldRatePerGram;
    final silverValuePKR = silverGrams * silverRatePerGram;
    final totalAssets =
        cashPKR + goldValuePKR + silverValuePKR + businessValuePKR;

    // ── Zakat Due ──────────────────────────────────────────
    final isZakatDue = totalAssets >= nisabThreshold;
    final zakatPayable =
        isZakatDue ? totalAssets * AppConstants.zakatRate : 0.0;

    return ZakatEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      year: DateTime.now().year,
      cashPKR: cashPKR,
      goldGrams: goldGrams,
      silverGrams: silverGrams,
      businessValuePKR: businessValuePKR,
      goldRatePerGram: goldRatePerGram,
      silverRatePerGram: silverRatePerGram,
      totalAssetsInPKR: totalAssets,
      zakatPayable: zakatPayable,
      nisabUsed: nisabUsed,
      isZakatDue: isZakatDue,
    );
  }
}
