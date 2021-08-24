import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';
import 'package:core_fe_dart/extensions.dart';

import '../mocks/models.dart';

void main() {
  group('IterableExtensions', () {
    group('isEqual', () {
      test('(List<Srirng>) value equality => Orderd: equal| Not-Ordered:Equal',
          () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        expect(list1.isEqual(list2), true);
        expect(list1.isEqual(list2, isOrderEquality: false), true);
      });

      test(
          '(List<Srirng>) value equality => Orderd: NOT equal| Not-Ordered:NOT Equal',
          () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S3', 'S2', 'S6'];
        expect(list1.isEqual(list2), false);
        expect(list1.isEqual(list2, isOrderEquality: false), false);
      });

      test(
          '(List<Srirng>) reference equality => Orderd: NOT equal| Not-Ordered:Equal',
          () {
        var s1 = 'S1';
        var s2 = 'S2';
        var s3 = 'S3';

        final list1 = [s1, s2, s3];
        final list2 = [s1, s2, s3];

        expect(list1.isEqual(list2), true);
        expect(list1.isEqual(list2, isOrderEquality: false), true);
      });

      test(
          '(List<Srirng>) reference equality => Orderd: equal| Not-Ordered:Equal',
          () {
        var s1 = 'S1';
        var s1C = 'S1';
        var s2 = 'S2';
        var s3 = 'S3';

        final list1 = [s1, s2, s3];
        final list2 = [s1C, s2, s3];

        expect(list1.isEqual(list2), true);
        expect(list1.isEqual(list2, isOrderEquality: false), true);
      });
      test(
          '(List<List<Srirng>>) reference equality => Orderd: NOT equal| Not-Ordered:Equal',
          () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        final list3 = ['S3', 'S2', 'S1'];
        final list4 = [list1, list2, list3];
        final list5 = [list1, list2, list3];

        expect(list4.isEqual(list5), true);
        expect(list4.isEqual(list5, isOrderEquality: false), true);
      });

      test(
          '(List<List<Srirng>>) reference equality => Orderd: NOT equal| Not-Ordered:Equal',
          () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        final list3 = ['S3', 'S2', 'S1'];
        final list4 = [list1, list2, list3];
        final list5 = [list3, list2, list1];

        expect(list4.isEqual(list5), false);
        expect(list4.isEqual(list5, isOrderEquality: false), true);
      });

      test(
          '(List<List<Srirng>>) value equality => Orderd: NOT equal| Not-Ordered:Equal',
          () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        final list3 = ['S3', 'S2', 'S1'];
        final list4 = [list1, list2, list3];
        final list5 = [
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1']
        ];

        expect(list4.isEqual(list5, elementEquality: ListEquality()), true);
        expect(
            list4.isEqual(list5,
                elementEquality: ListEquality(), isOrderEquality: false),
            true);
      });

      test(
          '(List<List<Srirng>>) value equality => Orderd: equal| Not-Ordered:Equal',
          () {
        final list1 = [
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1']
        ];
        final list2 = [
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1']
        ];
        expect(list1.isEqual(list2, elementEquality: ListEquality()), true);
        expect(
            list1.isEqual(list2,
                elementEquality: ListEquality(), isOrderEquality: false),
            true);
      });

      test('List<List<Srirng>>) value equality - NOT equal', () {
        final list1 = [
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1']
        ];
        final list2 = [
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1'],
          ['S1', 'S2', 'S3']
        ];
        expect(list1.isEqual(list2, elementEquality: ListEquality()), false);
        expect(
            list1.isEqual(list2,
                elementEquality: ListEquality(), isOrderEquality: false),
            true);
      });

      test('(List<List<Srirng>>) value equality - NOT equal', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        final list3 = ['S3', 'S2', 'S1'];
        final list4 = [
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1']
        ];
        final list5 = [list1, list3, list2];
        expect(list4.isEqual(list5, elementEquality: ListEquality()), false);
        expect(
            list4.isEqual(list5,
                elementEquality: ListEquality(), isOrderEquality: false),
            true);
      });
    });
    group('intersection', () {
      test('(List<Srirng>) identical lists intersecion', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        expect(list1.intersection(list2), ['S1', 'S2', 'S3']);
      });

      test('(List<Srirng>) multi intersection', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S3', 'S2', 'S6'];
        expect(list1.intersection(list2), ['S2', 'S3']);
      });

      test('(List<Srirng>) same reference elements intersection', () {
        var s1 = 'S1';
        var s2 = 'S2';
        var s3 = 'S3';

        final list1 = [s1, s2, s3];
        final list2 = [s1, s2, s3];

        expect(list1.intersection(list2), ['S1', 'S2', 'S3']);
      });

      test('(List<List<Srirng>>) 2D same reference intersection', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        final list3 = ['S3', 'S2', 'S1'];
        final list4 = [list1, list2, list3];
        final list5 = [list1, list2, list3];

        expect(list4.intersection(list5), [list1, list2, list3]);
      });

      test('(List<List<Srirng>>) 2D same reference not orderd lists', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        final list3 = ['S3', 'S2', 'S1'];
        final list4 = [list1, list2, list3];
        final list5 = [list3, list2, list1];

        expect(list4.intersection(list5), [list1, list2, list3]);
      });

      test('List<List<Srirng>>) 2D value intersection', () {
        final list1 = [
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1']
        ];
        final list2 = [
          ['S1', 'S2', 'S3'],
          ['S3', 'S2', 'S1'],
          ['S1', 'S2', 'S3']
        ];
        expect(
            list1.intersection(
              list2,
            ),
            [
              ['S1', 'S2', 'S3'],
              ['S3', 'S2', 'S1']
            ]);
      }, skip: 'TODO: provide 2D intersection impl');

      test('List<List<Srirng>>) 2D value intersection with no matching records',
          () {
        final list1 = [
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3'],
          ['S1', 'S2', 'S3']
        ];
        final list2 = [
          ['S3', 'S2', 'S1'],
          ['S3', 'S2', 'S1'],
          ['S3', 'S2', 'S1']
        ];
        expect(
            list1.intersection(
              list2,
            ),
            []);
      });
    });

    group('indexMap', () {
      test('empty', () {
        List list;
        expect(() => list.indexMap((i, o) => i * o), throwsAssertionError);
        expect([].indexMap((i, o) => i * o), []);
      });
      test('not empty', () {
        expect([0, 1, 2, 3].indexMap((i, o) => i * o), [0, 1, 4, 9]);
        expect([1].indexMap((i, o) => i * o), [0]);
        expect([1, 1, 1, 1, 1].indexMap((i, o) => i * o), [0, 1, 2, 3, 4]);
      });
    });
  });

  group('list extensions', () {
    group('replace where', () {
      test('expected replace first item with new value', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S3', 'S2', 'S3'];
        list1.replaceWhere((s) => s == 'S1', (oldObject) => 'S3');
        expect(list1, list2);
      });
      test('expected replace second item with new value', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S3', 'S3'];
        list1.replaceWhere((s) => s == 'S2', (oldObject) => 'S3');
        expect(list1, list2);
      });

      test('expected replace all items with new value', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S3', 'S3', 'S3'];
        list1.replaceWhere((s) => s.contains('S'), (oldObject) => 'S3');
        expect(list1, list2);
      });

      test('expected replace NO items with new value', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        list1.replaceWhere((s) => s.contains('H'), (oldObject) => 'S3');
        expect(list1, list2);
      });
    });

    group('addOrUpdateWhere', () {
      test('expected replace last item with the same value', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3'];
        list1.addOrUpdate('S3');
        expect(list1, list2);
      });
      test('expected replace second item with new value', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S3', 'S3'];
        list1.addOrUpdate(
          'S3',
          test: (s) => s == 'S2',
        );
        expect(list1, list2);
      });

      test('expected replace first item ONLY with the new value', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S3', 'S2', 'S3'];
        list1.addOrUpdate('S3', test: (s) => s.contains('S'));
        expect(list1, list2);
      });

      test('expected add new item to the list', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3', 'S4'];
        list1.addOrUpdate('S4');
        expect(list1, list2);
      });

      test('expected add new item to the list if test is NOT passed', () {
        final list1 = ['S1', 'S2', 'S3'];
        final list2 = ['S1', 'S2', 'S3', 'S4'];
        list1.addOrUpdate(
          'S4',
          test: (s) => s == 'H',
        );
        expect(list1, list2);
      });
    });

    group('removeExisting', () {
      test('null updated list', () {
        var originalList = [o(0), o(1), o(2), o(3)];
        expect(
            () => originalList.removeNotExisting(null), throwsAssertionError);
      });
      test('no items removed if updatedlist is same with original', () {
        var originalList = [o(0), o(1), o(2), o(3)];
        var updatedList = [o(0), o(1), o(2), o(3)];
        var removedItems = originalList.removeNotExisting(updatedList);
        expect(originalList, [o(0), o(1), o(2), o(3)]);
        expect(removedItems, isEmpty);
      });
      test('all are not existing items', () {
        var originalList = [o(0), o(1), o(2), o(3)];
        var updatedList = [o(4), o(5), o(6), o(7)];
        var removedItems = originalList.removeNotExisting(updatedList);
        expect(originalList, isEmpty);
        expect(removedItems, [o(0), o(1), o(2), o(3)]);
      });
      test('some are not existing', () {
        var originalList = [o(0), o(1), o(2), o(3)];
        var updatedList = [o(3), o(5), o(2), o(7)];
        var removedItems = originalList.removeNotExisting(updatedList);
        expect(originalList, [o(2), o(3)]);
        expect(removedItems, [o(0), o(1)]);
      });
      test('updated list with no elements', () {
        var originalList = [o(0), o(1), o(2), o(3)];
        var updatedList = <Element>[];
        var removedItems = originalList.removeNotExisting(updatedList);
        expect(originalList, isEmpty);
        expect(removedItems, [o(0), o(1), o(2), o(3)]);
      });
    });
  });
}
