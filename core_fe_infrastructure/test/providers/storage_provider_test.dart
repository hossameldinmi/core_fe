import 'package:core_fe_infrastructure/src/interfaces/i_noSql_storage.dart';
import 'package:core_fe_infrastructure/src/models/storage_model.dart';
import 'package:core_fe_infrastructure/src/providers/sembast_storage_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_flutter/src/utils/base_factory.dart';
import '../core_fe_infrastructure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseFactory.init(CoreFeInfrastructureTest());
  INoSqlStorageProvider getInstance(String dbPath) {
    return SembastStorageProvider(dbPath, isInMemoryDb: true);
  }

  var _iNoSqlStorageProvider = getInstance('App1');
  final createdDate = DateTime.now();
  final updatedDate = DateTime.now();
  final expiryDate = DateTime.now();

  tearDown(_iNoSqlStorageProvider.deleteAll);

  StorageModel<T> createInstance<T>(
      {@required String key, T data, List<String> tags}) {
    return StorageModel<T>(
        key: key,
        data: data,
        tags: tags,
        expiryDate: expiryDate,
        createdDate: createdDate,
        updatedDate: updatedDate);
  }

  group('db checks', () {
    test('test dbNames databases', () async {
      var _iNoSqlStorageProvider2 = getInstance('App2');
      await _iNoSqlStorageProvider.add(createInstance<String>(
        key: 'k1',
        data: 'app1',
      ));

      await _iNoSqlStorageProvider2.add(createInstance<String>(
        key: 'k1',
        data: 'app2',
      ));

      var r1 = await _iNoSqlStorageProvider.get<String>('k1');
      var r2 = await _iNoSqlStorageProvider2.get<String>('k1');

      expect(r1, isNot(equals(r2)));
      await _iNoSqlStorageProvider2.deleteAll();
    });

    test('validate dbPath', () async {
      expect(() => SembastStorageProvider(''), throwsAssertionError);
    });
  });
  group('adding records', () {
    test('add record to database', () async {
      var record = createInstance<String>(key: 'k1', data: 'app3');

      await _iNoSqlStorageProvider.add(record);

      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      expect(actualRecord, record);
    });

    test('add multiple records to database', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app1',
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app2',
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);

      var actualRecord1 = await _iNoSqlStorageProvider.get<String>('k1');
      var actualRecord2 = await _iNoSqlStorageProvider.get<String>('k2');

      expect(actualRecord1, record);
      expect(actualRecord2, record2);
    });

    test('add record with existing key => Not Add', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app1',
      );

      var record2 = createInstance<String>(
        key: 'k1',
        data: 'app2',
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);

      var actualRecord1 = await _iNoSqlStorageProvider.get<String>('k1');

      expect(actualRecord1, record);
      expect(actualRecord1, isNot(equals(record2)));
    });
  });
  group('get records', () {
    test('retrieve added record', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
      );

      await _iNoSqlStorageProvider.add(record);

      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      expect(actualRecord, record);
    });

    test('retrieve non existing record', () async {
      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      expect(actualRecord, null);
    });
  });

  group('find records key', () {
    test('find existing keys', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);

      var keys = await _iNoSqlStorageProvider.findAllKeys();
      expect(keys, ['k1', 'k2']);
    });

    test('find existing keys by tag', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);

      var keys = await _iNoSqlStorageProvider.findAllKeys(tags: ['t1']);
      expect(keys, equals(['k1']));
    });

    test('find many existing keys by tag', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
        tags: ['t1', 't2'],
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);

      var keys = await _iNoSqlStorageProvider.findAllKeys(tags: ['t1']);
      expect(keys, equals(['k1', 'k2']));
    });

    test('find non existing keys by tag', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
        tags: ['t1', 't2'],
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);

      var keys = await _iNoSqlStorageProvider.findAllKeys(tags: ['t3']);
      expect(keys, isEmpty);
    });

    test('find existing keys by many tag', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
        tags: ['t1', 't2'],
      );

      var record3 = createInstance<String>(
        key: 'k3',
        data: 'app3',
        tags: ['t3', 't4'],
      );

      var record4 = createInstance<String>(
        key: 'k4',
        data: 'app3',
        tags: ['t3', 't5'],
      );

      var record5 = createInstance<String>(
        key: 'k5',
        data: 'app3',
        tags: ['t6', 't5'],
      );

      var record6 = createInstance<String>(
        key: 'k6',
        data: 'app3',
        tags: ['t3'],
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);
      await _iNoSqlStorageProvider.add(record3);
      await _iNoSqlStorageProvider.add(record4);
      await _iNoSqlStorageProvider.add(record5);
      await _iNoSqlStorageProvider.add(record6);

      var keys =
          await _iNoSqlStorageProvider.findAllKeys(tags: ['t2', 't3', 't5']);
      expect(keys, equals(['k2', 'k3', 'k4', 'k5', 'k6']));
    });
  });
  group('delete records', () {
    test('delete existing record', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
      );

      await _iNoSqlStorageProvider.add(record);

      await _iNoSqlStorageProvider.delete('k1');
      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      expect(actualRecord, null);
    });

    test('delete non existing record', () async {
      await _iNoSqlStorageProvider.delete('k1');
      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      expect(actualRecord, null);
    });

    test('insure deleting specific key record', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
      );
      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
      );
      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);
      await _iNoSqlStorageProvider.delete('k1');

      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      var actualRecord2 = await _iNoSqlStorageProvider.get<String>('k2');
      expect(actualRecord, null);
      expect(actualRecord2, record2);
    });
  });

  group('delete all records', () {
    test('delete all existing records', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
      );
      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
      );
      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);
      await _iNoSqlStorageProvider.deleteAll();
      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      var actualRecord2 = await _iNoSqlStorageProvider.get<String>('k2');
      var allkeys = await _iNoSqlStorageProvider.findAllKeys();
      expect(actualRecord, null);
      expect(actualRecord2, null);
      expect(allkeys, isEmpty);
    });

    test('delete non existing record', () async {
      await _iNoSqlStorageProvider.deleteAll();
      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      var allkeys = await _iNoSqlStorageProvider.findAllKeys();
      expect(actualRecord, null);
      expect(allkeys, isEmpty);
    });

    test('delete existing keys by tag', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
        tags: ['t1', 't2'],
      );

      var record3 = createInstance<String>(
        key: 'k3',
        data: 'app3',
        tags: ['t3'],
      );

      await Future.wait([
        _iNoSqlStorageProvider.add(record),
        _iNoSqlStorageProvider.add(record2),
        _iNoSqlStorageProvider.add(record3)
      ]);
      await _iNoSqlStorageProvider.deleteAll(tags: ['t1']);
      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      var actualRecord2 = await _iNoSqlStorageProvider.get<String>('k2');
      var actualRecord3 = await _iNoSqlStorageProvider.get<String>('k3');

      expect(actualRecord, null);
      expect(actualRecord2, null);
      expect(actualRecord3, record3);
    });

    test('delete non existing tags', () async {
      var record = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
        tags: ['t1', 't2'],
      );

      var record3 = createInstance<String>(
        key: 'k3',
        data: 'app3',
        tags: ['t2'],
      );

      await _iNoSqlStorageProvider.add(record);
      await _iNoSqlStorageProvider.add(record2);
      await _iNoSqlStorageProvider.add(record3);
      await _iNoSqlStorageProvider.deleteAll(tags: ['t3']);
      var actualRecord = await _iNoSqlStorageProvider.get<String>('k1');
      var actualRecord2 = await _iNoSqlStorageProvider.get<String>('k2');
      var actualRecord3 = await _iNoSqlStorageProvider.get<String>('k3');

      expect(actualRecord, record);
      expect(actualRecord2, record2);
      expect(actualRecord3, record3);
    });

    test('delete multiple existing tags', () async {
      var record1 = createInstance<String>(
        key: 'k1',
        data: 'app3',
        tags: ['t1'],
      );

      var record2 = createInstance<String>(
        key: 'k2',
        data: 'app3',
        tags: ['t1', 't2'],
      );

      var record3 = createInstance<String>(
        key: 'k3',
        data: 'app3',
        tags: ['t3', 't4'],
      );

      var record4 = createInstance<String>(
        key: 'k4',
        data: 'app3',
        tags: ['t3', 't5'],
      );

      var record5 = createInstance<String>(
        key: 'k5',
        data: 'app3',
        tags: ['t6', 't5'],
      );

      var record6 = createInstance<String>(
        key: 'k6',
        data: 'app3',
        tags: ['t3'],
      );

      await _iNoSqlStorageProvider.add(record1);
      await _iNoSqlStorageProvider.add(record2);
      await _iNoSqlStorageProvider.add(record3);
      await _iNoSqlStorageProvider.add(record4);
      await _iNoSqlStorageProvider.add(record5);
      await _iNoSqlStorageProvider.add(record6);

      await _iNoSqlStorageProvider.deleteAll(tags: ['t2', 't3', 't5']);
      var keys =
          await _iNoSqlStorageProvider.findAllKeys(tags: ['t2', 't3', 't5']);

      var actualRecord1 = await _iNoSqlStorageProvider.get<String>('k1');
      var actualRecord2 = await _iNoSqlStorageProvider.get<String>('k2');
      var actualRecord3 = await _iNoSqlStorageProvider.get<String>('k3');
      var actualRecord4 = await _iNoSqlStorageProvider.get<String>('k4');
      var actualRecord5 = await _iNoSqlStorageProvider.get<String>('k5');
      var actualRecord6 = await _iNoSqlStorageProvider.get<String>('k6');

      expect(keys, isEmpty);
      expect(actualRecord1, record1);
      expect(actualRecord2, null);
      expect(actualRecord3, null);
      expect(actualRecord4, null);
      expect(actualRecord5, null);
      expect(actualRecord6, null);
    });
  });
}
