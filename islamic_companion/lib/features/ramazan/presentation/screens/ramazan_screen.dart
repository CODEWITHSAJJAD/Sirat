// ============================================================
// ramazan_screen.dart
// Ramazan module full UI.
// Shows: Sehr/Iftar countdown, Roza toggle, Taraweeh tracker,
// Roza streak with badges, and Ramadan calendar grid.
// Auto-activates when Hijri month = 9.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/ramazan/providers/ramazan_provider.dart';
import 'package:intl/intl.dart';

class RamazanScreen extends StatelessWidget {
  const RamazanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ramadan 🌙'),
        actions: [
          Consumer<RamazanProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showMoonAdjustmentSheet(context, provider),
            ),
          ),
        ],
      ),
      body: Consumer<RamazanProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.gold));
          }

          if (!provider.isRamadan) {
            return _NotRamadanView(
              lifetimeFasts: provider.lifetimeFasts,
              longestStreak: provider.longestStreak,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Ramadan Day Header ─────────────────────
                _RamadanHeaderCard(
                  dayNumber: provider.ramadanDayNumber ?? 1,
                  rozaStreak: provider.rozaStreak,
                  badge: provider.rozaBadge,
                ),
                const SizedBox(height: 16),

                // ── Sehr/Iftar Countdown Cards ─────────────
                Row(children: [
                  Expanded(
                    child: _TimeCard(
                      label: 'Sehr',
                      icon: Icons.brightness_3,
                      time: provider.sahrTime,
                      countdown: provider.timeToSahr,
                      color: AppColors.emeraldAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeCard(
                      label: 'Iftar',
                      icon: Icons.wb_twilight,
                      time: provider.iftarTime,
                      countdown: provider.timeToIftar,
                      color: AppColors.gold,
                    ),
                  ),
                ]),
                const SizedBox(height: 16),

                // ── Roza Toggle ────────────────────────────
                _ToggleCard(
                  icon: '🌙',
                  title: "Today's Roza",
                  subtitle: provider.rozaCompleted
                      ? 'Masha Allah! Roza complete'
                      : 'Mark your fast',
                  value: provider.rozaCompleted,
                  onChanged: provider.toggleRoza,
                  activeColor: AppColors.gold,
                ),
                const SizedBox(height: 10),

                // ── Taraweeh Toggle ────────────────────────
                _ToggleCard(
                  icon: '🕌',
                  title: 'Taraweeh',
                  subtitle: provider.taraweehDone
                      ? 'Taraweeh prayed tonight'
                      : 'Mark Taraweeh prayer',
                  value: provider.taraweehDone,
                  onChanged: provider.toggleTaraweeh,
                  activeColor: AppColors.emeraldAccent,
                ),
                const SizedBox(height: 20),

                // ── Stats Row ──────────────────────────────
                Row(children: [
                  _StatChip(
                      label: 'Current Streak',
                      value: '${provider.rozaStreak} days 🔥'),
                  const SizedBox(width: 10),
                  _StatChip(
                      label: 'Lifetime Fasts',
                      value: '${provider.lifetimeFasts} 🌙'),
                  const SizedBox(width: 10),
                  _StatChip(
                      label: 'Best Streak',
                      value: '${provider.longestStreak} days'),
                ]),
                const SizedBox(height: 20),

                // ── Ramadan Calendar Grid ──────────────────
                const Text('Ramadan Calendar',
                    style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                _RamadanCalendarGrid(
                  allDays: provider.allDays,
                  currentDay: provider.ramadanDayNumber ?? 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMoonAdjustmentSheet(BuildContext context, RamazanProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.emeraldMid,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Moon Sighting Adjustment',
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Adjust calendar based on actual moon sighting in your region.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            const Text(
              'Current Adjustment:',
              style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AdjustmentButton(
                  label: '-1 Day',
                  isSelected: provider.moonAdjustment == -1,
                  onTap: () {
                    provider.setMoonAdjustment(-1);
                    Navigator.pop(ctx);
                  },
                ),
                _AdjustmentButton(
                  label: '0 Days',
                  isSelected: provider.moonAdjustment == 0,
                  onTap: () {
                    provider.setMoonAdjustment(0);
                    Navigator.pop(ctx);
                  },
                ),
                _AdjustmentButton(
                  label: '+1 Day',
                  isSelected: provider.moonAdjustment == 1,
                  onTap: () {
                    provider.setMoonAdjustment(1);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.emeraldDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: AppColors.gold),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'For Pakistan, typically use +1 day if calendar shows wrong Ramadan dates.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AdjustmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdjustmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.emeraldDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.emeraldDark : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Not Ramadan Placeholder ───────────────────────────────────
class _NotRamadanView extends StatelessWidget {
  final int lifetimeFasts;
  final int longestStreak;
  const _NotRamadanView(
      {required this.lifetimeFasts, required this.longestStreak});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌙', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text('Ramadan is not active yet.',
                style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
                'This section will automatically activate during the blessed month of Ramadan.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoItem(label: 'Lifetime Fasts', value: '$lifetimeFasts'),
                  _InfoItem(label: 'Best Streak', value: '$longestStreak'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label, value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.displayMedium.copyWith(color: AppColors.gold)),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

// ── Ramadan Header Card ───────────────────────────────────────
class _RamadanHeaderCard extends StatelessWidget {
  final int dayNumber;
  final int rozaStreak;
  final String? badge;
  const _RamadanHeaderCard(
      {required this.dayNumber, required this.rozaStreak, this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2B1E), Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Column(children: [
        const Text('رَمَضَان مُبَارَك', style: AppTextStyles.arabicLarge),
        const SizedBox(height: 4),
        Text('Day $dayNumber of Ramadan',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold)),
        if (badge != null) ...[
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge!,
                style: TextStyle(
                    color: AppColors.emeraldDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ),
        ],
      ]),
    );
  }
}

// ── Time Card (Sehr/Iftar) ────────────────────────────────────
class _TimeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final DateTime? time;
  final Duration countdown;
  final Color color;
  const _TimeCard({
    required this.label,
    required this.icon,
    required this.time,
    required this.countdown,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = time != null
        ? DateFormat('hh:mm a').format(time!)
        : '--:--';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(timeStr,
            style: AppTextStyles.titleMedium.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(
          formatCountdown(countdown),
          style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600),
        ),
        Text('remaining', style: AppTextStyles.labelSmall),
      ]),
    );
  }
}

// ── Toggle Card (Roza / Taraweeh) ───────────────────────────
class _ToggleCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final Future<void> Function(bool) onChanged;
  final Color activeColor;

  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: value
            ? activeColor.withOpacity(0.12)
            : AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: value ? activeColor : AppColors.cardBorder,
            width: value ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: AppTextStyles.titleMedium
                      .copyWith(color: value ? activeColor : AppColors.textPrimary)),
              Text(subtitle, style: AppTextStyles.bodyMedium),
            ]),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label, value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.emeraldMid,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(children: [
          Text(value,
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColors.gold, fontSize: 15),
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Ramadan Calendar Grid ─────────────────────────────────────
class _RamadanCalendarGrid extends StatelessWidget {
  final List allDays;
  final int currentDay;
  const _RamadanCalendarGrid(
      {required this.allDays, required this.currentDay});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.9,
      ),
      itemCount: 30,
      itemBuilder: (_, i) {
        final dayNum = i + 1;
        final dayData = allDays.where((d) => d.hijriDay == dayNum).isNotEmpty
            ? allDays.firstWhere((d) => d.hijriDay == dayNum)
            : null;
        final isCurrent = dayNum == currentDay;
        final rozaDone = dayData?.rozaCompleted ?? false;
        final taraweehDone = dayData?.taraweehDone ?? false;
        final isPast = dayNum < currentDay;

        return Container(
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColors.gold
                : rozaDone
                    ? AppColors.emeraldLight
                    : isPast
                        ? AppColors.emeraldMid.withOpacity(0.5)
                        : AppColors.emeraldMid,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCurrent ? AppColors.goldLight : AppColors.cardBorder,
              width: isCurrent ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$dayNum',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isCurrent ? AppColors.emeraldDark : AppColors.textPrimary,
                ),
              ),
              if (rozaDone) const Text('🌙', style: TextStyle(fontSize: 9)),
              if (taraweehDone) const Text('🕌', style: TextStyle(fontSize: 9)),
            ],
          ),
        );
      },
    );
  }
}
