import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';
import 'package:core_fe_dart/extensions.dart';

void main() {
  group('equals', () {
    test('Map<String,int>) key&value equality => equal', () {
      final m1 = <String, int>{'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = <String, int>{'k1': 1, 'k2': 2, 'k3': 3};
      final result = m1.equals(m2);
      expect(result, true);
    });

    test('Map<String,int>) key&value non ordered equality -> equal', () {
      final m1 = <String, int>{'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = <String, int>{'k3': 3, 'k2': 2, 'k1': 1};
      final result = m1.equals(m2);
      expect(result, true);
    });

    test('Map<String,int>) key equality|value non-equality => not equal', () {
      final m1 = <String, int>{'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = <String, int>{'k1': 3, 'k2': 1, 'k3': 4};
      final result = m1.equals(m2);
      expect(result, false);
    });

    test('Map<String,int>) key:not-equal | value: equal => not equal', () {
      final m1 = <String, int>{'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = <String, int>{'k5': 3, 'k6': 1, 'k7': 4};
      final result = m1.equals(m2);
      expect(result, false);
    });

    test('Map<String,int>) key:not-equal | value: equal => not equal', () {
      final m1 = <String, int>{'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = <String, int>{'k5': 3, 'k6': 1, 'k7': 4};
      final result = m1.equals(m2);
      expect(result, false);
    });

    test('Map<String, List<int>>) key&value equality| without valueEquality impl => NOT equal', () {
      final m1 = <String, List<int>>{
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final m2 = <String, List<int>>{
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final result = m1.equals(m2);
      expect(result, false);
    });

    test('Map<String, List<int>>) key&value equality| without valueEquality impl| value:reference equality => equal',
        () {
      final l1 = [1, 2, 3];
      final l2 = [4, 5, 6];
      final l3 = [7, 8, 9];

      final m1 = <String, List<int>>{'k1': l1, 'k2': l2, 'k3': l3};
      final m2 = <String, List<int>>{'k1': l1, 'k2': l2, 'k3': l3};

      final result = m1.equals(m2);

      expect(result, true);
    });
    test('Map<String, List<int>>) key&value equality => equal', () {
      final m1 = <String, List<int>>{
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final m2 = <String, List<int>>{
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final result = m1.equals(m2, valueEquality: const ListEquality());
      expect(result, true);
    });
    test('Map<String,List<int>>) key:not-equal | value: equal => not equal', () {
      final m1 = <String, List<int>>{
        'k1': [1, 2, 3],
        'k2': [1, 2, 3],
        'k3': [1, 2, 3]
      };
      final m2 = <String, List<int>>{
        'k5': [1, 2, 3],
        'k6': [1, 2, 3],
        'k7': [1, 2, 3]
      };
      final result = m1.equals(m2);
      expect(result, false);
    });
  });

  group('intersection', () {
    test('Map<String,int>) key&value intersection on 2 identical maps', () {
      final m1 = {'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = {'k1': 1, 'k2': 2, 'k3': 3};
      final result = m1.intersection(m2);
      final expected = {'k1': 1, 'k2': 2, 'k3': 3};

      expect(result, expected);
    });

    test('Map<String,int>) key&value intersection on 2 identical maps with different order', () {
      final m1 = {'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = {'k3': 3, 'k2': 2, 'k1': 1};
      final result = m1.intersection(m2);
      final expected = {'k1': 1, 'k2': 2, 'k3': 3};
      expect(result, expected);
    });

    test('Map<String,int>) key&value intersection on with no matching values', () {
      final m1 = {'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = {'k1': 3, 'k2': 1, 'k3': 4};
      final result = m1.intersection(m2);
      expect(result, {});
    });

    test('Map<String,int>) key&value intersection on with no matching keys&values', () {
      final m1 = {'k1': 1, 'k2': 2, 'k3': 3};
      final m2 = {'k5': 3, 'k6': 1, 'k7': 4};
      final result = m1.intersection(m2);
      expect(result, {});
    });

    test('Map<String, List<int>>) key&value intersection', () {
      final m1 = {
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final m2 = {
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final result = m1.intersection(m2);
      var expected = {
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      expect(result, expected);
    }, skip: 'TODO: implement List value equality');

    test('Map<String, List<int>>) key&value reference equality intersection', () {
      final l1 = [1, 2, 3];
      final l2 = [4, 5, 6];
      final l3 = [7, 8, 9];

      final m1 = {'k1': l1, 'k2': l2, 'k3': l3};
      final m2 = {'k1': l1, 'k2': l2, 'k3': l3};

      final result = m1.intersection(m2);
      var expected = {'k1': l1, 'k2': l2, 'k3': l3};
      expect(result, expected);
    });
    test('Map<String, List<int>>) key&value two identical Maps intersection', () {
      final m1 = {
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final m2 = {
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      final result = m1.intersection(m2);
      var expected = {
        'k1': [1, 2, 3],
        'k2': [4, 5, 6],
        'k3': [7, 8, 9]
      };
      expect(result, expected);
    }, skip: 'TODO: implement List value equality');
  });
}
