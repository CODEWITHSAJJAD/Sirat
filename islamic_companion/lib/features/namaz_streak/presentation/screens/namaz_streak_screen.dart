// ============================================================
// namaz_streak_screen.dart
// Full Namaz Streak UI screen.
// Shows: streak display, today's prayer checkboxes,
// monthly calendar analytics, and motivational quote.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/namaz_streak/providers/namaz_streak_provider.dart';

class NamazStreakScreen extends StatelessWidget {
  const NamazStreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Namaz Streak 🔥')),
      body: Consumer<NamazStreakProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.gold));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Streak Summary ─────────────────────────
                _StreakSummaryCard(
                  currentStreak: provider.currentStreak,
                  longestStreak: provider.longestStreak,
                  completedToday: provider.today.completedCount,
                ),
                const SizedBox(height: 16),

                // ── Motivational Quote ─────────────────────
                if (provider.motivationalQuote.isNotEmpty)
                  _MotivationalQuoteCard(quote: provider.motivationalQuote),

                // ── Today's Prayers ────────────────────────
                const Text("Today's Prayers",
                    style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                ...AppConstants.prayerNames.map((name) => _PrayerCheckRow(
                      prayerName: name,
                      isChecked: provider.getPrayerStatus(name),
                      onChanged: (v) => provider.togglePrayer(name, v ?? false),
                    )),

                const SizedBox(height: 24),

                // ── Monthly Analytics ──────────────────────
                const Text('This Month', style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                _MonthlyGrid(monthDays: provider.monthDays),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Streak Summary Card ───────────────────────────────────────
class _StreakSummaryCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int completedToday;
  const _StreakSummaryCard({
    required this.currentStreak,
    required this.longestStreak,
    required this.completedToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.header,
      child: Column(
        children: [
          Text(
            '🔥 $currentStreak Day Streak',
            style: AppTextStyles.displayLarge.copyWith(color: AppColors.gold),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedToday / 5 prayers today',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          // Progress bar for today prayers
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completedToday / 5,
              minHeight: 10,
              backgroundColor: AppColors.emeraldLight,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: AppColors.goldLight,
                  size: 18),
              const SizedBox(width: 6),
              Text('Best: $longestStreak days',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.goldLight)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Prayer Checkbox Row ───────────────────────────────────────
class _PrayerCheckRow extends StatelessWidget {
  final String prayerName;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  static const Map<String, String> _arabicNames = {
    'Fajr': 'فجر',
    'Dhuhr': 'ظہر',
    'Asr': 'عصر',
    'Maghrib': 'مغرب',
    'Isha': 'عشاء',
  };

  const _PrayerCheckRow({
    required this.prayerName,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isChecked
            ? AppColors.emeraldLight.withOpacity(0.6)
            : AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isChecked ? AppColors.gold : AppColors.cardBorder,
          width: isChecked ? 1.5 : 1,
        ),
      ),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: onChanged,
        title: Row(
          children: [
            Text(prayerName, style: AppTextStyles.titleMedium),
            const Spacer(),
            Text(
              _arabicNames[prayerName] ?? '',
              style: AppTextStyles.arabicMedium.copyWith(fontSize: 16),
            ),
          ],
        ),
        secondary: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isChecked
              ? const Icon(Icons.check_circle, color: AppColors.gold,
                  key: ValueKey('checked'))
              : const Icon(Icons.radio_button_unchecked,
                  color: AppColors.textMuted, key: ValueKey('unchecked')),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

// ── Monthly Grid ──────────────────────────────────────────────
class _MonthlyGrid extends StatelessWidget {
  final List monthDays;
  const _MonthlyGrid({required this.monthDays});

  @override
  Widget build(BuildContext context) {
    if (monthDays.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemCount: monthDays.length,
      itemBuilder: (_, i) {
        final day = monthDays[i];
        final dayNum = i + 1;
        final completed = day.completedCount as int;
        return Container(
          decoration: BoxDecoration(
            color: day.isFullDay
                ? AppColors.gold
                : completed > 0
                    ? AppColors.emeraldLight
                    : AppColors.emeraldMid,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder, width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$dayNum',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: day.isFullDay
                      ? AppColors.emeraldDark
                      : AppColors.textPrimary,
                ),
              ),
              if (completed > 0 && !day.isFullDay)
                Text(
                  '$completed/5',
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.emeraldAccent,
                  ),
                ),
              if (day.isFullDay)
                const Text('🔥', style: TextStyle(fontSize: 9)),
            ],
          ),
        );
      },
    );
  }
}

// ── Motivational Quote Card ───────────────────────────────────
class _MotivationalQuoteCard extends StatelessWidget {
  final String quote;
  const _MotivationalQuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('✨', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              quote,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.emeraldDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
