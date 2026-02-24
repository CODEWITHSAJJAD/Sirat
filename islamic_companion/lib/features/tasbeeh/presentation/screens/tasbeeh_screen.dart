// ============================================================
// tasbeeh_screen.dart
// Full Tasbeeh counter UI.
// Features: large circular counter button, circular progress ring,
// preset selector, custom tasbeeh dialog, vibration/sound toggles,
// today's session history.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/features/tasbeeh/providers/tasbeeh_provider.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbeeh Counter 📿'),
        actions: [
          Consumer<TasbeehProvider>(
            builder: (_, p, __) => Row(
              children: [
                IconButton(
                  tooltip: 'Vibration',
                  onPressed: p.toggleVibration,
                  icon: Icon(
                    p.vibrationEnabled ? Icons.vibration : Icons.phone_android,
                    color: p.vibrationEnabled ? AppColors.gold : AppColors.textMuted,
                  ),
                ),
                IconButton(
                  tooltip: 'Sound',
                  onPressed: p.toggleSound,
                  icon: Icon(
                    p.soundEnabled ? Icons.volume_up : Icons.volume_off,
                    color: p.soundEnabled ? AppColors.gold : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<TasbeehProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ── Preset Selector ───────────────────────
                _PresetSelector(
                  presets: provider.presets,
                  activeName: provider.activeName,
                  onSelect: provider.selectPreset,
                  onCustom: () => _showCustomDialog(context, provider),
                  onEdit: () => _showEditZikarDialog(context, provider),
                  onDelete: (name) => _confirmDelete(context, provider, name),
                ),

                const SizedBox(height: 28),

                // ── Arabic Name Display ───────────────────
                Text(provider.activeArabic, style: AppTextStyles.arabicLarge),
                const SizedBox(height: 4),
                Text(provider.activeName,
                    style: AppTextStyles.goldLabel.copyWith(fontSize: 14)),

                const SizedBox(height: 32),

                // ── Circular Counter ──────────────────────
                _CircularCounter(
                  count: provider.currentCount,
                  target: provider.activeTarget,
                  progress: provider.progress,
                  isCompleted: provider.isCompleted,
                  onTap: provider.tap,
                ),

                const SizedBox(height: 20),

                // ── Progress text ─────────────────────────
                Text(
                  '${provider.currentCount} / ${provider.activeTarget}',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: provider.isCompleted
                        ? AppColors.gold
                        : AppColors.textPrimary,
                  ),
                ),

                if (provider.isCompleted) ...[
                  const SizedBox(height: 8),
                  const Text('ما شاء الله! Completed 🎉',
                      style: AppTextStyles.arabicMedium),
                ],

                const SizedBox(height: 24),

                // ── Reset Button ──────────────────────────
                OutlinedButton.icon(
                  onPressed: provider.reset,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(color: AppColors.gold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Today's Sessions ──────────────────────
                if (provider.todaySessions.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Today's Sessions",
                        style: AppTextStyles.titleMedium),
                  ),
                  const SizedBox(height: 10),
                  ...provider.todaySessions.map((s) => _SessionTile(
                        name: s.name,
                        arabic: s.arabic,
                        count: s.currentCount,
                        target: s.targetCount,
                        isCompleted: s.isCompleted,
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCustomDialog(BuildContext context, TasbeehProvider provider) {
    final nameCtrl = TextEditingController();
    final arabicCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '33');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.emeraldMid,
        title: const Text('Add Custom Tasbeeh', style: AppTextStyles.titleLarge),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Name (e.g. SubhanAllah)'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: arabicCtrl,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(labelText: 'Arabic text'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: targetCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Target count'),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final arabic = arabicCtrl.text.trim();
              final target = int.tryParse(targetCtrl.text) ?? 33;
              if (name.isNotEmpty) {
                provider.setCustom(
                    name: name,
                    arabic: arabic.isEmpty ? name : arabic,
                    target: target);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditZikarDialog(BuildContext context, TasbeehProvider provider) {
    final isCustom = provider.isCurrentCustom;
    if (!isCustom) {
      // If not custom, show edit target dialog
      _showEditTargetDialog(context, provider);
      return;
    }

    final currentData = provider.currentCustomData;
    final nameCtrl = TextEditingController(text: currentData?['name'] ?? '');
    final arabicCtrl = TextEditingController(text: currentData?['arabic'] ?? '');
    final targetCtrl = TextEditingController(text: '${currentData?['target'] ?? 33}');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.emeraldMid,
        title: const Text('Edit Custom Tasbeeh', style: AppTextStyles.titleLarge),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: arabicCtrl,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(labelText: 'Arabic text'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: targetCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Target count'),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final oldName = currentData?['name'] ?? '';
              final newName = nameCtrl.text.trim();
              final newArabic = arabicCtrl.text.trim();
              final newTarget = int.tryParse(targetCtrl.text) ?? 33;
              if (newName.isNotEmpty && oldName.isNotEmpty) {
                provider.editCustomZikar(
                  oldName: oldName,
                  newName: newName,
                  newArabic: newArabic.isEmpty ? newName : newArabic,
                  newTarget: newTarget,
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showEditTargetDialog(BuildContext context, TasbeehProvider provider) {
    final targetCtrl = TextEditingController(text: '${provider.activeTarget}');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.emeraldMid,
        title: const Text('Edit Target', style: AppTextStyles.titleLarge),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: targetCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target count',
              hintText: 'Enter new target',
            ),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final target = int.tryParse(targetCtrl.text);
              if (target != null && target > 0) {
                provider.updateTarget(target);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, TasbeehProvider provider, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.emeraldMid,
        title: const Text('Delete Zikar', style: AppTextStyles.titleLarge),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteCustomZikar(name);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Circular Counter Button ───────────────────────────────────
class _CircularCounter extends StatelessWidget {
  final int count;
  final int target;
  final double progress;
  final bool isCompleted;
  final VoidCallback onTap;

  const _CircularCounter({
    required this.count,
    required this.target,
    required this.progress,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emeraldMid,
                border: Border.all(color: AppColors.cardBorder, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
            // Circular progress indicator
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: AppColors.emeraldLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? AppColors.goldLight : AppColors.gold,
                ),
              ),
            ),
            // Counter text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    color:
                        isCompleted ? AppColors.gold : AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                Text(
                  'TAP',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 4,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Preset Selector Chips ─────────────────────────────────────
class _PresetSelector extends StatelessWidget {
  final List<Map<String, dynamic>> presets;
  final String activeName;
  final void Function(Map<String, dynamic>) onSelect;
  final VoidCallback onCustom;
  final VoidCallback onEdit;
  final void Function(String) onDelete;

  const _PresetSelector({
    required this.presets,
    required this.activeName,
    required this.onSelect,
    required this.onCustom,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...presets.map((p) {
                final isActive = p['name'] == activeName;
                final isCustom = p['isCustom'] == true;
                return GestureDetector(
                  onTap: () => onSelect(p),
                  onLongPress: isCustom ? () => _showCustomOptions(context, p['name'], onEdit, onDelete) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.gold : AppColors.emeraldMid,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? AppColors.gold : isCustom ? AppColors.emeraldAccent : AppColors.cardBorder,
                      ),
                    ),
                    child: Text(
                      p['name'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? AppColors.emeraldDark
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }),
              // Custom chip
              GestureDetector(
                onTap: onCustom,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldMid,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: AppColors.emeraldAccent, width: 1.5),
                  ),
                  child: const Row(children: [
                    Icon(Icons.add, size: 14, color: AppColors.emeraldAccent),
                    SizedBox(width: 4),
                    Text('Custom',
                        style: TextStyle(
                            color: AppColors.emeraldAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit Tasbeeh', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCustomOptions(BuildContext context, String name, VoidCallback onEdit, void Function(String) onDelete) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.emeraldMid,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: AppColors.gold),
            title: const Text('Edit Tasbeeh'),
            onTap: () {
              Navigator.pop(ctx);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(ctx);
              onDelete(name);
            },
          ),
        ],
      ),
    );
  }
}

// ── Session History Tile ──────────────────────────────────────
class _SessionTile extends StatelessWidget {
  final String name;
  final String arabic;
  final int count;
  final int target;
  final bool isCompleted;

  const _SessionTile({
    required this.name,
    required this.arabic,
    required this.count,
    required this.target,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.emeraldMid,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.pending,
          color: isCompleted ? AppColors.gold : AppColors.textMuted,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTextStyles.bodyLarge),
            Text(arabic,
                style:
                    AppTextStyles.arabicMedium.copyWith(fontSize: 14)),
          ]),
        ),
        Text('$count / $target',
            style: AppTextStyles.titleMedium.copyWith(
                color: isCompleted ? AppColors.gold : AppColors.textSecondary)),
      ]),
    );
  }
}
