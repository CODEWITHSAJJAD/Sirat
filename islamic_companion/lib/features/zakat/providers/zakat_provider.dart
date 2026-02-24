// ============================================================
// zakat_provider.dart
// ChangeNotifier for Zakat calculator.
// Handles: form inputs, calculation, history, PKR rate inputs.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/zakat/domain/entities/zakat_entity.dart';
import 'package:islamic_companion/features/zakat/domain/repositories/zakat_repository.dart';
import 'package:islamic_companion/services/zakat_calculator_service.dart';

class ZakatProvider extends ChangeNotifier {
  final ZakatRepository _repository;
  final ZakatCalculatorService _calculator;

  ZakatProvider({
    required ZakatRepository repository,
    required ZakatCalculatorService calculator,
  })  : _repository = repository,
        _calculator = calculator;

  // ── Input state ────────────────────────────────────────────
  double cashPKR = 0;
  double goldGrams = 0;
  double silverGrams = 0;
  double businessValuePKR = 0;
  double goldRatePerGram = AppConstants.defaultGoldRatePerGram;
  double silverRatePerGram = AppConstants.defaultSilverRatePerGram;

  // ── Result state ───────────────────────────────────────────
  ZakatEntity? _lastResult;
  List<ZakatEntity> _history = [];
  bool _isLoading = false;

  // ── Getters ───────────────────────────────────────────────
  ZakatEntity? get lastResult => _lastResult;
  List<ZakatEntity> get history => _history;
  bool get isLoading => _isLoading;
  bool get hasResult => _lastResult != null;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    _history = await _repository.getAllRecords();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> calculate() async {
    _isLoading = true;
    notifyListeners();

    _lastResult = _calculator.calculate(
      cashPKR: cashPKR,
      goldGrams: goldGrams,
      silverGrams: silverGrams,
      businessValuePKR: businessValuePKR,
      goldRatePerGram: goldRatePerGram,
      silverRatePerGram: silverRatePerGram,
    );

    await _repository.saveRecord(_lastResult!);
    await loadHistory();
    _isLoading = false;
    notifyListeners();
  }

  void resetInputs() {
    cashPKR = 0;
    goldGrams = 0;
    silverGrams = 0;
    businessValuePKR = 0;
    _lastResult = null;
    notifyListeners();
  }

  Future<void> deleteRecord(String id) async {
    await _repository.deleteRecord(id);
    await loadHistory();
  }
}
