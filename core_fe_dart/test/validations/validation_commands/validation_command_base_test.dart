import 'package:core_fe_dart/validations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/validations.dart';

class TestAutoExcuteValidationCommand extends ValidationCommandBase<String> {
  TestAutoExcuteValidationCommand(ValidatorObject<String>? validatorObject)
      : super(
            validatorObject: validatorObject,
            autoExcute: true,
            excuteCallBack: () {
              validatorObject!.clear();

              validatorObject.add(MockValidationRule<String>());

              validatorObject.add(MockValidationRule<String>());
            });
}

class TestValidationCommand extends ValidationCommandBase<String> {
  TestValidationCommand(ValidatorObject<String>? validatorObject)
      : super(
            validatorObject: validatorObject,
            excuteCallBack: () {
              validatorObject!.clear();

              validatorObject.add(MockValidationRule<String>());

              validatorObject.add(MockValidationRule<String>());
            });
}

void main() {
  group('Validation Command Base tests ', () {
    ValidationCommandBase<String> validationCommandBase;
    ValidatorObject<String>? validatorObject;
    setUp(() {
      validatorObject = ValidatorObject<String>('Test');
    });
    test('expected 2 validations after command intialized', () {
      validationCommandBase = TestAutoExcuteValidationCommand(validatorObject);

      expect(validatorObject!.validations.length, 2);

      validationCommandBase.excute();
      expect(validatorObject!.validations.length, 2);
    });

    test('expected [ZERO] validations after command intialized', () {
      validationCommandBase = TestValidationCommand(validatorObject);

      expect(validatorObject!.validations.length, 0);

      validationCommandBase.excute();
      expect(validatorObject!.validations.length, 2);
    });
  });
}
