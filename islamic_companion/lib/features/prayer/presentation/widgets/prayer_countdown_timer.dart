// ============================================================
// prayer_countdown_timer.dart
// Displays live countdown to next prayer with gold styling.
// Consumes PrayerTimesProvider for real-time updates.
// ============================================================

import 'package:flutter/material.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';

class PrayerCountdownTimer extends StatelessWidget {
  final String nextPrayerName;
  final Duration countdown;

  const PrayerCountdownTimer({
    super.key,
    required this.nextPrayerName,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: AppDecorations.header,
      child: Column(
        children: [
          Text(
            'Next Prayer',
            style: AppTextStyles.labelSmall.copyWith(
              letterSpacing: 2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nextPrayerName,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.gold,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          // Countdown display: HH:MM:SS
          Text(
            formatCountdown(countdown),
            style: AppTextStyles.countdownTimer,
          ),
          const SizedBox(height: 6),
          Text(
            'Allahu Akbar',
            style: AppTextStyles.arabicMedium.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
