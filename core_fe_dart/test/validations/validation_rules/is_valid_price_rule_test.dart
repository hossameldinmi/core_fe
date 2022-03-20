import 'package:core_fe_dart/src/validations/validation_rules/is_valid_price_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validationRule =
      IsValidPriceRule.fromMessage(validationMessage: 'Invalid Price format');

  test('expected true if value is correct price', () {
    final actual = validationRule.check('1');
    expect(actual, true);
  });

  test('expected true if value is decimal', () {
    final actual = validationRule.check('1.0');
    final actual2 = validationRule.check('1.1234');
    expect(actual, true);
    expect(actual2, true);
  });

  test('expected true if value is big number', () {
    final actual = validationRule.check('122332132223123');
    expect(actual, true);
  });

  test('expected true if value is fraction number', () {
    final actual = validationRule.check('0.13');
    final actual2 = validationRule.check('.13');
    final actual3 = validationRule.check('.1234');
    final actual4 = validationRule.check('.12323234');
    expect(actual, true);
    expect(actual2, true);
    expect(actual3, true);
    expect(actual4, true);
  });

  test('expected false if value is negative fraction number', () {
    final actual = validationRule.check('-.13');
    expect(actual, false);
  });

  test('expected false if value is negative decimal number', () {
    final actual = validationRule.check('-1232.13');
    expect(actual, false);
  });

  test('expected false if value is negative int number', () {
    final actual = validationRule.check('-1232');
    expect(actual, false);
  });
}
