import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/extensions.dart';

void main() {
  group('String Format', () {
    test('formated text expected test', () {
      expect('between {min} and {max}'.formatString({'min': 5, 'max': 10}),
          'between 5 and 10');
    });

    test('formated text expected test', () {
      expect('between min and max'.formatString({'min': 5, 'max': 10}),
          'between min and max');
    });
    test('expected empty if value is null', () {
      expect('between {min} and {max}'.formatString({'min': 5, 'max': null}),
          'between 5 and ');
    });

    test('expected formated string if args are not ordered', () {
      expect('between {min} and {max}'.formatString({'max': 10, 'min': 5}),
          'between 5 and 10');
    });

    test('expected unformated text if args are empty', () {
      expect('between {min} and {max}'.formatString({}),
          'between {min} and {max}');
    });

    test('expected formated text if arg key not existed in string', () {
      expect(
          'between {min} and {max}'
              .formatString({'max': 10, 'min': 5, 'mean': 7.5}),
          'between 5 and 10');
    });

    test('expected formated text if arg key isnot existed in args', () {
      expect('between {min} and {max}'.formatString({'max': 10}),
          'between {min} and 10');
    });
    test('expected unformated text if args is empty', () {
      expect('between {min} and {max}'.formatString({}),
          'between {min} and {max}');
    });

    test('expected unformated text if args is null', () {
      expect('between {min} and {max}'.formatString(null),
          'between {min} and {max}');
    });

    test('formated arabic text expected test', () {
      expect('من {min} إلى {max}'.formatString({'min': 5, 'max': 10}),
          'من 5 إلى 10');
    });
  });
}
