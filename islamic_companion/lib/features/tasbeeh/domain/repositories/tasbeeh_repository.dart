// ============================================================
// tasbeeh_repository.dart
// Abstract interface for tasbeeh storage.
// ============================================================

import 'package:islamic_companion/features/tasbeeh/domain/entities/tasbeeh_entity.dart';

abstract class TasbeehRepository {
  Future<void> save(TasbeehEntity tasbeeh);
  Future<List<TasbeehEntity>> getByDate(String dateKey);
  Future<List<TasbeehEntity>> getAll();
  Future<void> delete(String id);
}
