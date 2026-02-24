// ============================================================
// app_scaffold.dart
// Root scaffold with bottom navigation bar.
// Manages: 5-tab navigation (Home, Streak, Tasbeeh, Content, More).
// "More" menu opens remaining feature screens.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:islamic_companion/core/theme/app_theme.dart';
import 'package:islamic_companion/features/home/presentation/screens/home_screen.dart';
import 'package:islamic_companion/features/namaz_streak/presentation/screens/namaz_streak_screen.dart';
import 'package:islamic_companion/features/tasbeeh/presentation/screens/tasbeeh_screen.dart';
import 'package:islamic_companion/features/daily_content/presentation/screens/daily_content_screen.dart';
import 'package:islamic_companion/features/prayer/presentation/screens/prayer_times_screen.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    PrayerTimesScreen(),
    NamazStreakScreen(),
    TasbeehScreen(),
    DailyContentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DeveloperWatermark(),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.emeraldDark,
            selectedItemColor: AppColors.gold,
            unselectedItemColor: AppColors.textMuted,
            selectedFontSize: 11,
            unselectedFontSize: 10,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.access_time_rounded), label: 'Prayer'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department), label: 'Streak'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.touch_app_rounded), label: 'Tasbeeh'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.book_rounded), label: 'Content'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeveloperWatermark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeveloperInfo(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: AppColors.emeraldDark.withOpacity(0.95),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code, size: 12, color: AppColors.textMuted),
            SizedBox(width: 4),
            Text(
              'Developed by CODEWITHSAJJAD',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeveloperInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.emeraldMid,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CODEWITHSAJJAD',
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Islamic Companion App',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  icon: Icons.link,
                  label: 'GitHub',
                  url: 'https://www.github.com/CODEWITHSAJJAD',
                ),
                const SizedBox(width: 16),
                _SocialButton(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  url: 'https://www.instagram.com/suq00n_',
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      Uri uri = Uri.parse(url);
      
      // For Instagram, try using the app scheme first, then fall back to web
      if (url.contains('instagram.com')) {
        final path = url.split('instagram.com/').last;
        final instagramUri = Uri.parse('instagram://user?username=$path');
        final canLaunchInstagram = await canLaunchUrl(instagramUri);
        if (canLaunchInstagram) {
          await launchUrl(instagramUri, mode: LaunchMode.externalApplication);
          return;
        }
      }
      
      // Fall back to web URL
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Cannot launch URL: $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
