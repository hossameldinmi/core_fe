import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Required Validation Command', () {
    RequiredValidationCommand<String> requiredValidationCommand;
    ValidatableObject<String> validatableObject;

    void intilizeValidatableObject(String input) {
      validatableObject = ValidatableObject<String>(input);
      requiredValidationCommand = RequiredValidationCommand<String>(
          [validatableObject],
          validationMessage: '');
      requiredValidationCommand.excute();
    }

    test('expected true if value is correct number', () {
      intilizeValidatableObject('01222332222');
      expect(validatableObject.isValid(), true);
    });

    test('expected false if value is not number', () {
      intilizeValidatableObject(null);

      expect(validatableObject.isValid(), false);
    });

    test('expected false if value is empty', () {
      intilizeValidatableObject('');
      expect(validatableObject.isValid(), false);
    });

    test('expected false if value is whitespace', () {
      intilizeValidatableObject('   ');
      expect(validatableObject.isValid(), false);
    });
  });
}
