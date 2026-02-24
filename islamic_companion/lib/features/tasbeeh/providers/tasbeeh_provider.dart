// ============================================================
// tasbeeh_provider.dart
// ChangeNotifier for Tasbeeh counter feature.
// Manages: active session, count, vibration, sound, presets,
// session history. All logic isolated from UI.
// ============================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/core/utils/date_extensions.dart';
import 'package:islamic_companion/features/tasbeeh/domain/entities/tasbeeh_entity.dart';
import 'package:islamic_companion/features/tasbeeh/domain/repositories/tasbeeh_repository.dart';

class TasbeehProvider extends ChangeNotifier {
  final TasbeehRepository _repository;
  SharedPreferences? _prefs;

  TasbeehProvider({required TasbeehRepository repository})
      : _repository = repository;

  // ── Active session state ──────────────────────────────────
  TasbeehEntity? _activeSession;
  String _activeName = 'SubhanAllah';
  String _activeArabic = 'سُبْحَانَ اللهِ';
  int _activeTarget = 33;
  int _currentCount = 0;
  bool _vibrationEnabled = true;
  bool _soundEnabled = false;
  List<TasbeehEntity> _todaySessions = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> _customZikars = [];

  // ── Getters ───────────────────────────────────────────────
  TasbeehEntity? get activeSession => _activeSession;
  String get activeName => _activeName;
  String get activeArabic => _activeArabic;
  int get activeTarget => _activeTarget;
  int get currentCount => _currentCount;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get soundEnabled => _soundEnabled;
  List<TasbeehEntity> get todaySessions => _todaySessions;
  bool get isLoading => _isLoading;
  bool get isCompleted => _currentCount >= _activeTarget;
  double get progress =>
      _activeTarget > 0 ? (_currentCount / _activeTarget).clamp(0.0, 1.0) : 0;
  List<Map<String, dynamic>> get customZikars => _customZikars;

  List<Map<String, dynamic>> get allPresets {
    final customList = _customZikars.map((z) => {
      'name': z['name'],
      'arabic': z['arabic'],
      'target': z['target'],
      'isCustom': true,
    }).toList();
    return [...customList, ...AppConstants.tasbeehPresets];
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadCustomZikars();
    await _loadActiveState();
  }

  Future<void> _loadCustomZikars() async {
    final String? zikarsJson = _prefs?.getString('custom_zikars');
    if (zikarsJson != null) {
      final List<dynamic> decoded = jsonDecode(zikarsJson);
      _customZikars = decoded.cast<Map<String, dynamic>>();
    }
  }

  Future<void> _saveCustomZikars() async {
    final String zikarsJson = jsonEncode(_customZikars);
    await _prefs?.setString('custom_zikars', zikarsJson);
  }

  Future<void> _loadActiveState() async {
    final String? activeName = _prefs?.getString('active_zikar_name');
    if (activeName != null) {
      _activeName = activeName;
      _activeArabic = _prefs?.getString('active_zikar_arabic') ?? _activeName;
      _activeTarget = _prefs?.getInt('active_zikar_target') ?? 33;
      _currentCount = _prefs?.getInt('active_zikar_count') ?? 0;
      
      final bool isCustom = _prefs?.getBool('active_zikar_is_custom') ?? false;
      if (isCustom) {
        final customZikar = _customZikars.where((z) => z['name'] == _activeName).firstOrNull;
        if (customZikar != null) {
          _activeArabic = customZikar['arabic'];
          _activeTarget = customZikar['target'];
        }
      }
    }
  }

  Future<void> _saveActiveState() async {
    await _prefs?.setString('active_zikar_name', _activeName);
    await _prefs?.setString('active_zikar_arabic', _activeArabic);
    await _prefs?.setInt('active_zikar_target', _activeTarget);
    await _prefs?.setInt('active_zikar_count', _currentCount);
    
    final isCustom = _customZikars.any((z) => z['name'] == _activeName);
    await _prefs?.setBool('active_zikar_is_custom', isCustom);
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    
    await _initPrefs();
    
    final dateKey = DateTime.now().toHiveKey();
    _todaySessions = await _repository.getByDate(dateKey);
    _isLoading = false;
    notifyListeners();
  }

  /// Main counter tap — increments count, triggers feedback
  Future<void> tap() async {
    if (_currentCount >= _activeTarget) return;
    _currentCount++;

    // Haptic/vibration feedback
    if (_vibrationEnabled) {
      final canVibrate = await Vibration.hasVibrator() ?? false;
      if (canVibrate) {
        Vibration.vibrate(duration: 30, amplitude: 64);
      } else {
        HapticFeedback.lightImpact();
      }
    }

    await _saveActiveState();

    // On completion, auto-save session
    if (_currentCount >= _activeTarget) {
      await _saveCurrentSession(isCompleted: true);
      await loadAll();
    }

    notifyListeners();
  }

  /// Reset counter for the current preset
  void reset() {
    _currentCount = 0;
    _activeSession = null;
    _saveActiveState();
    notifyListeners();
  }

  /// Select a built-in preset
  void selectPreset(Map<String, dynamic> preset) {
    _activeName = preset['name'] as String;
    _activeArabic = preset['arabic'] as String;
    _activeTarget = preset['target'] as int;
    _currentCount = 0;
    _activeSession = null;
    _saveActiveState();
    notifyListeners();
  }

  /// Create a custom tasbeeh
  Future<void> setCustom({
    required String name,
    required String arabic,
    required int target,
  }) async {
    final existingIndex = _customZikars.indexWhere((z) => z['name'] == name);
    if (existingIndex >= 0) {
      _customZikars[existingIndex] = {
        'name': name,
        'arabic': arabic,
        'target': target,
      };
    } else {
      _customZikars.insert(0, {
        'name': name,
        'arabic': arabic,
        'target': target,
      });
    }
    await _saveCustomZikars();
    
    _activeName = name;
    _activeArabic = arabic.isEmpty ? name : arabic;
    _activeTarget = target;
    _currentCount = 0;
    _activeSession = null;
    await _saveActiveState();
    notifyListeners();
  }

  /// Update target for current zikar
  Future<void> updateTarget(int newTarget) async {
    _activeTarget = newTarget;
    await _saveActiveState();
    
    // Check if it's a custom zikar and update it
    final customIndex = _customZikars.indexWhere((z) => z['name'] == _activeName);
    if (customIndex >= 0) {
      _customZikars[customIndex]['target'] = newTarget;
      await _saveCustomZikars();
    }
    
    notifyListeners();
  }

  /// Delete a custom zikar
  Future<void> deleteCustomZikar(String name) async {
    _customZikars.removeWhere((z) => z['name'] == name);
    await _saveCustomZikars();
    
    // If deleted zikar was active, reset to default
    if (_activeName == name) {
      _activeName = 'SubhanAllah';
      _activeArabic = 'سُبْحَانَ اللهِ';
      _activeTarget = 33;
      _currentCount = 0;
      await _saveActiveState();
    }
    notifyListeners();
  }

  /// Edit a custom zikar (name, arabic, target)
  Future<void> editCustomZikar({
    required String oldName,
    required String newName,
    required String newArabic,
    required int newTarget,
  }) async {
    final index = _customZikars.indexWhere((z) => z['name'] == oldName);
    if (index >= 0) {
      _customZikars[index] = {
        'name': newName,
        'arabic': newArabic,
        'target': newTarget,
      };
      await _saveCustomZikars();
      
      // If this is the active zikar, update it too
      if (_activeName == oldName) {
        _activeName = newName;
        _activeArabic = newArabic.isEmpty ? newName : newArabic;
        _activeTarget = newTarget;
        await _saveActiveState();
      }
      notifyListeners();
    }
  }

  /// Check if current active zikar is custom
  bool get isCurrentCustom {
    return _customZikars.any((z) => z['name'] == _activeName);
  }

  /// Get current custom zikar data
  Map<String, dynamic>? get currentCustomData {
    return _customZikars.where((z) => z['name'] == _activeName).firstOrNull;
  }

  void toggleVibration() {
    _vibrationEnabled = !_vibrationEnabled;
    notifyListeners();
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  Future<void> _saveCurrentSession({bool isCompleted = false}) async {
    final now = DateTime.now();
    final entity = TasbeehEntity(
      id: '${_activeName}_${now.millisecondsSinceEpoch}',
      name: _activeName,
      arabic: _activeArabic,
      targetCount: _activeTarget,
      currentCount: _currentCount,
      dateKey: now.toHiveKey(),
      isCompleted: isCompleted,
    );
    await _repository.save(entity);
  }

  List<Map<String, dynamic>> get presets => allPresets;
}
