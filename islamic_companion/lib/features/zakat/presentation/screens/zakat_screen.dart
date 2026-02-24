// ============================================================
// zakat_screen.dart
// Full Zakat calculator UI.
// Shows: asset input form, live calculation preview, result card,
// history list with delete, and nisab info.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/zakat/providers/zakat_provider.dart';
import 'package:islamic_companion/features/zakat/domain/entities/zakat_entity.dart';

class ZakatScreen extends StatelessWidget {
  const ZakatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat Calculator 💛')),
      body: Consumer<ZakatProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Info Card ─────────────────────────────
                _NisabInfoCard(),

                const SizedBox(height: 16),

                // ── Asset Input Form ──────────────────────
                const Text('Your Assets', style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                _AssetInputForm(provider: provider),

                const SizedBox(height: 16),

                // ── Market Rates ──────────────────────────
                const Text('Current Market Rates (PKR)',
                    style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                _RateInputRow(
                  label: 'Gold (per gram)',
                  icon: '🥇',
                  initialValue: provider.goldRatePerGram,
                  onChanged: (v) =>
                      provider.goldRatePerGram = v ?? AppConstants.defaultGoldRatePerGram,
                ),
                const SizedBox(height: 8),
                _RateInputRow(
                  label: 'Silver (per gram)',
                  icon: '🥈',
                  initialValue: provider.silverRatePerGram,
                  onChanged: (v) =>
                      provider.silverRatePerGram = v ?? AppConstants.defaultSilverRatePerGram,
                ),

                const SizedBox(height: 20),

                // ── Calculate Button ──────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading ? null : provider.calculate,
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.calculate),
                    label: const Text('Calculate Zakat',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.emeraldDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Result Card ───────────────────────────
                if (provider.hasResult)
                  _ZakatResultCard(result: provider.lastResult!),

                const SizedBox(height: 20),

                // ── History ───────────────────────────────
                if (provider.history.isNotEmpty) ...[
                  const Text('History', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 10),
                  ...provider.history.map((r) => _HistoryTile(
                        record: r,
                        onDelete: () => provider.deleteRecord(r.id),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Nisab Info Banner ─────────────────────────────────────────
class _NisabInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,##0', 'en_US');
    final silverNisab = AppConstants.silverNisabGrams *
        AppConstants.defaultSilverRatePerGram;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.info_outline, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          const Text('Nisab Threshold', style: AppTextStyles.titleMedium),
        ]),
        const SizedBox(height: 6),
        Text(
          'Silver Nisab: ~${AppConstants.silverNisabGrams}g ≈ PKR ${format.format(silverNisab)}',
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          'Zakat Rate: 2.5% of total assets',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ]),
    );
  }
}

// ── Asset Input Form ──────────────────────────────────────────
class _AssetInputForm extends StatelessWidget {
  final ZakatProvider provider;
  const _AssetInputForm({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InputRow(label: 'Cash / Savings (PKR)', icon: '💵',
            onChanged: (v) => provider.cashPKR = v ?? 0),
        const SizedBox(height: 10),
        _InputRow(label: 'Gold (grams)', icon: '🥇',
            onChanged: (v) => provider.goldGrams = v ?? 0),
        const SizedBox(height: 10),
        _InputRow(label: 'Silver (grams)', icon: '🥈',
            onChanged: (v) => provider.silverGrams = v ?? 0),
        const SizedBox(height: 10),
        _InputRow(label: 'Business Assets (PKR)', icon: '🏪',
            onChanged: (v) => provider.businessValuePKR = v ?? 0),
      ],
    );
  }
}

class _InputRow extends StatelessWidget {
  final String label, icon;
  final void Function(double?) onChanged;

  const _InputRow({
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: '$icon  ',
      ),
      onChanged: (s) => onChanged(double.tryParse(s)),
    );
  }
}

class _RateInputRow extends StatelessWidget {
  final String label, icon;
  final double initialValue;
  final void Function(double?) onChanged;

  const _RateInputRow({
    required this.label,
    required this.icon,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller:
          TextEditingController(text: initialValue.toStringAsFixed(0)),
      decoration: InputDecoration(labelText: label, prefixText: '$icon  '),
      onChanged: (s) => onChanged(double.tryParse(s)),
    );
  }
}

// ── Zakat Result Card ─────────────────────────────────────────
class _ZakatResultCard extends StatelessWidget {
  final ZakatEntity result;
  const _ZakatResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_US');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: result.isZakatDue
            ? AppColors.goldGradient
            : const LinearGradient(
                colors: [Color(0xFF1B3A2F), Color(0xFF0D2B1E)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: result.isZakatDue ? AppColors.gold : AppColors.cardBorder,
          width: 2,
        ),
      ),
      child: Column(children: [
        Text(
          result.isZakatDue ? 'Zakat is Due 👏' : 'Zakat Not Due Yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: result.isZakatDue ? AppColors.emeraldDark : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        if (result.isZakatDue) ...[
          Text(
            'PKR ${fmt.format(result.zakatPayable)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.emeraldDark,
            ),
          ),
          const SizedBox(height: 8),
          Text('on total assets: PKR ${fmt.format(result.totalAssetsInPKR)}',
              style: TextStyle(
                  fontSize: 13, color: AppColors.emeraldDark.withOpacity(0.8))),
        ] else ...[
          const SizedBox(height: 8),
          Text('Total: PKR ${fmt.format(result.totalAssetsInPKR)}',
              style: AppTextStyles.titleMedium),
          Text('Nisab used: ${result.nisabUsed}',
              style: AppTextStyles.bodyMedium),
        ],
      ]),
    );
  }
}

// ── History Tile ──────────────────────────────────────────────
class _HistoryTile extends StatelessWidget {
  final ZakatEntity record;
  final VoidCallback onDelete;

  const _HistoryTile({required this.record, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0', 'en_US');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: AppDecorations.card,
      child: Row(children: [
        Icon(
          record.isZakatDue ? Icons.check_circle : Icons.cancel,
          color: record.isZakatDue ? AppColors.gold : AppColors.textMuted,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${record.year} Zakat Calculation',
                style: AppTextStyles.bodyLarge),
            Text(
              record.isZakatDue
                  ? 'Due: PKR ${fmt.format(record.zakatPayable)}'
                  : 'Not due (assets below nisab)',
              style: AppTextStyles.bodyMedium.copyWith(
                  color: record.isZakatDue
                      ? AppColors.gold
                      : AppColors.textMuted),
            ),
          ]),
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: AppColors.textMuted, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ]),
    );
  }
}
