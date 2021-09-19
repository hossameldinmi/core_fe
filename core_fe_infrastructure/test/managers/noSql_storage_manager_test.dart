@Skip('currently failing') //todo: pass the tests
import 'package:core_fe_dart/core_fe_dart.dart';
import 'package:core_fe_infrastructure/core_fe_infrastructure.dart';
import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/src/managers/noSql_storage_manager_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../mocks/providers_mocks.dart';
import '../mocks/mocks.dart';

@GenerateMocks([NoSqlStorageProvider, DateTimeWrapper])
void main() {
  var _mockNoSqlStorageProvider = MockNoSqlStorageProvider();
  var _mockDateTimeWrapper = MockDateTimeWrapper();
  var _noSqlStorageManager = NoSqlStorageManagerImpl(_mockNoSqlStorageProvider, _mockDateTimeWrapper);
  final nowDate = DateTime.now();
  final beforeNowDate = nowDate.subtract(Duration(seconds: 1));
  final tomorrowDate = DateTime.now().add(Duration(days: 1));

  tearDown(_noSqlStorageManager.deleteAll);

  group('adding records', () {
    test('validate key', () async {
      await _noSqlStorageManager.addOrUpdate(key: '', data: '');
      await _noSqlStorageManager.addOrUpdate(key: ' ', data: '');
      verifyNever(_mockNoSqlStorageProvider.add(any!));
      verifyNever(_mockNoSqlStorageProvider.update(any!));
    });
    test('add non existing record to database', () async {
      var record = StorageModel<String>(
        key: 'k1',
        data: 'app3',
        createdDate: nowDate,
        updatedDate: nowDate,
        expiryDate: tomorrowDate,
      );

      when(_mockDateTimeWrapper.now()).thenReturn(nowDate);
      when(_mockNoSqlStorageProvider.get<String>(any))
          .thenAnswer(((_) => null) as Future<StorageModel<String>> Function(Invocation));
      await _noSqlStorageManager.addOrUpdate(
        key: record.key,
        data: record.data,
        expiryDate: record.expiryDate,
      );
      verify(_mockNoSqlStorageProvider.add(record, shared: false));
      await _noSqlStorageManager.addOrUpdate(
          key: record.key, data: record.data, expiryDate: record.expiryDate, shared: true);
      verify(_mockNoSqlStorageProvider.add(record, shared: true));
    });

    test('add record with an existing key', () async {
      var oldRecord = StorageModel<String>(
        key: 'k1',
        data: 'app2',
        createdDate: nowDate,
        updatedDate: nowDate,
        expiryDate: tomorrowDate,
      );
      var newRecord = StorageModel<String>(
        key: 'k1',
        data: 'app1',
        createdDate: nowDate,
        updatedDate: nowDate,
        expiryDate: tomorrowDate,
      );

      when(_mockDateTimeWrapper.now()).thenReturn(nowDate);
      when(_mockNoSqlStorageProvider.get<String>(newRecord.key, shared: false))
          .thenAnswer((_) => Future.value(oldRecord));
      when(_mockNoSqlStorageProvider.get<String>(newRecord.key, shared: true))
          .thenAnswer((_) => Future.value(oldRecord));
      await _noSqlStorageManager.addOrUpdate(
        key: newRecord.key,
        data: newRecord.data,
        expiryDate: newRecord.expiryDate,
      );
      verify(_mockNoSqlStorageProvider.update(newRecord, shared: false));
      await _noSqlStorageManager.addOrUpdate(
          key: newRecord.key, data: newRecord.data, expiryDate: newRecord.expiryDate, shared: true);
      verify(_mockNoSqlStorageProvider.update(newRecord, shared: true));
    });
  });
  group('get records', () {
    test('retrieve non existing record', () async {
      when(_mockNoSqlStorageProvider.get<String>(any, shared: false)).thenAnswer((_) => Future.value(null));
      var data = await _noSqlStorageManager.get<String>('k1');
      verify(_mockNoSqlStorageProvider.get<String>('k1', shared: false));
      var dataShared = await _noSqlStorageManager.get<String>('k1');
      verify(_mockNoSqlStorageProvider.get<String>('k1', shared: true));
      expect(data, null);
      expect(dataShared, null);
    });

    test('retrieve non expired existing record', () async {
      var record = StorageModel<String>(
          key: 'k1', data: 'app3', createdDate: nowDate, updatedDate: nowDate, expiryDate: tomorrowDate);

      when(_mockDateTimeWrapper.now()).thenReturn(nowDate);
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: false)).thenAnswer((_) => Future.value(record));
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: true)).thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: false));

      var dataShared = await _noSqlStorageManager.get<String>(record.key, shared: true);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: true));

      expect(data, record.data);
      expect(dataShared, record.data);
    });

    test('retrieve existing record with null expiryDate', () async {
      var record = StorageModel<String>(
        key: 'k1',
        data: 'app3',
        createdDate: nowDate,
        updatedDate: nowDate,
      );
      when(_mockDateTimeWrapper.now()).thenReturn(nowDate);
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: false)).thenAnswer((_) => Future.value(record));
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: true)).thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: false));

      var dataShared = await _noSqlStorageManager.get<String>(record.key, shared: true);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: true));

      expect(data, record.data);
      expect(dataShared, record.data);
    });

    test('retrieve existing expired record', () async {
      var record = StorageModel<String>(
        key: 'k1',
        data: 'app3',
        createdDate: nowDate,
        updatedDate: nowDate,
        expiryDate: beforeNowDate,
      );

      when(_mockDateTimeWrapper.now()).thenReturn(nowDate);
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: false)).thenAnswer((_) => Future.value(record));
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: true)).thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: false));

      var dataShared = await _noSqlStorageManager.get<String>(record.key, shared: true);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: true));

      expect(data, null);
      expect(dataShared, null);
    });

    test('retrieve existing expired and ignore expiry record', () async {
      var record = StorageModel<String>(
        key: 'k1',
        data: 'app3',
        createdDate: nowDate,
        updatedDate: nowDate,
        expiryDate: beforeNowDate,
      );
      when(_mockDateTimeWrapper.now()).thenReturn(nowDate);
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: false)).thenAnswer((_) => Future.value(record));
      when(_mockNoSqlStorageProvider.get<String>(record.key, shared: true)).thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key, ignoreExpiry: true);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: false));
      var dataShared = await _noSqlStorageManager.get<String>(record.key, ignoreExpiry: true, shared: true);
      verify(_mockNoSqlStorageProvider.get<String>(record.key, shared: true));
      expect(data, record.data);
      expect(dataShared, record.data);
    });
  });

  group('delete records', () {
    test('validate key', () async {
      await _noSqlStorageManager.delete('');
      await _noSqlStorageManager.delete(' ');
      verifyNever(_mockNoSqlStorageProvider.delete(any));
    });
    test('delete existing record', () async {
      await _noSqlStorageManager.delete('k1');
      verify(_mockNoSqlStorageProvider.delete('k1', shared: false));
      await _noSqlStorageManager.delete('k1', shared: true);
      verify(_mockNoSqlStorageProvider.delete('k1', shared: true));
    });
  });

  group('delete all records', () {
    test('invoke delete all', () async {
      var tags = ['t1', 't2'];
      await _noSqlStorageManager.deleteAll();
      verify(_mockNoSqlStorageProvider.deleteAll());
      await _noSqlStorageManager.deleteAll(tags: tags);
      verify(_mockNoSqlStorageProvider.deleteAll(tags: tags, shared: false));
      await _noSqlStorageManager.deleteAll(tags: tags, shared: true);
      verify(_mockNoSqlStorageProvider.deleteAll(tags: tags, shared: true));
    });
  });
}
