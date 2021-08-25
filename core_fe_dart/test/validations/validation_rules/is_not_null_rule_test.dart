import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IsNotNullRule<Object?> validationRule;
  test('expected false if Object value is null', () {
    validationRule =
        IsNotNullRule<Object?>.fromMessage(validationMessage: 'Invalid Object');
    expect(validationRule.check(null), false);
    expect(validationRule.check(Object()), true);
  });

  test('expected false if int value is null', () {
    validationRule =
        IsNotNullRule<int?>.fromMessage(validationMessage: 'Invalid int');
    expect(validationRule.check(null), false);
    expect(validationRule.check(1), true);
  });

  test('expected true if num value is null', () {
    validationRule =
        IsNotNullRule<num?>.fromMessage(validationMessage: 'Invalid num');
    expect(validationRule.check(null), false);
    expect(validationRule.check(1.5), true);
  });

  test('expected true if double value is null', () {
    validationRule =
        IsNotNullRule<double?>.fromMessage(validationMessage: 'Invalid double');
    expect(validationRule.check(null), false);
    expect(validationRule.check(1.5555555), true);
  });
}
