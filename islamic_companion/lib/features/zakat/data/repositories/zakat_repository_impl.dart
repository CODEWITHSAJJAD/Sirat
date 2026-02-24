// ============================================================
// zakat_repository_impl.dart
// Hive-backed Zakat repository.
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/features/zakat/data/models/zakat_record_model.dart';
import 'package:islamic_companion/features/zakat/domain/entities/zakat_entity.dart';
import 'package:islamic_companion/features/zakat/domain/repositories/zakat_repository.dart';

class ZakatRepositoryImpl implements ZakatRepository {
  final Box<ZakatRecordModel> _box;
  ZakatRepositoryImpl(this._box);

  @override
  Future<void> saveRecord(ZakatEntity entity) async {
    await _box.put(entity.id, ZakatRecordModel.fromEntity(entity));
  }

  @override
  Future<List<ZakatEntity>> getAllRecords() async {
    return _box.values
        .map((m) => m.toEntity())
        .toList()
      ..sort((a, b) => b.year.compareTo(a.year));
  }

  @override
  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
  }
}
