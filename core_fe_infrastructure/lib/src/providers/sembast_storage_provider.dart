import 'dart:async';
import 'dart:io';
import 'package:core_fe_infrastructure/src/interfaces/i_noSql_storage.dart';
import 'package:core_fe_infrastructure/src/models/storage_model.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:core_fe_dart/src/extensions/_export.dart';
import 'package:sembast/src/api/v2/sembast.dart';
import 'package:core_fe_dart/src/extensions/iterable_extensions.dart';
import 'package:sembast/sembast_memory.dart';

class SembastStorageProvider extends INoSqlStorageProvider {
  final bool _isInMemoryDb;
  final String _dbPath;
  final SembastCodec _codec;
  final int _version;
  final OnVersionChangedFunction _onVersionChanged;
  SembastStorageProvider(String dbPath,
      {SembastCodec codec,
      int version,
      OnVersionChangedFunction onVersionChanged,
      bool isInMemoryDb = false})
      : assert(!dbPath.isNullEmptyOrWhitespace()),
        _dbPath = dbPath,
        _codec = codec,
        _version = version,
        _isInMemoryDb = isInMemoryDb,
        _onVersionChanged = onVersionChanged;

  Future<Database> get _db => _databaseInstance();
  final _store = StoreRef.main();

  @override
  Future<void> add<T>(StorageModel<T> object) async {
    await _store.record(object.key).add(await _db, object.toJson());
  }

  @override
  Future<void> delete(String key) async {
    return _store.record(key).delete(await _db);
  }

  @override
  Future<void> deleteAll({List<String> tags}) async {
    if (tags.isNullEmptyOrWhitespace()) {
      return _store.drop(await _db);
    } else {
      var keys = await findAllKeys(tags: tags);
      return await _store.delete(
        await _db,
        finder: Finder(
          filter: Filter.inList(Field.key, keys),
        ),
      );
    }
  }

  @override
  Future<List<String>> findAllKeys({List<String> tags}) async {
    var finder = tags.isNullEmptyOrWhitespace()
        ? null
        : Finder(filter: Filter.custom((r) => _filterByTags(r, tags)));
    var result = await _store.findKeys(await _db, finder: finder);
    return result.cast<String>();
  }

  bool _filterByTags(RecordSnapshot record, List<String> tags) {
    var recordTags = StorageModel.fromJson(record.value).tags;
    var intersectionList = recordTags.intersection(tags);
    return intersectionList.isNotEmpty;
  }

  @override
  Future<StorageModel<T>> get<T>(
    String key, {
    bool shared = false,
  }) async {
    var record = await _store.record(key).get(
          await _db,
        ) as Map;

    return StorageModel.fromJson(record);
  }

  @override
  Future<void> update<T>(StorageModel<T> object) async {
    await _store.record(object.key).put(await _db, object.toJson());
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
    return _dbOpenCompleterMap[_dbPath].future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    // final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    // final dbPath = join(appDocumentDir.path, dbName);
    var factory = _isInMemoryDb ? databaseFactoryMemory : databaseFactoryIo;
    final database = await factory.openDatabase(_dbPath,
        version: _version, codec: _codec, onVersionChanged: _onVersionChanged);
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleterMap[_dbPath].complete(database);
  }
}
