import 'package:core_fe_infrastructure/src/models/storage_model.dart';
import 'package:meta/meta.dart';

abstract class INoSqlStorageManager {
  Future<T> get<T>(String key,
      {bool shared = false, bool ignoreExpiry = false});
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

abstract class INoSqlStorageProvider {
  Future<void> add<T>(StorageModel<T> data);
  Future<void> update<T>(StorageModel<T> data);
  Future<void> delete(String key);
  Future<void> deleteAll({List<String> tags});
  Future<StorageModel<T>> get<T>(String key, {bool shared = false});
  Future<List<String>> findAllKeys({List<String> tags});
}
