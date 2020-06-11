import 'package:core_fe_dart/src/exceptions/_export.dart';
import 'package:core_fe_dart/src/validations/_export.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import '../mocks/validations.dart';

void main() {
  ValidatableObject<String> validatableObject;
  MockValidationRule<String> mockValidationRule;
  const _value = 'Test Case';
  setUp(() {
    mockValidationRule = MockValidationRule<String>();
    validatableObject = ValidatableObject<String>(_value);
  });
  group('Validitable object tests', () {
    test('expected isValid if Object rule is passed', () {
      //aggregate
      when(mockValidationRule.check(validatableObject.value)).thenReturn(true);
      //act
      validatableObject.add(mockValidationRule);
      final actual = validatableObject.isValid();

      //assert
      expect(actual, true);
      expect(validatableObject.errors.length, 0);
      expect(validatableObject.validations.length, 1);
      expect(validatableObject.value, _value); // verify value not changed
    });

    test('expected Not Valid if Object rule is NOT passed', () {
      //aggregate
      when(mockValidationRule.check(validatableObject.value)).thenReturn(false);
      //act
      validatableObject.add(mockValidationRule);
      final actual = validatableObject.isValid();

      //assert
      expect(actual, false);
      expect(validatableObject.errors.length, 1);
      expect(validatableObject.validations.length, 1);
      expect(validatableObject.value, _value); // verify value not changed
    });

    test('expected Exception if Object rule is NOT passed', () {
      //aggregate
      when(mockValidationRule.check(validatableObject.value)).thenReturn(false);
      when(mockValidationRule.validationException)
          .thenReturn(ValidationException(validationMessage: 'Not Valid'));
      //act
      validatableObject.add(mockValidationRule);
      //assert
      expect(() => validatableObject.isValid(throwException: true),
          throwsA(const TypeMatcher<ValidationException>()));
      expect(validatableObject.errors.length, 1);
      expect(validatableObject.validations.length, 1);
      expect(validatableObject.value, _value); // verify value not changed
    });

    test('expected Fist Exception if many Object rule is NOT passed', () {
      //aggregate
      final mockValidationRule2 = MockValidationRule<String>();
      final mockValidationRule3 = MockValidationRule<String>();

      when(mockValidationRule.check(validatableObject.value)).thenReturn(false);
      when(mockValidationRule.validationException).thenReturn(
          ValidationException(validationMessage: 'Not Valid', errorCode: '1'));

      when(mockValidationRule2.check(validatableObject.value))
          .thenReturn(false);
      when(mockValidationRule2.validationException).thenReturn(
          ValidationException(validationMessage: 'Not Valid', errorCode: '2'));

      when(mockValidationRule3.check(validatableObject.value))
          .thenReturn(false);
      when(mockValidationRule3.validationException).thenReturn(
          ValidationException(validationMessage: 'Not Valid', errorCode: '3'));
      //act
      validatableObject.add(mockValidationRule);
      validatableObject.add(mockValidationRule2);
      validatableObject.add(mockValidationRule3);
      //assert
      expect(
          () => validatableObject.isValid(throwException: true),
          throwsA(const TypeMatcher<ValidationException>()
              .having((e) => e.errorCode, 'error-code', equals('1'))));
      expect(validatableObject.errors.length, 3);
      expect(validatableObject.validations.length, 3);
      expect(validatableObject.value, _value); // verify value not changed
    });

    test('expected Fist Exception if only one Object rule NOT passed', () {
      //aggregate
      final mockValidationRule2 = MockValidationRule<String>();
      final mockValidationRule3 = MockValidationRule<String>();

      when(mockValidationRule.check(validatableObject.value)).thenReturn(true);
      when(mockValidationRule.validationException).thenReturn(
          ValidationException(validationMessage: 'Not Valid', errorCode: '1'));

      when(mockValidationRule2.check(validatableObject.value))
          .thenReturn(false);
      when(mockValidationRule2.validationException).thenReturn(
          ValidationException(validationMessage: 'Not Valid', errorCode: '2'));

      when(mockValidationRule3.check(validatableObject.value))
          .thenReturn(false);
      when(mockValidationRule3.validationException).thenReturn(
          ValidationException(validationMessage: 'Not Valid', errorCode: '3'));
      //act
      validatableObject.add(mockValidationRule);
      validatableObject.add(mockValidationRule2);
      validatableObject.add(mockValidationRule3);
      //assert
      expect(
          () => validatableObject.isValid(throwException: true),
          throwsA(const TypeMatcher<ValidationException>()
              .having((e) => e.errorCode, 'error-code', equals('2'))));
      expect(validatableObject.errors.length, 2);
      expect(validatableObject.validations.length, 3);
      expect(validatableObject.value, _value); // verify value not changed
    });

    test('expected Empty Validations if Object rule is cleared', () {
      //aggregate
      final mockValidationRule2 = MockValidationRule<String>();
      final mockValidationRule3 = MockValidationRule<String>();

      //act
      validatableObject.add(mockValidationRule);
      validatableObject.add(mockValidationRule2);
      validatableObject.add(mockValidationRule3);

      validatableObject.clear();
      //assert
      expect(validatableObject.isValid(throwException: true), true);
      expect(validatableObject.errors.length, 0);
      expect(validatableObject.validations.length, 0);
      expect(validatableObject.value, _value); // verify value not changed
    });
  });
}
