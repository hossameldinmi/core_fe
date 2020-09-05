import 'package:core_fe_infrastructure/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_flutter/utils.dart';
import '../core_fe_infrastructure.dart';
import 'package:matcher/matcher.dart';

void main() {
  BaseFactory.init(CoreFeInfrastructureTest());
  group('int', () {
    test('expected succeeded serialization & deserialization', () {
      const value = 1;
      var json = 1;

      var actualValue = jsonFactory<int>().fromJson(json);
      var actualJson = jsonFactory<int>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected succeeded serialization & deserialization when null', () {
      const int value = null;
      const json = value;

      var actualValue = jsonFactory<int>().fromJson(json);
      var actualJson = jsonFactory<int>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('num', () {
    test('expected succeeded serialization & deserialization', () {
      num value = 1.01;
      var json = 1.01;

      var actualValue = jsonFactory<num>().fromJson(json);
      var actualJson = jsonFactory<num>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected failed deserialization', () {
      var value = '1.01';
      expect(() => jsonFactory<num>().fromJson(value),
          throwsA(const TypeMatcher<TypeError>()));
    });

    test('expected succeeded serialization & deserialization when null', () {
      const num value = null;
      const json = value;

      var actualValue = jsonFactory<num>().fromJson(json);
      var actualJson = jsonFactory<num>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('double', () {
    test('expected succeeded serialization & deserialization', () {
      var value = 1.01;
      var json = 1.01;

      var actualValue = jsonFactory<double>().fromJson(json);
      var actualJson = jsonFactory<double>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected succeeded serialization & deserialization when value is int',
        () {
      var json = 1.toDouble();

      var actualJson = jsonFactory<double>().toJson(1);

      expect(actualJson, json);
    });

    test('expected succeeded serialization & deserialization when null', () {
      const double value = null;
      const json = value;

      var actualValue = jsonFactory<double>().fromJson(json);
      var actualJson = jsonFactory<double>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('string', () {
    test('expected succeeded serialization & deserialization', () {
      var value = 'string';
      var json = 'string';

      var actualValue = jsonFactory<String>().fromJson(json);
      var actualJson = jsonFactory<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected succeeded serialization & deserialization when number', () {
      var value = '1.01';
      var json = '1.01';

      var actualValue = jsonFactory<String>().fromJson(json);
      var actualJson = jsonFactory<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected succeeded serialization & deserialization when null', () {
      const String value = null;
      const json = value;

      var actualValue = jsonFactory<String>().fromJson(json);
      var actualJson = jsonFactory<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });

  group('Iterable', () {
    test('expected succeeded serialization & deserialization', () {
      var value = ['string1', 'string2', 'string3'];
      var json = value;

      var actualValue = jsonFactory.iterable<String>().fromJson(json);
      var actualJson = jsonFactory.iterable<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected succeeded serialization & deserialization when empty', () {
      var value = <String>[];
      var json = value;

      var actualValue = jsonFactory.iterable<String>().fromJson(json);
      var actualJson = jsonFactory.iterable<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });

    test('expected succeeded serialization & deserialization when null', () {
      const List<String> value = null;
      var json = value;

      var actualValue = jsonFactory.iterable<String>().fromJson(json);
      var actualJson = jsonFactory.iterable<String>().toJson(value);

      expect(actualJson, json);
      expect(actualValue, value);
    });
  });
}
