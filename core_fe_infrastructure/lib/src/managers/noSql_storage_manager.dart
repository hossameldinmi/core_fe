import 'package:core_fe_infrastructure/src/interfaces/i_noSql_storage.dart';
import 'package:core_fe_infrastructure/src/models/storage_model.dart';
import 'package:core_fe_dart/src/utils/i_date_time_wrapper.dart';
import 'package:core_fe_dart/src/extensions/validation_extensions.dart';

class NoSqlStorageManager implements INoSqlStorageManager {
  final INoSqlStorageProvider _storageProvider;
  final IDateTimeWrapper _dateTime;
  NoSqlStorageManager(
      INoSqlStorageProvider storageProvider, IDateTimeWrapper dateTime)
      : assert(storageProvider != null),
        assert(dateTime != null),
        _storageProvider = storageProvider,
        _dateTime = dateTime;
  @override
  Future<void> addOrUpdate<T>(
      {String key,
      T data,
      List<String> tags,
      DateTime expiryDate,
      bool shared = false}) async {
    if (key.isNullEmptyOrWhitespace()) {
      return;
    }
    var existingRecord = await _storageProvider.get<T>(key, shared: shared);
    if (existingRecord != null) {
      var storageModel = StorageModel<T>(
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
          data: data,
          createdDate: _dateTime.now(),
          updatedDate: _dateTime.now(),
          expiryDate: expiryDate,
          tags: tags);
      return _storageProvider.add(storageModel, shared: shared);
    }
  }

  @override
  Future<void> delete(String key, {bool shared = false}) {
    if (key.isNullEmptyOrWhitespace()) {
      return null;
    }
    return _storageProvider.delete(key, shared: shared);
  }

  @override
  Future<void> deleteAll({List<String> tags, bool shared = false}) {
    return _storageProvider.deleteAll(tags: tags, shared: shared);
  }

  @override
  Future<T> get<T>(String key,
      {bool shared = false, bool ignoreExpiry = false}) async {
    var record = await _storageProvider.get<T>(key, shared: shared);
    T result;
    if (record != null &&
        !ignoreExpiry &&
        record.expiryDate != null &&
        record.expiryDate.isAfter(_dateTime.now())) {
      result = record.data;
    } else if (ignoreExpiry || record?.expiryDate == null) {
      result = record?.data;
    }
    return Future.value(result);
  }
}
