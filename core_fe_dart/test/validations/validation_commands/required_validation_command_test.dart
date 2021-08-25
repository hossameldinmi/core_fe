import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Required Validation Command', () {
    RequiredValidationCommand<String?> requiredValidationCommand;
    late ValidatorObject<String?> validatorObject;

    void intilizeValidatorObject(String? input) {
      validatorObject = ValidatorObject<String?>(input);
      requiredValidationCommand = RequiredValidationCommand<String?>(validatorObject, requiredMessage: '');
      requiredValidationCommand.excute();
    }

    test('expected true if value is correct number', () {
      intilizeValidatorObject('01222332222');
      expect(validatorObject.isValid(), true);
    });

    test('expected false if value is not number', () {
      intilizeValidatorObject(null);

      expect(validatorObject.isValid(), false);
    });

    test('expected false if value is empty', () {
      intilizeValidatorObject('');
      expect(validatorObject.isValid(), false);
    });

    test('expected false if value is whitespace', () {
      intilizeValidatorObject('   ');
      expect(validatorObject.isValid(), false);
    });
  });
}
