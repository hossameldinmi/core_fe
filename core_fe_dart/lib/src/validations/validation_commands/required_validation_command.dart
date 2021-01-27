import 'package:core_fe_dart/validations.dart';
import 'package:meta/meta.dart';

class RequiredValidationCommand<T> extends ValidationCommandBase<T> {
  RequiredValidationCommand(ValidatorObject<T> validatorObject,
      {@required String validationMessage, bool autoExcute = false})
      : super(
            validatorObject: validatorObject,
            autoExcute: autoExcute,
            excuteCallBack: () {
              validatorObject.clear();

              validatorObject.add(
                IsNotNullEmptyWhitespaceRule<T>.fromMessage(
                    validationMessage: validationMessage),
              );
            });
}
