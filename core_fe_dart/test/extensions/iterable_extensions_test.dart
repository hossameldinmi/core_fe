import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';
import 'package:core_fe_dart/extensions.dart';

void main() {
  group('equals', () {
    group('list', () {
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
  });
  group('intersection', () {
    group('list', () {
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

    group('Map', () {
      test('Map<String,int>) key&value intersection on 2 identical maps', () {
        final m1 = {'k1': 1, 'k2': 2, 'k3': 3};
        final m2 = {'k1': 1, 'k2': 2, 'k3': 3};
        final result = m1.intersection(m2);
        final expected = {'k1': 1, 'k2': 2, 'k3': 3};

        expect(result, expected);
      });

      test(
          'Map<String,int>) key&value intersection on 2 identical maps with different order',
          () {
        final m1 = {'k1': 1, 'k2': 2, 'k3': 3};
        final m2 = {'k3': 3, 'k2': 2, 'k1': 1};
        final result = m1.intersection(m2);
        final expected = {'k1': 1, 'k2': 2, 'k3': 3};
        expect(result, expected);
      });

      test('Map<String,int>) key&value intersection on with no matching values',
          () {
        final m1 = {'k1': 1, 'k2': 2, 'k3': 3};
        final m2 = {'k1': 3, 'k2': 1, 'k3': 4};
        final result = m1.intersection(m2);
        expect(result, {});
      });

      test(
          'Map<String,int>) key&value intersection on with no matching keys&values',
          () {
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

      test('Map<String, List<int>>) key&value reference equality intersection',
          () {
        final l1 = [1, 2, 3];
        final l2 = [4, 5, 6];
        final l3 = [7, 8, 9];

        final m1 = {'k1': l1, 'k2': l2, 'k3': l3};
        final m2 = {'k1': l1, 'k2': l2, 'k3': l3};

        final result = m1.intersection(m2);
        var expected = {'k1': l1, 'k2': l2, 'k3': l3};
        expect(result, expected);
      });
      test('Map<String, List<int>>) key&value two identical Maps intersection',
          () {
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
  });

  group('item fold', () {
    var str1 = '1.01';
    var double1 = 1.01;

    var str2 = '2.02';
    var double2 = 2.02;
    double toDouble(dynamic value) {
      return double.parse(value as String);
    }

    Future<void> expectCasting(dynamic input, dynamic expected) async {
      expect((input as Object).castAllInSync<double>(toDouble), expected);
      expect(
          await (input as Object).castAllIn<double>((value) =>
              Future.delayed(Duration(milliseconds: 1))
                  .then((v) => toDouble(value))),
          expected);
    }

    group('castAllInSync', () {
      test('expected null when value is null', () {
        expectCasting(null, null);
      });

      test('expected double Value when value is String', () {
        expectCasting(str1, double1);
        expectCasting(str2, double2);
      });

      test('expected List<double> when value is List<String>', () {
        expectCasting([str1, str2], [double1, double2]);
      });

      test('expected Map<String,double> when value is Map<String,String>', () {
        expectCasting(
            {'str1': str1, 'str2': str2}, {'str1': double1, 'str2': double2});
      });

      test(
          'expected Map<String,dynamic> when value is Map<String,dynamic>(List<String> & String)',
          () {
        expectCasting({
          'str1': [str1, str2],
          'str2': str1
        }, {
          'str1': [double1, double2],
          'str2': double1
        });
      });

      test(
          'expected List<Map<String,dynamic>> when value is List<Map<String,dynamic>>(List<String> & String)',
          () {
        expectCasting([
          {
            'str1': [str1, str2],
            'str2': str1
          },
          {
            'str1': [str1, str2],
            'str2': str1
          }
        ], [
          {
            'str1': [double1, double2],
            'str2': double1
          },
          {
            'str1': [double1, double2],
            'str2': double1
          }
        ]);
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
  });
}
