import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/src/extensions/_export.dart';

void main() {
  group('isNullEmptyOrWhitespace on String', () {
    test('expected true if value is null', () {
      String str;
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

  group('isNullEmptyOrWhitespace on Object', () {
    test('expected true if object is not intialized', () {
      Object obj;
      expect(obj.isNullEmptyOrWhitespace(), true);
    });

    test('expected false if object has value', () {
      const obj = Object;
      expect(obj.isNullEmptyOrWhitespace(), false);
    });
  });

  group('isNullEmptyOrWhitespace on List', () {
    Iterable list;

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
}
