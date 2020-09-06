import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Is Not Null, Empty or Whitespace String Rule', () {
    final validationRule = IsNotNullEmptyWhitespaceRule<String>.fromMessage(
        validationMessage: 'Invalid message');
    test('expected false if value is null', () {
      final actual = validationRule.check(null);
      expect(actual, false);
    });

    test('expected false if value is empty', () {
      final actual = validationRule.check('');
      expect(actual, false);
    });

    test('expected true if value is whitespace', () {
      final actual = validationRule.check(' ');
      expect(actual, false);
    });

    test('expected true if value is number', () {
      final actual = validationRule.check('1223');
      expect(actual, true);
    });
  });
}
