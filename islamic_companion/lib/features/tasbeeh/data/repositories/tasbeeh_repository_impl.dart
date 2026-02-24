// ============================================================
// tasbeeh_repository_impl.dart
// Hive-backed implementation: key = tasbeeh ID string.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/features/tasbeeh/data/models/tasbeeh_model.dart';
import 'package:islamic_companion/features/tasbeeh/domain/entities/tasbeeh_entity.dart';
import 'package:islamic_companion/features/tasbeeh/domain/repositories/tasbeeh_repository.dart';

class TasbeehRepositoryImpl implements TasbeehRepository {
  final Box<TasbeehModel> _box;
  TasbeehRepositoryImpl(this._box);

  @override
  Future<void> save(TasbeehEntity tasbeeh) async {
    await _box.put(tasbeeh.id, TasbeehModel.fromEntity(tasbeeh));
  }

  @override
  Future<List<TasbeehEntity>> getByDate(String dateKey) async {
    return _box.values
        .where((m) => m.dateKey == dateKey)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<TasbeehEntity>> getAll() async {
    return _box.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
