import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/validations.dart';

class TestAutoExcuteValidationCommand extends ValidationCommandBase<String> {
  TestAutoExcuteValidationCommand(ValidatableObject<String> validatableObject)
      : super(
            validatableObject: validatableObject,
            autoExcute: true,
            excuteCallBack: () {
              validatableObject.clear();

              validatableObject.add(MockValidationRule<String>());

              validatableObject.add(MockValidationRule<String>());
            });
}

class TestValidationCommand extends ValidationCommandBase<String> {
  TestValidationCommand(ValidatableObject<String> validatableObject)
      : super(
            validatableObject: validatableObject,
            excuteCallBack: () {
              validatableObject.clear();

              validatableObject.add(MockValidationRule<String>());

              validatableObject.add(MockValidationRule<String>());
            });
}

void main() {
  group('Validation Command Base tests ', () {
    ValidationCommandBase<String> validationCommandBase;
    ValidatableObject<String> validatableObject;
    setUp(() {
      validatableObject = ValidatableObject<String>('Test');
    });
    test('expected 2 validations after command intialized', () {
      validationCommandBase =
          TestAutoExcuteValidationCommand(validatableObject);

      expect(validatableObject.validations.length, 2);

      validationCommandBase.excute();
      expect(validatableObject.validations.length, 2);
    });

    test('expected [ZERO] validations after command intialized', () {
      validationCommandBase = TestValidationCommand(validatableObject);

      expect(validatableObject.validations.length, 0);

      validationCommandBase.excute();
      expect(validatableObject.validations.length, 2);
    });
  });
}
