// ============================================================
// app_settings_service.dart
// Handles app-wide settings including moon sighting adjustment.
// Persists to SharedPreferences for permanent storage.
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService {
  static const String _moonAdjustmentKey = 'moon_sighting_adjustment';
  
  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get moon sighting adjustment (-1, 0, or +1 days)
  Future<int> getMoonAdjustment() async {
    await _init();
    return _prefs?.getInt(_moonAdjustmentKey) ?? 0;
  }

  /// Set moon sighting adjustment permanently
  Future<void> setMoonAdjustment(int days) async {
    await _init();
    await _prefs?.setInt(_moonAdjustmentKey, days);
  }
}
