// ============================================================
// home_screen.dart
// Main dashboard — the first screen users see.
// Shows: Hijri/Gregorian date, next prayer countdown,
// Ramadan card (when active), namaz streak,
// daily Ayah, quick-access feature grid.
// ============================================================

import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/prayer/providers/prayer_times_provider.dart';
import 'package:islamic_companion/features/namaz_streak/providers/namaz_streak_provider.dart';
import 'package:islamic_companion/features/ramazan/providers/ramazan_provider.dart';
import 'package:islamic_companion/features/hijri_calendar/providers/hijri_calendar_provider.dart';
import 'package:islamic_companion/features/daily_content/providers/daily_content_provider.dart';
import 'package:islamic_companion/features/daily_content/presentation/widgets/daily_content_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HijriCalendarProvider>(
      builder: (context, hijriProvider, _) {
        // Get adjusted Hijri date based on moon sighting
        final hijri = hijriProvider.currentHijri ?? HijriCalendar.now();
        final now = DateTime.now();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // ── Sliver AppBar ──────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: AppColors.emeraldDark,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(gradient: AppColors.headerGradient),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            // Arabic greeting
                            const Text('السَّلَامُ عَلَيْكُمْ',
                                style: AppTextStyles.arabicLarge),
                            const SizedBox(height: 6),
                            // Hijri date
                            Text(
                              '${hijri.hDay} ${hijriProvider.hijriMonthName} ${hijri.hYear} AH',
                              style: AppTextStyles.titleLarge
                                  .copyWith(color: AppColors.gold),
                            ),
                            // Gregorian date
                            Text(
                              DateFormat('EEEE, d MMMM y').format(now),
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            // Tagline
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.emeraldDark.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.gold.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                'Your Daily Journey Towards Sirat al-Mustaqeem',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Next Prayer Card ───────────────────────
                _NextPrayerCard(),
                const SizedBox(height: 14),

                // ── Ramazan Banner (when active) ──────────
                _RamadanBannerSection(),

                // ── Namaz Streak Summary ──────────────────
                _NamazStreakBanner(),
                const SizedBox(height: 14),

                // ── Quick Feature Grid ────────────────────
                const Text('Features', style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                _FeatureGrid(),
                const SizedBox(height: 20),

                // ── Daily Ayah ─────────────────────────────
                const Text('Ayah of the Day', style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                Consumer<DailyContentProvider>(
                  builder: (_, dp, __) {
                    if (dp.todayAyah == null) return const SizedBox.shrink();
                    return DailyContentCard(
                        content: dp.todayAyah!, compact: true);
                  },
                ),
                const SizedBox(height: 14),

                // ── Daily Hadith ──────────────────────────
                Consumer<DailyContentProvider>(
                  builder: (_, dp, __) {
                    if (dp.todayHadith == null) return const SizedBox.shrink();
                    return DailyContentCard(
                        content: dp.todayHadith!, compact: true);
                  },
                ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
    });
  }

  static const List<String> _hijriMonths = [
    'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
    'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Shaban',
    'Ramadan', 'Shawwal', 'Dhul Qadah', 'Dhul Hijjah',
  ];
  static String _hijriMonthName(int m) =>
      (m >= 1 && m <= 12) ? _hijriMonths[m - 1] : '';
}

// ── Next Prayer Card ──────────────────────────────────────────
class _NextPrayerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(builder: (_, p, __) {
      if (p.currentPrayerTimes == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card,
          child: const Row(children: [
            Icon(Icons.location_searching, color: AppColors.gold),
            SizedBox(width: 10),
            Text('Getting prayer times…', style: AppTextStyles.bodyMedium),
          ]),
        );
      }
      final pt = p.currentPrayerTimes!;
      final nextName = pt.getNextPrayer(DateTime.now())?.key ?? 'Fajr';
      final nextTime = pt.getNextPrayer(DateTime.now())?.value;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: AppDecorations.header,
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.gold, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Next Prayer', style: AppTextStyles.labelSmall),
                Text(nextName,
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold)),
                if (nextTime != null)
                  Text(
                    nextTime.toTimeString(),
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
              ]),
            ),
            // Countdown
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Time left', style: AppTextStyles.labelSmall),
              Text(
                formatCountdown(p.countdown),
                style: AppTextStyles.displayMedium.copyWith(color: AppColors.gold),
              ),
            ]),
          ],
        ),
      );
    });
  }
}

// ── Ramadan Banner ────────────────────────────────────────────
class _RamadanBanner extends StatelessWidget {
  final int dayNumber;
  final String phase;
  final DateTime? targetTime;
  final Duration countdown;

  const _RamadanBanner({
    required this.dayNumber,
    required this.phase,
    required this.targetTime,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    final isSehr = phase == 'Sehr';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2B1E), Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.gold.withOpacity(0.35)),
      ),
      child: Row(children: [
        Icon(
          isSehr ? Icons.brightness_3 : Icons.wb_twilight,
          color: isSehr ? AppColors.emeraldAccent : AppColors.gold,
          size: 32,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ramadan Day $dayNumber',
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.gold)),
            Text(
              targetTime != null
                  ? '${isSehr ? 'Sehr' : 'Iftar'} at ${targetTime!.toTimeString()}'
                  : '${isSehr ? 'Sehr' : 'Iftar'} time loading…',
              style: AppTextStyles.bodyMedium,
            ),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${isSehr ? 'Sehr' : 'Iftar'} in', style: AppTextStyles.labelSmall),
          Text(formatCountdown(countdown),
              style:
                  AppTextStyles.titleLarge.copyWith(color: AppColors.gold)),
        ]),
      ]),
    );
  }
}

// ── Ramadan Banner Widget for Home Screen ───────────────────────
class _RamadanBannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hp = context.watch<HijriCalendarProvider>();
    final rp = context.watch<RamazanProvider>();
    
    // Refresh Ramadan status when Hijri calendar changes (moon adjustment)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rp.refreshFromHijri();
    });
    
    final isRamadan = hp.currentHijri?.hMonth == 9;
    if (!isRamadan) return const SizedBox.shrink();
    return Column(children: [
      _RamadanBanner(
        dayNumber: rp.ramadanDayNumber ?? 1,
        phase: rp.currentFastPhase,
        targetTime: rp.activeTime,
        countdown: rp.activeCountdown,
      ),
      const SizedBox(height: 14),
    ]);
  }
}

// ── Namaz Streak Banner ────────────────────────────────────────
class _NamazStreakBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NamazStreakProvider>(builder: (_, ns, __) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppDecorations.card,
        child: Row(children: [
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${ns.today.completedCount} / 5 prayers today',
                  style: AppTextStyles.titleMedium),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ns.today.completedCount / 5,
                  minHeight: 6,
                  backgroundColor: AppColors.emeraldLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
              ),
            ]),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('🔥 ${ns.currentStreak}',
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold)),
            const Text('streak', style: AppTextStyles.labelSmall),
          ]),
        ]),
      );
    });
  }
}

// ── Feature Grid ──────────────────────────────────────────────
class _FeatureGrid extends StatelessWidget {
  static const List<Map<String, dynamic>> _features = [
    {'label': 'Prayer Times', 'icon': '🕌', 'route': '/prayer'},
    {'label': 'Namaz Streak', 'icon': '🔥', 'route': '/streak'},
    {'label': 'Tasbeeh', 'icon': '📿', 'route': '/tasbeeh'},
    {'label': 'Ramazan', 'icon': '🌙', 'route': '/ramazan'},
    {'label': 'Hijri Calendar', 'icon': '📅', 'route': '/calendar'},
    {'label': 'Zakat Calculator', 'icon': '💛', 'route': '/zakat'},
    {'label': 'Daily Content', 'icon': '📖', 'route': '/content'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: _features
          .map((f) => _FeatureTile(
                label: f['label'] as String,
                icon: f['icon'] as String,
                route: f['route'] as String,
              ))
          .toList(),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String label, icon, route;
  const _FeatureTile({required this.label, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.emeraldMid,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2),
          ],
        ),
      ),
    );
  }
}
