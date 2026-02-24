// ============================================================
// prayer_times_screen.dart
// Main Prayer Times feature screen.
// Shows: next prayer countdown, all 5 prayer cards, city selector,
// Azan toggle, and per-prayer offset adjustments.
// Only reads from PrayerTimesProvider — zero business logic here.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/prayer/providers/prayer_times_provider.dart';
import 'package:islamic_companion/features/prayer/presentation/widgets/prayer_card.dart';
import 'package:islamic_companion/features/prayer/presentation/widgets/prayer_countdown_timer.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          // City selector button
          Consumer<PrayerTimesProvider>(
            builder: (_, provider, __) => TextButton.icon(
              onPressed: () => _showCitySelector(context, provider),
              icon: const Icon(Icons.location_on, size: 16),
              label: Text(
                provider.currentCityName,
                style: const TextStyle(color: AppColors.gold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<PrayerTimesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          if (provider.loadState == PrayerLoadState.error) {
            return _ErrorView(
              message: provider.errorMessage,
              onRetry: provider.refresh,
            );
          }

          final prayers = provider.prayerTimes;
          if (prayers == null) return const SizedBox.shrink();

          final nextPrayer = provider.nextPrayer;
          final currentPrayer = provider.currentPrayer;

          return RefreshIndicator(
            color: AppColors.gold,
            backgroundColor: AppColors.emeraldMid,
            onRefresh: provider.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Next Prayer Countdown ──────────────────
                  if (nextPrayer != null)
                    PrayerCountdownTimer(
                      nextPrayerName: nextPrayer.key,
                      countdown: provider.countdown,
                    ),

                  const SizedBox(height: 24),

                  // ── Today's Prayers label ──────────────────
                  Row(
                    children: [
                      const Text('Today\'s Prayers',
                          style: AppTextStyles.titleLarge),
                      const Spacer(),
                      // Azan toggle
                      Row(
                        children: [
                          const Icon(Icons.volume_up,
                              size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text('Azan',
                              style: AppTextStyles.labelSmall
                                  .copyWith(color: AppColors.textMuted)),
                          const SizedBox(width: 4),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: provider.settings?.azanEnabled ?? true,
                              onChanged: provider.toggleAzan,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Prayer Cards ───────────────────────────
                  ...prayers.allPrayers.map((entry) {
                    final isActive = currentPrayer?.key == entry.key;
                    final isNext = nextPrayer?.key == entry.key;
                    return GestureDetector(
                      onLongPress: () =>
                          _showOffsetDialog(context, provider, entry.key),
                      child: PrayerCard(
                        prayerName: entry.key,
                        prayerTime: entry.value,
                        isActive: isActive,
                        isNext: isNext,
                      ),
                    );
                  }),

                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Long-press a prayer to adjust minutes offset',
                      style: AppTextStyles.labelSmall,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Sunrise Card ───────────────────────────
                  _SunriseCard(sunrise: prayers.sunrise),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCitySelector(BuildContext context, PrayerTimesProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.emeraldMid,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CitySelectorSheet(provider: provider),
    );
  }

  void _showOffsetDialog(
      BuildContext context, PrayerTimesProvider provider, String prayerName) {
    int currentOffset = provider.getOffset(prayerName);
    int tempOffset = currentOffset;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.emeraldMid,
          title: Text('Adjust $prayerName',
              style: AppTextStyles.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Minutes offset (±30)',
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (tempOffset > -30) setState(() => tempOffset--);
                    },
                    icon: const Icon(Icons.remove_circle_outline,
                        color: AppColors.gold),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${tempOffset >= 0 ? '+' : ''}$tempOffset min',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: AppColors.gold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (tempOffset < 30) setState(() => tempOffset++);
                    },
                    icon: const Icon(Icons.add_circle_outline,
                        color: AppColors.gold),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateOffset(prayerName, tempOffset);
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── City Selector Bottom Sheet ────────────────────────────────
class _CitySelectorSheet extends StatelessWidget {
  final PrayerTimesProvider provider;
  const _CitySelectorSheet({required this.provider});

  @override
  Widget build(BuildContext context) {
    final cities = AppConstants.pakistaniCities;
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textMuted,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Select City', style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: cities.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (_, i) {
              final city = cities[i];
              final isSelected =
                  provider.currentCityName == city['name'];
              return ListTile(
                onTap: () {
                  provider.selectCity(city);
                  Navigator.pop(context);
                },
                title: Text(
                  city['name'] as String,
                  style: TextStyle(
                    color: isSelected ? AppColors.gold : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.gold,
                        size: 20)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Sunrise Card ──────────────────────────────────────────────
class _SunriseCard extends StatelessWidget {
  final DateTime sunrise;
  const _SunriseCard({required this.sunrise});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')} AM';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny_outlined,
              color: AppColors.goldLight, size: 22),
          const SizedBox(width: 14),
          const Text('Sunrise', style: AppTextStyles.bodyLarge),
          const Spacer(),
          Text(timeStr,
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColors.goldLight)),
        ],
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
