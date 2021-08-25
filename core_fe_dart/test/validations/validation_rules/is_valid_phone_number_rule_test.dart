import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validationRule =
      IsValidPhoneNumberRule.fromMessage(validationMessage: 'Invalid message');

  test('expected true if value is correct number', () {
    final actual = validationRule.check('01222332222');
    expect(actual, true);
  });

  test('expected false if value is not number', () {
    final actual = validationRule.check('test');
    expect(actual, false);
  });

  // test('expected false if value is null', () {
  //   expect(validationRule.check(null), false);
  // });

  test('expected false if value is empty', () {
    final actual = validationRule.check('');
    expect(actual, false);
  });

  test('expected false if value is whitespace', () {
    final actual = validationRule.check(' ');
    expect(actual, false);
  });

  test('expected false if value is random number', () {
    final actual = validationRule.check('1223');
    expect(actual, false);
  });

  test('expected false if value is short number', () {
    final actual = validationRule.check('0122');
    expect(actual, false);
  });
}
