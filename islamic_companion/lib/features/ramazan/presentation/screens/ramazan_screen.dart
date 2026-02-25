// ============================================================
// ramazan_screen.dart
// Ramadan module full UI.
// Shows: Sehr/Iftar countdown, Roza toggle, Taraweeh tracker,
// Roza streak with badges, and Ramadan calendar grid.
// Auto-activates when Hijri month = 9.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/ramazan/providers/ramazan_provider.dart';
import 'package:islamic_companion/features/hijri_calendar/providers/hijri_calendar_provider.dart';
import 'package:intl/intl.dart';

class RamazanScreen extends StatelessWidget {
  const RamazanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hp = context.watch<HijriCalendarProvider>();
    final rp = context.watch<RamazanProvider>();
    
    // Refresh Ramadan status when Hijri calendar changes (moon adjustment)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rp.refreshFromHijri();
    });
    
    final isRamadan = hp.currentHijri?.hMonth == 9;
    if (rp.isLoading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }
    if (!isRamadan) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ramadan 🌙')),
        body: _NotRamadanView(
          lifetimeFasts: rp.lifetimeFasts,
          longestStreak: rp.longestStreak,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ramadan 🌙')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RamadanHeaderCard(
              dayNumber: rp.ramadanDayNumber ?? 1,
              rozaStreak: rp.rozaStreak,
              badge: rp.rozaBadge,
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: _TimeCard(
                  label: 'Sehr',
                  icon: Icons.brightness_3,
                  time: rp.sahrTime,
                  countdown: rp.timeToSahr,
                  color: AppColors.emeraldAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimeCard(
                  label: 'Iftar',
                  icon: Icons.wb_twilight,
                  time: rp.iftarTime,
                  countdown: rp.timeToIftar,
                  color: AppColors.gold,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _ToggleCard(
              icon: '🌙',
              title: "Today's Roza",
              subtitle: rp.rozaCompleted
                  ? 'Masha Allah! Roza complete'
                  : 'Mark your fast',
              value: rp.rozaCompleted,
              onChanged: rp.toggleRoza,
              activeColor: AppColors.gold,
            ),
            const SizedBox(height: 10),
            _ToggleCard(
              icon: '🕌',
              title: 'Taraweeh',
              subtitle: rp.taraweehDone
                  ? 'Taraweeh prayed tonight'
                  : 'Mark Taraweeh prayer',
              value: rp.taraweehDone,
              onChanged: rp.toggleTaraweeh,
              activeColor: AppColors.emeraldAccent,
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: _StatChip(
                    label: 'Current Streak',
                    value: '${rp.rozaStreak} 🔥'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatChip(
                    label: 'Lifetime Fasts',
                    value: '${rp.lifetimeFasts} 🌙'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatChip(
                    label: 'Best Streak',
                    value: '${rp.longestStreak}'),
              ),
            ]),
            const SizedBox(height: 20),
            const Text('Ramadan Calendar', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            _RamadanCalendarGrid(allDays: rp.allDays, currentDay: rp.ramadanDayNumber ?? 1),
          ],
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
          Material(
            color: Colors.transparent,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: [
        Text(value,
            style: AppTextStyles.titleMedium
                .copyWith(color: AppColors.gold, fontSize: 14),
            textAlign: TextAlign.center),
        const SizedBox(height: 2),
        Text(label,
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center),
      ]),
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
