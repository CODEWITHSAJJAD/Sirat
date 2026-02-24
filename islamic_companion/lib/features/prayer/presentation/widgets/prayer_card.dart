// ============================================================
// prayer_card.dart
// A single row card for one prayer time.
// Highlights the current/active prayer in gold.
// ============================================================

import 'package:flutter/material.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final DateTime prayerTime;
  final bool isActive;   // Currently active prayer window
  final bool isNext;     // Next upcoming prayer

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    this.isActive = false,
    this.isNext = false,
  });

  // Icon for each prayer
  static const Map<String, IconData> _icons = {
    'Fajr': Icons.brightness_3,
    'Dhuhr': Icons.wb_sunny,
    'Asr': Icons.wb_cloudy,
    'Maghrib': Icons.wb_twilight,
    'Isha': Icons.nights_stay,
  };

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('hh:mm a').format(prayerTime);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        gradient: isActive
            ? AppColors.goldGradient
            : isNext
                ? const LinearGradient(
                    colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                  )
                : null,
        color: isActive || isNext ? null : AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive
              ? AppColors.gold
              : isNext
                  ? AppColors.emeraldAccent
                  : AppColors.cardBorder,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            // Prayer icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.emeraldDark.withOpacity(0.3)
                    : AppColors.emeraldLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icons[prayerName] ?? Icons.access_time,
                color: isActive ? AppColors.emeraldDark : AppColors.gold,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),

            // Prayer name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppColors.emeraldDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (isActive)
                    Text(
                      'Current Prayer',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.emeraldDark.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (isNext)
                    const Text(
                      'Next Prayer',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.emeraldAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

            // Prayer time
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isActive ? AppColors.emeraldDark : AppColors.gold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
