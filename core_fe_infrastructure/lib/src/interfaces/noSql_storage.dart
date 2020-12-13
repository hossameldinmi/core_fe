import 'package:core_fe_infrastructure/src/models/storage_model.dart';
import 'package:meta/meta.dart';

abstract class NoSqlStorageManager {
  Future<T> get<T>(
    String key, {
    bool ignoreExpiry = false,
    bool shared = false,
  });
  Future<void> addOrUpdate<T>({
    @required String key,
    @required T data,
    List<String> tags,
    DateTime expiryDate,
    bool shared = false,
  });
  Future<void> delete(
    String key, {
    bool shared = false,
  });
  Future<void> deleteAll({
    List<String> tags,
    bool shared = false,
  });
}

abstract class NoSqlStorageProvider {
  Future<void> add<T>(
    StorageModel<T> data, {
    bool shared = false,
  });
  Future<void> update<T>(
    StorageModel<T> data, {
    bool shared = false,
  });
  Future<void> delete(
    String key, {
    bool shared = false,
  });
  Future<void> deleteAll({
    List<String> tags,
    bool shared = false,
  });
  Future<StorageModel<T>> get<T>(
    String key, {
    bool shared = false,
  });
  Future<List<String>> findAllKeys({List<String> tags});
}
