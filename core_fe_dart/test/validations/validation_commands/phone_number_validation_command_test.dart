import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Is Valid Phone Number Validation Command', () {
    PhoneNumberValidationCommand phoneNumberValidationCommand;
    ValidatorObject<String>? validatorObject;
    setUp(() {});

    void intializeValidatorObject(String stringNumber) {
      validatorObject = ValidatorObject<String>(stringNumber);
      phoneNumberValidationCommand = PhoneNumberValidationCommand(
        validatorObject,
        requiredMessage: '',
        formatValidationMessage: '',
      );

      phoneNumberValidationCommand.excute();
    }

    test('expected true if value is correct number', () {
      intializeValidatorObject('01222332222');
      expect(validatorObject!.isValid(), true);
    });

    test('expected false if value is not number', () {
      intializeValidatorObject('test');

      expect(validatorObject!.isValid(), false);
    });

    test('expected false if value is empty', () {
      intializeValidatorObject('');

      expect(validatorObject!.isValid(), false);
    });

    test('expected false if value is whitespace', () {
      intializeValidatorObject('   ');
      expect(validatorObject!.isValid(), false);
    });

    test('expected false if value is random number', () {
      intializeValidatorObject('1223');
      expect(validatorObject!.isValid(), false);
    });

    test('expected false if value is short number', () {
      intializeValidatorObject('0122');

      expect(validatorObject!.isValid(), false);
    });
  });
}
