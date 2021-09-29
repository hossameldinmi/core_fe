import 'package:core_fe_infrastructure/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_flutter/extensions.dart';
import 'package:core_fe_infrastructure/utils.dart';

final createdDate = DateTime(2020, 6, 1, 22, 5, 6);
final updatedDate = DateTime(2025, 5, 6, 2, 23, 45);
final expiryDate = DateTime.now();
const kCreatedDate = 'created_date';
const kUpdatedDate = 'updated_date';
const kExpiryDate = 'expiry_date';
const kData = 'data';

void main() async {
  group('init', () {
    test('validate key if empty', () {
      expect(
          () => StorageModel<int>(
              key: '',
              createdDate: DateTime.now(),
              updatedDate: DateTime.now(),
              data: 1,
              expiryDate: expiryDate,
              tags: const ['t1', 't2']),
          throwsAssertionError);
    });

    test('validate key if whitespace', () {
      expect(
          () => StorageModel<int>(
              key: '',
              createdDate: DateTime.now(),
              updatedDate: DateTime.now(),
              data: 1,
              expiryDate: expiryDate,
              tags: const ['t1', 't2']),
          throwsAssertionError);
    });

    test('validate tags if null', () {
      expect(
          () => StorageModel<int>(
              key: 'k1',
              createdDate: createdDate,
              updatedDate: updatedDate,
              data: 1,
              expiryDate: expiryDate,
              tags: null),
          returnsNormally);
    });
  });
  group('toJson', () {
    test('serialization on normal valid object', () {
      var storageModel = StorageModel<int>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: 1,
          expiryDate: expiryDate,
          tags: const ['t1', 't2']);

      var expectedJson = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: ['t1', 't2'],
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: expiryDate.format(),
        kData: 1
      };
      expect(storageModel.toJson(JsonUtil.getType<int>().toJson), expectedJson);
    });

    test('serialization when expiryDate is Null', () {
      var storageModel = StorageModel<int>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: 1,
          expiryDate: null,
          tags: const ['t1', 't2']);

      var expectedJson = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: ['t1', 't2'],
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: null,
        kData: 1
      };
      expect(storageModel.toJson(JsonUtil.getType<int>().toJson), expectedJson);
    });
    test('serialization when data is Null', () {
      var storageModel = StorageModel<int?>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: null,
          expiryDate: expiryDate,
          tags: const ['t1', 't2']);

      var expectedJson = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: ['t1', 't2'],
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: expiryDate.format(),
        kData: null
      };
      expect(storageModel.toJson(JsonUtil.getType<int>().toJson), expectedJson);
    });

    test('serialization when tags is null', () {
      var storageModel = StorageModel<int>(
          key: 'k1', createdDate: createdDate, updatedDate: updatedDate, data: 1, expiryDate: expiryDate, tags: null);

      var expectedJson = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: null,
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: expiryDate.format(),
        kData: 1
      };
      expect(storageModel.toJson(JsonUtil.getType<int>().toJson), expectedJson);
    });
  });
  group('fromJson', () {
    test('deserialize complete valid object ', () {
      var json = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: ['t1', 't2'],
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: expiryDate.format(),
        kData: 1
      };
      var expected = StorageModel<int>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: 1,
          expiryDate: expiryDate,
          tags: const ['t1', 't2']);

      expect(StorageModel<int>.fromJson(json, JsonUtil.getType<int>().fromJson), expected);
    });

    test('deserialize object with Null expiryDate', () {
      var json = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: ['t1', 't2'],
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: null,
        kData: 1
      };
      var expected = StorageModel<int>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: 1,
          expiryDate: null,
          tags: const ['t1', 't2']);

      expect(StorageModel<int>.fromJson(json, JsonUtil.getType<int>().fromJson), expected);
    });

    test('deserialize object with Null data', () {
      var json = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: ['t1', 't2'],
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: expiryDate.format(),
        kData: null
      };
      var expected = StorageModel<int?>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: null,
          expiryDate: expiryDate,
          tags: const ['t1', 't2']);

      expect(StorageModel<int>.fromJson(json, JsonUtil.getType<int>().fromJson), expected);
    });

    test('deserialize object with Tags is Null', () {
      var json = {
        StorageModel.kKey: 'k1',
        StorageModel.kTags: null,
        kCreatedDate: createdDate.format(),
        kUpdatedDate: updatedDate.format(),
        kExpiryDate: expiryDate.format(),
        kData: 1
      };
      var expected = StorageModel<int>(
          key: 'k1', createdDate: createdDate, updatedDate: updatedDate, data: 1, expiryDate: expiryDate, tags: null);

      expect(StorageModel<int>.fromJson(json, JsonUtil.getType<int>().fromJson), expected);
    });
  });

  group('isExpired', () {
    test('expired when expirydate passed', () {
      var storage = StorageModel<int>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: 1,
          expiryDate: expiryDate.subtract(const Duration(seconds: 1)),
          tags: const ['t1', 't2']);

      expect(storage.isExpired(), true);
    });

    test('expected false if not expired', () {
      var storage = StorageModel<int>(
          key: 'k1',
          createdDate: createdDate,
          updatedDate: updatedDate,
          data: 1,
          expiryDate: DateTime.now().add(const Duration(seconds: 1)),
          tags: const ['t1', 't2']);

      expect(storage.isExpired(), false);
    });
  });

  group('equality operator', () {
    test('equality when all equal fields', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: createdDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: createdDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, true);
    });

    test('equality when key fields are not equal=> not equal', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k2',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, false);
    });

    test('equality when expiryDate fields are not equal=> not equal', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: null,
        data: 1,
        tags: const ['t1', 't2'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, false);
    });

    test('equality when updatedDate fields are not equal=> not equal', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: expiryDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, false);
    });

    test('equality when createdDate fields are not equal=> not equal', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: expiryDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, false);
    });

    test('equality when data fields are not equal=> not equal', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 2,
        tags: const ['t1', 't2'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, false);
    });

    test('equality when tags fields are not the same order=> equal', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t2', 't1'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, true);
    });

    test('equality when tags fields are not equal=> not equal', () {
      var s1 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t1', 't2'],
      );
      var s2 = StorageModel<int>(
        key: 'k1',
        createdDate: createdDate,
        updatedDate: updatedDate,
        expiryDate: expiryDate,
        data: 1,
        tags: const ['t2', 't1', 't3'],
      );

      final areEqual = s1 == s2;

      expect(areEqual, false);
    });
  });
}
