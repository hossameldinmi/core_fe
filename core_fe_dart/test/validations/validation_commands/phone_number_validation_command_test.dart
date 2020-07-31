import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Is Valid Phone Number Validation Command', () {
    PhoneNumberValidationCommand phoneNumberValidationCommand;
    ValidatableObject<String> validatableObject;
    setUp(() {});

    void intializeValidatableObject(String stringNumber) {
      validatableObject = ValidatableObject<String>(stringNumber);
      phoneNumberValidationCommand =
          PhoneNumberValidationCommand([validatableObject]);

      phoneNumberValidationCommand.excute();
    }

    test('expected true if value is correct number', () {
      intializeValidatableObject('01222332222');
      expect(validatableObject.isValid(), true);
    });

    test('expected false if value is not number', () {
      intializeValidatableObject('test');

      expect(validatableObject.isValid(), false);
    });

    test('expected false if value is empty', () {
      intializeValidatableObject('');

      expect(validatableObject.isValid(), false);
    });

    test('expected false if value is whitespace', () {
      intializeValidatableObject('   ');
      expect(validatableObject.isValid(), false);
    });

    test('expected false if value is random number', () {
      intializeValidatableObject('1223');
      expect(validatableObject.isValid(), false);
    });

    test('expected false if value is short number', () {
      intializeValidatableObject('0122');

      expect(validatableObject.isValid(), false);
    });
  });
}
