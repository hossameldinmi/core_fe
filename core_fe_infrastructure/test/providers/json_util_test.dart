import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:core_fe_infrastructure/src/utils/json_util.dart';

void main() async {
  test('Expected Error if type is not registered', () {
    expect(
      () => JsonUtil.getType<Map>(),
      throwsA(
        const TypeMatcher<ArgumentError>().having(
          (e) => e.message,
          'Type is not registered in JsonUtil.getType',
          equals('Key [Map<dynamic, dynamic>] is not supported'),
        ),
      ),
    );
  });
  group('int', () {
    test('expected serialization & deserialization', () {
      const value = 1;
      var json = 1;

      var actualValue = JsonUtil.getType<int>().fromJson(json);
      var actualJson = JsonUtil.getType<int>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected serialization & deserialization when null', () {
      const int? value = null;
      const int? json = null;

      var actualValue = JsonUtil.getType<int>().fromJson(json);
      var actualJson = JsonUtil.getType<int>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('num', () {
    test('expected serialization & deserialization', () {
      num value = 1.01;
      var json = 1.01;

      var actualValue = JsonUtil.getType<num>().fromJson(json);
      var actualJson = JsonUtil.getType<num>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected failed deserialization', () {
      var value = '1.01';
      expect(() => JsonUtil.getType<num>().fromJson(value), throwsA(const TypeMatcher<TypeError>()));
    });

    test('expected serialization & deserialization when null', () {
      const num? value = null;
      const json = value;

      var actualValue = JsonUtil.getType<num>().fromJson(json);
      var actualJson = JsonUtil.getType<num>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('double', () {
    test('expected serialization & deserialization', () {
      var value = 1.01;
      var json = 1.01;

      var actualValue = JsonUtil.getType<double>().fromJson(json);
      var actualJson = JsonUtil.getType<double>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected serialization & deserialization when value is int', () {
      var json = 1.toDouble();

      var actualJson = JsonUtil.getType<double>().toJson(1);

      expect(actualJson, json);
    });

    test('expected serialization & deserialization when null', () {
      const double? value = null;
      const json = value;

      var actualValue = JsonUtil.getType<double>().fromJson(json);
      var actualJson = JsonUtil.getType<double>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('string', () {
    test('expected serialization & deserialization', () {
      var value = 'string';
      var json = 'string';

      var actualValue = JsonUtil.getType<String>().fromJson(json);
      var actualJson = JsonUtil.getType<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected serialization & deserialization when number', () {
      var value = '1.01';
      var json = '1.01';

      var actualValue = JsonUtil.getType<String>().fromJson(json);
      var actualJson = JsonUtil.getType<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected serialization & deserialization when null', () {
      const String? value = null;
      const json = value;

      var actualValue = JsonUtil.getType<String>().fromJson(json);
      var actualJson = JsonUtil.getType<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('Iterable', () {
    test('expected serialization & deserialization', () {
      var value = ['string1', 'string2', 'string3'];
      var json = value;

      var actualValue = JsonUtil.getIterable<String>().fromJson(json);
      var actualJson = JsonUtil.getIterable<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected serialization & deserialization when empty', () {
      var value = <String>[];
      var json = value;

      var actualValue = JsonUtil.getIterable<String>().fromJson(json);
      var actualJson = JsonUtil.getIterable<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected serialization & deserialization when null', () {
      const List<String?>? value = null;
      const List<String?>? json = null;

      var actualValue = JsonUtil.getIterable<String>().fromJson(json);
      var actualJson = JsonUtil.getIterable<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });
}
