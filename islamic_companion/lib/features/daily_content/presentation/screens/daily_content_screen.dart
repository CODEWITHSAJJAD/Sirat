// ============================================================
// daily_content_screen.dart
// Full Islamic content screen with Ayah / Hadith / Dua tabs.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/features/daily_content/providers/daily_content_provider.dart';
import 'package:islamic_companion/features/daily_content/presentation/widgets/daily_content_card.dart';
import 'package:islamic_companion/features/daily_content/domain/entities/daily_content_entity.dart';

class DailyContentScreen extends StatelessWidget {
  const DailyContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Islamic Content 📖'),
          bottom: const TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [
              Tab(text: 'Ayah'),
              Tab(text: 'Hadith'),
              Tab(text: "Dua"),
            ],
          ),
        ),
        body: Consumer<DailyContentProvider>(
          builder: (context, provider, _) {
            return TabBarView(
              children: [
                // ── Ayah Tab ──────────────────────────────
                _SingleContentView(
                  content: provider.todayAyah,
                  emptyLabel: 'Loading today\'s Ayah...',
                ),
                // ── Hadith Tab ────────────────────────────
                _SingleContentView(
                  content: provider.todayHadith,
                  emptyLabel: 'Loading today\'s Hadith...',
                ),
                // ── Duas Tab ──────────────────────────────
                _DuaListView(duas: provider.allDuas),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SingleContentView extends StatelessWidget {
  final DailyContentEntity? content;
  final String emptyLabel;
  const _SingleContentView({this.content, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (content == null) {
      return Center(
          child: Text(emptyLabel, style: AppTextStyles.bodyMedium));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DailyContentCard(content: content!),
    );
  }
}

class _DuaListView extends StatelessWidget {
  final List<DailyContentEntity> duas;
  const _DuaListView({required this.duas});

  @override
  Widget build(BuildContext context) {
    if (duas.isEmpty) {
      return const Center(
          child: Text('Loading duas...', style: AppTextStyles.bodyMedium));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: duas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => DailyContentCard(content: duas[i]),
    );
  }
}
