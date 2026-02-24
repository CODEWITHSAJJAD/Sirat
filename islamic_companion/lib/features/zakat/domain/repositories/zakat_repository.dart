// ============================================================
// zakat_repository.dart  (abstract)
// zakat_repository_impl.dart (Hive-backed)
// ============================================================

import 'package:islamic_companion/features/zakat/domain/entities/zakat_entity.dart';

abstract class ZakatRepository {
  Future<void> saveRecord(ZakatEntity entity);
  Future<List<ZakatEntity>> getAllRecords();
  Future<void> deleteRecord(String id);
}
