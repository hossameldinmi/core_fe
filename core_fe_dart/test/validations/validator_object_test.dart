import 'package:core_fe_dart/exceptions.dart';
import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import '../mocks/validations.dart';

void main() {
  ValidatorObject<String> validatorObject;
  MockValidationRule<String> mockValidationRule;
  const _value = 'Test Case';
  setUp(() {
    mockValidationRule = MockValidationRule<String>();
    validatorObject = ValidatorObject<String>(_value);
  });
  test('expected valid state when Object initialized', () {
    //aggregate
    validatorObject = ValidatorObject<String>();
    //act
    final actual = validatorObject.isValid();

    //assert
    expect(actual, true);
    expect(validatorObject.errors?.length, 0);
    expect(validatorObject.validations.length, 0);
  });
  test('expected isValid if Object rule is passed', () {
    //aggregate
    when(mockValidationRule.check(validatorObject.value)).thenReturn(true);
    //act
    validatorObject.add(mockValidationRule);
    final actual = validatorObject.isValid();

    //assert
    expect(actual, true);
    expect(validatorObject.errors.length, 0);
    expect(validatorObject.validations.length, 1);
    expect(validatorObject.value, _value); // verify value not changed
  });

  test('expected Not Valid if Object rule is NOT passed', () {
    //aggregate
    when(mockValidationRule.check(validatorObject.value)).thenReturn(false);
    //act
    validatorObject.add(mockValidationRule);
    final actual = validatorObject.isValid();

    //assert
    expect(actual, false);
    expect(validatorObject.errors.length, 1);
    expect(validatorObject.validations.length, 1);
    expect(validatorObject.value, _value); // verify value not changed
  });

  test('expected Exception if Object rule is NOT passed', () {
    //aggregate
    when(mockValidationRule.check(validatorObject.value)).thenReturn(false);
    when(mockValidationRule.validationException)
        .thenReturn(ValidationException(validationMessage: 'Not Valid'));
    //act
    validatorObject.add(mockValidationRule);
    //assert
    expect(() => validatorObject.isValid(throwException: true),
        throwsA(const TypeMatcher<ValidationException>()));
    expect(validatorObject.errors.length, 1);
    expect(validatorObject.validations.length, 1);
    expect(validatorObject.value, _value); // verify value not changed
  });

  test('expected Fist Exception if many Object rule is NOT passed', () {
    //aggregate
    final mockValidationRule2 = MockValidationRule<String>();
    final mockValidationRule3 = MockValidationRule<String>();

    when(mockValidationRule.check(validatorObject.value)).thenReturn(false);
    when(mockValidationRule.validationException).thenReturn(
        ValidationException(validationMessage: 'Not Valid', errorCode: 1));

    when(mockValidationRule2.check(validatorObject.value)).thenReturn(false);
    when(mockValidationRule2.validationException).thenReturn(
        ValidationException(validationMessage: 'Not Valid', errorCode: 2));

    when(mockValidationRule3.check(validatorObject.value)).thenReturn(false);
    when(mockValidationRule3.validationException).thenReturn(
        ValidationException(validationMessage: 'Not Valid', errorCode: 3));
    //act
    validatorObject.add(mockValidationRule);
    validatorObject.add(mockValidationRule2);
    validatorObject.add(mockValidationRule3);
    //assert
    expect(
        () => validatorObject.isValid(throwException: true),
        throwsA(const TypeMatcher<ValidationException>()
            .having((e) => e.errorCode, 'error-code', equals(1))));
    expect(validatorObject.errors.length, 3);
    expect(validatorObject.validations.length, 3);
    expect(validatorObject.value, _value); // verify value not changed
  });

  test('expected Fist Exception if only one Object rule NOT passed', () {
    //aggregate
    final mockValidationRule2 = MockValidationRule<String>();
    final mockValidationRule3 = MockValidationRule<String>();

    when(mockValidationRule.check(validatorObject.value)).thenReturn(true);
    when(mockValidationRule.validationException).thenReturn(
        ValidationException(validationMessage: 'Not Valid', errorCode: 1));

    when(mockValidationRule2.check(validatorObject.value)).thenReturn(false);
    when(mockValidationRule2.validationException).thenReturn(
        ValidationException(validationMessage: 'Not Valid', errorCode: 2));

    when(mockValidationRule3.check(validatorObject.value)).thenReturn(false);
    when(mockValidationRule3.validationException).thenReturn(
        ValidationException(validationMessage: 'Not Valid', errorCode: 3));
    //act
    validatorObject.add(mockValidationRule);
    validatorObject.add(mockValidationRule2);
    validatorObject.add(mockValidationRule3);
    //assert
    expect(
        () => validatorObject.isValid(throwException: true),
        throwsA(const TypeMatcher<ValidationException>()
            .having((e) => e.errorCode, 'error-code', equals(2))));
    expect(validatorObject.errors.length, 2);
    expect(validatorObject.validations.length, 3);
    expect(validatorObject.value, _value); // verify value not changed
  });

  test('expected Empty Validations if Object rule is cleared', () {
    //aggregate
    final mockValidationRule2 = MockValidationRule<String>();
    final mockValidationRule3 = MockValidationRule<String>();

    //act
    validatorObject.add(mockValidationRule);
    validatorObject.add(mockValidationRule2);
    validatorObject.add(mockValidationRule3);

    validatorObject.clear();
    //assert
    expect(validatorObject.isValid(throwException: true), true);
    expect(validatorObject.errors.length, 0);
    expect(validatorObject.validations.length, 0);
    expect(validatorObject.value, _value); // verify value not changed
  });
}
