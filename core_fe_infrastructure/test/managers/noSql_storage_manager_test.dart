import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/managers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/providers_mocks.dart';
import '../mocks/utils.dart';

MockINoSqlStorageProvider _mockINoSqlStorageProvider =
    MockINoSqlStorageProvider();
MockIDateTimeWrapper _mockDateTimeWrapper = MockIDateTimeWrapper();
void main() async {
  var _noSqlStorageManager =
      NoSqlStorageManager(_mockINoSqlStorageProvider, _mockDateTimeWrapper);
  final nowDate = DateTime.now();
  final beforeNowDate = nowDate.subtract(Duration(seconds: 1));
  final tomorrowDate = DateTime.now().add(Duration(days: 1));

  tearDown(_noSqlStorageManager.deleteAll);

  test('validate dependencies', () async {
    expect(() => NoSqlStorageManager(null, _mockDateTimeWrapper),
        throwsAssertionError);
    expect(() => NoSqlStorageManager(_mockINoSqlStorageProvider, null),
        throwsAssertionError);
    expect(() => NoSqlStorageManager(null, null), throwsAssertionError);
  });

  group('adding records', () {
    test('validate key', () async {
      await _noSqlStorageManager.addOrUpdate(key: '', data: '');
      await _noSqlStorageManager.addOrUpdate(key: ' ', data: '');
      await _noSqlStorageManager.addOrUpdate(key: null, data: '');
      verifyNever(_mockINoSqlStorageProvider.add(any));
      verifyNever(_mockINoSqlStorageProvider.update(any));
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
      when(_mockINoSqlStorageProvider.get<String>(any)).thenAnswer((_) => null);
      await _noSqlStorageManager.addOrUpdate(
        key: record.key,
        data: record.data,
        expiryDate: record.expiryDate,
      );
      verify(_mockINoSqlStorageProvider.add(record, shared: false));
      await _noSqlStorageManager.addOrUpdate(
          key: record.key,
          data: record.data,
          expiryDate: record.expiryDate,
          shared: true);
      verify(_mockINoSqlStorageProvider.add(record, shared: true));
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
      when(_mockINoSqlStorageProvider.get<String>(newRecord.key, shared: false))
          .thenAnswer((_) => Future.value(oldRecord));
      when(_mockINoSqlStorageProvider.get<String>(newRecord.key, shared: true))
          .thenAnswer((_) => Future.value(oldRecord));
      await _noSqlStorageManager.addOrUpdate(
        key: newRecord.key,
        data: newRecord.data,
        expiryDate: newRecord.expiryDate,
      );
      verify(_mockINoSqlStorageProvider.update(newRecord, shared: false));
      await _noSqlStorageManager.addOrUpdate(
          key: newRecord.key,
          data: newRecord.data,
          expiryDate: newRecord.expiryDate,
          shared: true);
      verify(_mockINoSqlStorageProvider.update(newRecord, shared: true));
    });
  });
  group('get records', () {
    test('retrieve non existing record', () async {
      when(_mockINoSqlStorageProvider.get<String>(any, shared: false))
          .thenAnswer((_) => Future.value(null));
      var data = await _noSqlStorageManager.get<String>('k1');
      verify(_mockINoSqlStorageProvider.get<String>('k1', shared: false));
      var dataShared = await _noSqlStorageManager.get<String>('k1');
      verify(_mockINoSqlStorageProvider.get<String>('k1', shared: true));
      expect(data, null);
      expect(dataShared, null);
    });

    test('retrieve non expired existing record', () async {
      var record = StorageModel<String>(
          key: 'k1',
          data: 'app3',
          createdDate: nowDate,
          updatedDate: nowDate,
          expiryDate: tomorrowDate);

      when(_mockDateTimeWrapper.now()).thenReturn(nowDate);
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: false))
          .thenAnswer((_) => Future.value(record));
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: true))
          .thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: false));

      var dataShared =
          await _noSqlStorageManager.get<String>(record.key, shared: true);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: true));

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
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: false))
          .thenAnswer((_) => Future.value(record));
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: true))
          .thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: false));

      var dataShared =
          await _noSqlStorageManager.get<String>(record.key, shared: true);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: true));

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
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: false))
          .thenAnswer((_) => Future.value(record));
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: true))
          .thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: false));

      var dataShared =
          await _noSqlStorageManager.get<String>(record.key, shared: true);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: true));

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
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: false))
          .thenAnswer((_) => Future.value(record));
      when(_mockINoSqlStorageProvider.get<String>(record.key, shared: true))
          .thenAnswer((_) => Future.value(record));

      var data = await _noSqlStorageManager.get<String>(record.key,
          ignoreExpiry: true);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: false));
      var dataShared = await _noSqlStorageManager.get<String>(record.key,
          ignoreExpiry: true, shared: true);
      verify(_mockINoSqlStorageProvider.get<String>(record.key, shared: true));
      expect(data, record.data);
      expect(dataShared, record.data);
    });
  });

  group('delete records', () {
    test('validate key', () async {
      await _noSqlStorageManager.delete('');
      await _noSqlStorageManager.delete(' ');
      await _noSqlStorageManager.delete(null);
      verifyNever(_mockINoSqlStorageProvider.delete(any));
    });
    test('delete existing record', () async {
      await _noSqlStorageManager.delete('k1');
      verify(_mockINoSqlStorageProvider.delete('k1', shared: false));
      await _noSqlStorageManager.delete('k1', shared: true);
      verify(_mockINoSqlStorageProvider.delete('k1', shared: true));
    });
  });

  group('delete all records', () {
    test('invoke delete all', () async {
      var tags = ['t1', 't2'];
      await _noSqlStorageManager.deleteAll();
      verify(_mockINoSqlStorageProvider.deleteAll());
      await _noSqlStorageManager.deleteAll(tags: tags);
      verify(_mockINoSqlStorageProvider.deleteAll(tags: tags, shared: false));
      await _noSqlStorageManager.deleteAll(tags: tags, shared: true);
      verify(_mockINoSqlStorageProvider.deleteAll(tags: tags, shared: true));
    });
  });
}
