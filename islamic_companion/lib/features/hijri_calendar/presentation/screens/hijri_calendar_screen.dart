// ============================================================
// hijri_calendar_screen.dart
// Hijri (Islamic Lunar) Calendar screen.
// Shows: current Hijri + Gregorian date, month calendar with event
// highlights, moon adjustment control, and upcoming events list.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/features/hijri_calendar/providers/hijri_calendar_provider.dart';

class HijriCalendarScreen extends StatelessWidget {
  const HijriCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Islamic Calendar 📅')),
      body: Consumer<HijriCalendarProvider>(
        builder: (context, provider, _) {
          if (provider.currentHijri == null) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.gold));
          }

          final hijri = provider.currentHijri!;
          final now = DateTime.now();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Dual Date Header ──────────────────────
                _DualDateHeader(
                  hijriDay: hijri.hDay,
                  hijriMonth: provider.hijriMonthName,
                  hijriYear: hijri.hYear,
                  gregorianDate: now,
                ),
                const SizedBox(height: 16),

                // ── Moon Adjustment ───────────────────────
                _MoonAdjustmentCard(
                  adjustment: provider.moonAdjustment,
                  onMinus: () => provider.adjustMoon(-1),
                  onPlus: () => provider.adjustMoon(1),
                  onReset: () => provider.adjustMoon(-provider.moonAdjustment),
                ),
                const SizedBox(height: 16),

                // ── Gregorian Month Calendar ──────────────
                _GregorianCalendarGrid(
                  currentMonth: now,
                  selectedDay: provider.selectedGregorian,
                  onDaySelected: provider.selectDay,
                  hasEvent: provider.hasEventOnGregorianDay,
                ),
                const SizedBox(height: 16),

                // ── Selected Day Info ─────────────────────
                if (provider.selectedHijri != null)
                  _SelectedDayCard(
                    gregorianDay: provider.selectedGregorian,
                    hijriDay: provider.selectedHijri!.hDay,
                    hijriMonth: provider.getHijriMonthName(
                        provider.selectedHijri!.hMonth),
                    hijriYear: provider.selectedHijri!.hYear,
                    events: provider.selectedDayEvents,
                  ),

                const SizedBox(height: 20),

                // ── Islamic Events List ───────────────────
                const Text('Pakistani Islamic Holidays',
                    style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                ...provider.allEvents.map((e) => _EventTile(
                      name: e['name'] as String,
                      hMonth: e['hMonth'] as int,
                      hDay: e['hDay'] as int,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Dual Date Header ──────────────────────────────────────────
class _DualDateHeader extends StatelessWidget {
  final int hijriDay, hijriYear;
  final String hijriMonth;
  final DateTime gregorianDate;

  const _DualDateHeader({
    required this.hijriDay,
    required this.hijriMonth,
    required this.hijriYear,
    required this.gregorianDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.header,
      child: Column(children: [
        // Hijri date (prominent)
        Text(
          '$hijriDay $hijriMonth $hijriYear AH',
          style: AppTextStyles.displayMedium.copyWith(color: AppColors.gold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const Divider(color: AppColors.divider, height: 16),
        // Gregorian date
        Text(
          DateFormat('EEEE, d MMMM yyyy').format(gregorianDate),
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}

// ── Moon Adjustment Card ──────────────────────────────────────
class _MoonAdjustmentCard extends StatelessWidget {
  final int adjustment;
  final VoidCallback onMinus, onPlus, onReset;

  const _MoonAdjustmentCard({
    required this.adjustment,
    required this.onMinus,
    required this.onPlus,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(children: [
        const Icon(Icons.brightness_2, color: AppColors.gold, size: 20),
        const SizedBox(width: 10),
        const Expanded(
          child: Text('Moon Sighting Adjustment',
              style: AppTextStyles.bodyLarge),
        ),
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove_circle_outline, color: AppColors.gold),
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onReset,
          child: Container(
            width: 38,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.emeraldLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${adjustment >= 0 ? '+' : ''}$adjustment',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold),
            ),
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline, color: AppColors.gold),
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ]),
    );
  }
}

// ── Gregorian Calendar Grid ───────────────────────────────────
class _GregorianCalendarGrid extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDay;
  final void Function(DateTime) onDaySelected;
  final bool Function(DateTime) hasEvent;

  const _GregorianCalendarGrid({
    required this.currentMonth,
    required this.selectedDay,
    required this.onDaySelected,
    required this.hasEvent,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay =
        DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; // 0=Sun

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Weekday header
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
            .map((d) => Expanded(
                  child: Center(
                    child: Text(d,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.textMuted)),
                  ),
                ))
            .toList(),
      ),
      const SizedBox(height: 8),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: daysInMonth + startWeekday,
        itemBuilder: (_, i) {
          if (i < startWeekday) return const SizedBox();
          final day = i - startWeekday + 1;
          final date = DateTime(currentMonth.year, currentMonth.month, day);
          final isToday = date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year;
          final isSelected = date.day == selectedDay.day &&
              date.month == selectedDay.month &&
              date.year == selectedDay.year;
          final eventDay = hasEvent(date);

          return GestureDetector(
            onTap: () => onDaySelected(date),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gold
                    : isToday
                        ? AppColors.emeraldLight
                        : AppColors.emeraldMid,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.goldLight
                      : eventDay
                          ? AppColors.emeraldAccent
                          : AppColors.cardBorder,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.emeraldDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (eventDay)
                    Positioned(
                      bottom: 2,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.emeraldAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ]);
  }
}

// ── Selected Day Card ─────────────────────────────────────────
class _SelectedDayCard extends StatelessWidget {
  final DateTime gregorianDay;
  final int hijriDay, hijriYear;
  final String hijriMonth;
  final List<String> events;

  const _SelectedDayCard({
    required this.gregorianDay,
    required this.hijriDay,
    required this.hijriMonth,
    required this.hijriYear,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppDecorations.card,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(DateFormat('EEEE, d MMMM y').format(gregorianDay),
            style: AppTextStyles.titleMedium),
        Text('$hijriDay $hijriMonth $hijriYear AH',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gold)),
        if (events.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...events.map((e) => Row(children: [
                const Icon(Icons.star, color: AppColors.gold, size: 14),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(e, style: AppTextStyles.bodyMedium)),
              ])),
        ],
      ]),
    );
  }
}

// ── Event Tile ────────────────────────────────────────────────
class _EventTile extends StatelessWidget {
  final String name;
  final int hMonth, hDay;
  const _EventTile(
      {required this.name, required this.hMonth, required this.hDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(children: [
        const Icon(Icons.event, color: AppColors.gold, size: 18),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: AppTextStyles.bodyLarge)),
      ]),
    );
  }
}
