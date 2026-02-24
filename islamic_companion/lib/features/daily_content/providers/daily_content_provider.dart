// ============================================================
// daily_content_provider.dart
// ChangeNotifier for daily Islamic content.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:islamic_companion/features/daily_content/domain/entities/daily_content_entity.dart';
import 'package:islamic_companion/services/daily_content_service.dart';

class DailyContentProvider extends ChangeNotifier {
  final DailyContentService _service;

  DailyContentProvider({required DailyContentService service})
      : _service = service;

  DailyContentEntity? _todayAyah;
  DailyContentEntity? _todayHadith;
  DailyContentEntity? _todayDua;
  List<DailyContentEntity> _allDuas = [];
  DailyContentEntity? _activeTab;

  DailyContentEntity? get todayAyah => _todayAyah;
  DailyContentEntity? get todayHadith => _todayHadith;
  DailyContentEntity? get todayDua => _todayDua;
  List<DailyContentEntity> get allDuas => _allDuas;

  void load() {
    _todayAyah = _service.getTodayAyah();
    _todayHadith = _service.getTodayHadith();
    _todayDua = _service.getTodayDua();
    _allDuas = _service.getAllDuas();
    notifyListeners();
  }
}
