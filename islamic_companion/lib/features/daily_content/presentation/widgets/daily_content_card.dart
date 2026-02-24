// ============================================================
// daily_content_card.dart
// Reusable card widget for displaying one Islamic content item.
// Used on both the Home Dashboard and specific content screens.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/features/daily_content/domain/entities/daily_content_entity.dart';

class DailyContentCard extends StatelessWidget {
  final DailyContentEntity content;
  final bool compact;

  const DailyContentCard({
    super.key,
    required this.content,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = _typeLabel(content.type);
    final typeColor = _typeColor(content.type);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 20),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: typeColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Type badge ──────────────────────────────────
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: typeColor.withOpacity(0.4)),
              ),
              child: Text(
                typeLabel,
                style: TextStyle(
                    color: typeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5),
              ),
            ),
            const Spacer(),
            // Copy button
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                    text: '${content.arabic}\n\n${content.translation}\n— ${content.reference}'));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Copied to clipboard!'),
                    duration: Duration(seconds: 1)));
              },
              icon: const Icon(Icons.copy, size: 16, color: AppColors.textMuted),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ]),

          const SizedBox(height: 14),

          // ── Arabic text ─────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              content.arabic,
              style: compact
                  ? AppTextStyles.arabicMedium
                  : AppTextStyles.arabicLarge,
              textAlign: TextAlign.right,
            ),
          ),

          const SizedBox(height: 12),

          // ── Translation ─────────────────────────────────
          Text(
            content.translation,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          // ── Reference ───────────────────────────────────
          Text(
            '— ${content.reference}',
            style: AppTextStyles.labelSmall.copyWith(
              color: typeColor,
              fontStyle: FontStyle.italic,
            ),
          ),

          if (content.category.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(content.category,
                style: AppTextStyles.labelSmall
                    .copyWith(color: AppColors.textMuted)),
          ],
        ],
      ),
    );
  }

  static String _typeLabel(DailyContentType type) {
    switch (type) {
      case DailyContentType.ayah: return '📖 Ayah of the Day';
      case DailyContentType.hadith: return '📜 Hadith of the Day';
      case DailyContentType.dua: return '🤲 Daily Dua';
      case DailyContentType.quote: return '✨ Islamic Quote';
    }
  }

  static Color _typeColor(DailyContentType type) {
    switch (type) {
      case DailyContentType.ayah: return AppColors.gold;
      case DailyContentType.hadith: return AppColors.emeraldAccent;
      case DailyContentType.dua: return const Color(0xFF7EB3FF);
      case DailyContentType.quote: return const Color(0xFFE9A6FF);
    }
  }
}
