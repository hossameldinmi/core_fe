import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/src/extensions/iterable_extensions.dart';
import 'package:collection/collection.dart';

void main() {
  group('list', () {
    test('(List<Srirng>) value equality => Orderd: equal| Not-Ordered:Equal',
        () {
      final list1 = <String>['S1', 'S2', 'S3'];
      final list2 = <String>['S1', 'S2', 'S3'];
      expect(list1.equals(list2), true);
      expect(list1.equals(list2, isOrderEquality: false), true);
    });

    test(
        '(List<Srirng>) value equality => Orderd: NOT equal| Not-Ordered:NOT Equal',
        () {
      final list1 = <String>['S1', 'S2', 'S3'];
      final list2 = <String>['S3', 'S2', 'S6'];
      expect(list1.equals(list2), false);
      expect(list1.equals(list2, isOrderEquality: false), false);
    });

    test(
        '(List<Srirng>) reference equality => Orderd: NOT equal| Not-Ordered:Equal',
        () {
      var s1 = 'S1';
      var s2 = 'S2';
      var s3 = 'S3';

      final list1 = <String>[s1, s2, s3];
      final list2 = <String>[s1, s2, s3];

      expect(list1.equals(list2), true);
      expect(list1.equals(list2, isOrderEquality: false), true);
    });

    test(
        '(List<Srirng>) reference equality => Orderd: equal| Not-Ordered:Equal',
        () {
      var s1 = 'S1';
      var s1C = 'S1';
      var s2 = 'S2';
      var s3 = 'S3';

      final list1 = <String>[s1, s2, s3];
      final list2 = <String>[s1C, s2, s3];

      expect(list1.equals(list2), true);
      expect(list1.equals(list2, isOrderEquality: false), true);
    });
    test(
        '(List<List<Srirng>>) reference equality => Orderd: NOT equal| Not-Ordered:Equal',
        () {
      final list1 = <String>['S1', 'S2', 'S3'];
      final list2 = <String>['S1', 'S2', 'S3'];
      final list3 = <String>['S3', 'S2', 'S1'];
      final list4 = <List<String>>[list1, list2, list3];
      final list5 = <List<String>>[list1, list2, list3];

      expect(list4.equals(list5), true);
      expect(list4.equals(list5, isOrderEquality: false), true);
    });

    test(
        '(List<List<Srirng>>) reference equality => Orderd: NOT equal| Not-Ordered:Equal',
        () {
      final list1 = <String>['S1', 'S2', 'S3'];
      final list2 = <String>['S1', 'S2', 'S3'];
      final list3 = <String>['S3', 'S2', 'S1'];
      final list4 = <List<String>>[list1, list2, list3];
      final list5 = <List<String>>[list3, list2, list1];

      expect(list4.equals(list5), false);
      expect(list4.equals(list5, isOrderEquality: false), true);
    });

    test(
        '(List<List<Srirng>>) value equality => Orderd: NOT equal| Not-Ordered:Equal',
        () {
      final list1 = <String>['S1', 'S2', 'S3'];
      final list2 = <String>['S1', 'S2', 'S3'];
      final list3 = <String>['S3', 'S2', 'S1'];
      final list4 = <List<String>>[list1, list2, list3];
      final list5 = <List<String>>[
        ['S1', 'S2', 'S3'],
        ['S1', 'S2', 'S3'],
        ['S3', 'S2', 'S1']
      ];

      expect(list4.equals(list5, elementEquality: ListEquality()), true);
      expect(
          list4.equals(list5,
              elementEquality: ListEquality(), isOrderEquality: false),
          true);
    });

    test(
        '(List<List<Srirng>>) value equality => Orderd: equal| Not-Ordered:Equal',
        () {
      final list1 = <List<String>>[
        ['S1', 'S2', 'S3'],
        ['S1', 'S2', 'S3'],
        ['S3', 'S2', 'S1']
      ];
      final list2 = <List<String>>[
        ['S1', 'S2', 'S3'],
        ['S1', 'S2', 'S3'],
        ['S3', 'S2', 'S1']
      ];
      expect(list1.equals(list2, elementEquality: ListEquality()), true);
      expect(
          list1.equals(list2,
              elementEquality: ListEquality(), isOrderEquality: false),
          true);
    });

    test('List<List<Srirng>>) value equality - NOT equal', () {
      final list1 = <List<String>>[
        ['S1', 'S2', 'S3'],
        ['S1', 'S2', 'S3'],
        ['S3', 'S2', 'S1']
      ];
      final list2 = <List<String>>[
        ['S1', 'S2', 'S3'],
        ['S3', 'S2', 'S1'],
        ['S1', 'S2', 'S3']
      ];
      expect(list1.equals(list2, elementEquality: ListEquality()), false);
      expect(
          list1.equals(list2,
              elementEquality: ListEquality(), isOrderEquality: false),
          true);
    });

    test('(List<List<Srirng>>) value equality - NOT equal', () {
      final list1 = <String>['S1', 'S2', 'S3'];
      final list2 = <String>['S1', 'S2', 'S3'];
      final list3 = <String>['S3', 'S2', 'S1'];
      final list4 = <List<String>>[
        ['S1', 'S2', 'S3'],
        ['S1', 'S2', 'S3'],
        ['S3', 'S2', 'S1']
      ];
      final list5 = <List<String>>[list1, list3, list2];
      expect(list4.equals(list5, elementEquality: ListEquality()), false);
      expect(
          list4.equals(list5,
              elementEquality: ListEquality(), isOrderEquality: false),
          true);
    });
  });

  group('Map', () {
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

    test(
        'Map<String, List<int>>) key&value equality| without valueEquality impl => NOT equal',
        () {
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

    test(
        'Map<String, List<int>>) key&value equality| without valueEquality impl| value:reference equality => equal',
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
      final result = m1.equals(m2, valueEquality: ListEquality());
      expect(result, true);
    });
    test('Map<String,List<int>>) key:not-equal | value: equal => not equal',
        () {
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
}
