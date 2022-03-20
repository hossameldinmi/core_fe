import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/extensions.dart';

void main() {
  group('isNullEmptyOrWhitespace', () {
    group('on String', () {
      test('expected true if value is null', () {
        String? str;
        expect(str.isNullEmptyOrWhitespace(), true);
      });

      test('expected ture if value is empty', () {
        const str = '';
        expect(str.isNullEmptyOrWhitespace(), true);
      });

      test('expected true if value is whitespace', () {
        const str = ' ';
        expect(str.isNullEmptyOrWhitespace(), true);
      });

      test('expected false if value is number', () {
        const str = '1234';
        expect(str.isNullEmptyOrWhitespace(), false);
      });
    });

    group('on Object', () {
      test('expected true if object is not intialized', () {
        Object? obj;
        expect(obj.isNullEmptyOrWhitespace(), true);
      });

      test('expected false if object has value', () {
        const obj = Object;
        expect(obj.isNullEmptyOrWhitespace(), false);
      });
    });

    group('on List', () {
      Iterable? list;

      test('expected true if List is not intialized', () {
        expect(list.isNullEmptyOrWhitespace(), true);
      });

      test('expected false if object has value', () {
        list = [];
        expect(list.isNullEmptyOrWhitespace(), true);
      });

      test('expected false if object has value', () {
        list = [1, 2];
        expect(list.isNullEmptyOrWhitespace(), false);
      });
    });
  });
  group('anyIsNullEmptyOrWhitespace', () {
    test('expected true if list has value empty', () {
      var list = ['', 'string', 1];
      expect(list.anyIsNullEmptyOrWhitespace(), true);
    });

    test('expected true if list has whitespace', () {
      var list = ['string', ' ', 1];
      expect(list.anyIsNullEmptyOrWhitespace(), true);
    });

    test('expected true if list has value null', () {
      var list = [1, 'string', null];
      expect(list.anyIsNullEmptyOrWhitespace(), true);
    });

    test('expected true if all values are null', () {
      var list = [null, null, null];
      expect(list.anyIsNullEmptyOrWhitespace(), true);
    });

    test('expected true if all values are empty', () {
      var list = ['', '', ''];
      expect(list.anyIsNullEmptyOrWhitespace(), true);
    });

    test('expected true if all values are whitespace', () {
      var list = [' ', ' ', ' '];
      expect(list.anyIsNullEmptyOrWhitespace(), true);
    });

    test('expected false if all items has values', () {
      var list = ['Test', 'string', 1];
      expect(list.anyIsNullEmptyOrWhitespace(), false);
    });
  });

  group('anyIsNotNullEmptyOrWhitespace', () {
    test('expected true if list has 1 valid value', () {
      var list = ['', 'string', 1];
      expect(list.anyIsNotNullEmptyOrWhitespace(), true);
    });

    test('expected true if list 1 valid value', () {
      var list = ['string', ' ', 1];
      expect(list.anyIsNotNullEmptyOrWhitespace(), true);
    });

    test('expected true if list 1 valid value', () {
      var list = [1, 'string', null];
      expect(list.anyIsNotNullEmptyOrWhitespace(), true);
    });

    test('expected false if all values are null', () {
      var list = [null, null, null];
      expect(list.anyIsNotNullEmptyOrWhitespace(), false);
    });

    test('expected false if all values are empty', () {
      var list = ['', '', ''];
      expect(list.anyIsNotNullEmptyOrWhitespace(), false);
    });

    test('expected false if all values are whitespace', () {
      var list = [' ', ' ', ' '];
      expect(list.anyIsNotNullEmptyOrWhitespace(), false);
    });

    test('expected false if all items has valid values', () {
      var list = ['Test', 'string', 1];
      expect(list.anyIsNotNullEmptyOrWhitespace(), true);
    });
  });
}
