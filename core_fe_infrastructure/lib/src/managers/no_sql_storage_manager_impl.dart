import 'package:core_fe_infrastructure/src/interfaces/no_sql_storage.dart';
import 'package:core_fe_infrastructure/src/models/storage_model.dart';
import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_dart/extensions.dart';
import 'package:core_fe_flutter/models.dart';

class NoSqlStorageManagerImpl implements NoSqlStorageManager {
  final NoSqlStorageProvider _storageProvider;
  final DateTimeWrapper _dateTime;
  NoSqlStorageManagerImpl(NoSqlStorageProvider storageProvider, DateTimeWrapper dateTime)
      : _storageProvider = storageProvider,
        _dateTime = dateTime;
  @override
  Future<void> addOrUpdate<T>(
      {required String key,
      T? data,
      List<String>? tags,
      DateTime? expiryDate,
      ToJsonFunc<T>? toJsonFunc,
      bool shared = false}) async {
    if (key.isNullEmptyOrWhitespace()) {
      return;
    }
    var existingRecord = await _storageProvider.get<T>(key, shared: shared);
    if (existingRecord != null) {
      var storageModel = StorageModel<T?>(
          key: key,
          data: data,
          createdDate: existingRecord.createdDate,
          updatedDate: _dateTime.now(),
          expiryDate: expiryDate,
          tags: tags);
      return _storageProvider.update(storageModel, shared: shared);
    } else {
      var storageModel = StorageModel<T>(
          key: key,
          data: data!,
          createdDate: _dateTime.now(),
          updatedDate: _dateTime.now(),
          expiryDate: expiryDate,
          tags: tags);
      return _storageProvider.add(storageModel, shared: shared, toJsonFunc: toJsonFunc);
    }
  }

  @override
  Future<void> delete(String key, {bool shared = false}) {
    if (key.isNullEmptyOrWhitespace()) {
      return Future.value();
    }
    return _storageProvider.delete(key, shared: shared);
  }

  @override
  Future<void> deleteAll({List<String>? tags, bool shared = false}) {
    return _storageProvider.deleteAll(tags: tags, shared: shared);
  }

  @override
  Future<T> get<T>(String? key, {FromJsonFunc<T>? fromJsonFunc, bool shared = false, bool ignoreExpiry = false}) async {
    var record = await _storageProvider.get<T>(key, shared: shared, fromJsonFunc: fromJsonFunc);
    T? result;
    if (record != null && !ignoreExpiry && record.expiryDate != null && record.expiryDate!.isAfter(_dateTime.now())) {
      result = record.data;
    } else if (ignoreExpiry || record?.expiryDate == null) {
      result = record?.data;
    }
    return Future.value(result);
  }
}
