import 'dart:async';
import 'dart:io';
import 'package:core_fe_infrastructure/src/interfaces/no_sql_storage.dart';
import 'package:core_fe_infrastructure/src/models/storage_model.dart';
import 'package:core_fe_infrastructure/src/utils/permission_handler.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:core_fe_dart/extensions.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:core_fe_flutter/models.dart';
import 'package:core_fe_infrastructure/utils.dart';

class SembastStorageProviderImpl extends NoSqlStorageProvider {
  final bool _isInMemoryDb;
  final String _dbPath;
  final SembastCodec? _codec;
  final int? _version;
  final OnVersionChangedFunction? _onVersionChanged;
  SembastStorageProviderImpl(String dbPath,
      {SembastCodec? codec, int? version, OnVersionChangedFunction? onVersionChanged, bool isInMemoryDb = false})
      : assert(!dbPath.isNullEmptyOrWhitespace()),
        _dbPath = dbPath,
        _codec = codec,
        _version = version,
        _isInMemoryDb = isInMemoryDb,
        _onVersionChanged = onVersionChanged;

  Future<Database> get _db => _databaseInstance();
  final _store = StoreRef.main();

  @override
  Future<void> add<T>(StorageModel<T> object, {ToJsonFunc<T>? toJsonFunc, bool shared = false}) async {
    await _store.record(object.key).add(await _db, object.toJson(toJsonFunc ?? JsonUtil.getType<T>().toJson));
  }

  @override
  Future<void> delete(String? key, {shared = false}) async {
    return _store.record(key).delete(await _db);
  }

  @override
  Future<void> deleteAll({List<String>? tags, shared = false}) async {
    if (tags == null || tags.isNullEmptyOrWhitespace()) {
      return _store.drop(await _db);
    } else {
      var keys = await findAllKeys(tags: tags);
      await _store.delete(
        await _db,
        finder: Finder(
          filter: Filter.inList(Field.key, keys!),
        ),
      );
    }
  }

  @override
  Future<List<String>?> findAllKeys({List<String>? tags}) async {
    var finder = tags.isNullEmptyOrWhitespace() ? null : Finder(filter: Filter.custom((r) => _filterByTags(r, tags!)));
    var result = await _store.findKeys(await _db, finder: finder);
    return result.cast<String>();
  }

  bool _filterByTags(RecordSnapshot record, List<String> tags) {
    var recordTags = StorageModel.fromJsonWithoutData(record.value).tags!;
    var intersectionList = recordTags.intersection(tags) as Iterable<String>;
    return intersectionList.isNotEmpty;
  }

  @override
  Future<StorageModel<T>?> get<T>(
    String? key, {
    FromJsonFunc<T>? fromJsonFunc,
    bool shared = false,
  }) async {
    var record = await _store.record(key).get(
          await _db,
        ) as Map<String, dynamic>?;
    if (record == null) return null;
    return StorageModel.fromJson(record, fromJsonFunc ?? JsonUtil.getType<T>().fromJson);
  }

  @override
  Future<void> update<T>(StorageModel<T> object, {ToJsonFunc<T>? toJsonFunc, bool shared = false}) async {
    toJsonFunc ??= JsonUtil.getType<T>().toJson;
    await _store.record(object.key).put(await _db, object.toJson(toJsonFunc));
  }

  // Completer is used for transforming synchronous code into asynchronous code.
  static final Map<String, Completer<Database>> _dbOpenCompleterMap = {};

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  // Database object accessor
  Future<Database> _databaseInstance() async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    var dbExists = await Directory(_dbPath).exists();
    if (_dbOpenCompleterMap[_dbPath] == null || !dbExists) {
      _dbOpenCompleterMap[_dbPath] = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      await _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleterMap[_dbPath]!.future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    // final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    // final dbPath = join(appDocumentDir.path, dbName);
    if (!_isInMemoryDb && !await PermissionsHandler.isStorageGranted()) {
      return;
    }
    var factory = _isInMemoryDb ? databaseFactoryMemory : databaseFactoryIo;
    final database =
        await factory.openDatabase(_dbPath, version: _version, codec: _codec, onVersionChanged: _onVersionChanged);
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleterMap[_dbPath]!.complete(database);
  }
}
