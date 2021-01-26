import 'package:core_fe_dart/validations.dart';
import 'package:meta/meta.dart';

class RequiredValidationCommand<T> extends ValidationCommandBase<T> {
  RequiredValidationCommand(ValidatableObject<T> validatableObject,
      {@required String validationMessage, bool autoExcute = false})
      : super(
            validatableObject: validatableObject,
            autoExcute: autoExcute,
            excuteCallBack: () {
              validatableObject.clear();

              validatableObject.add(
                IsNotNullEmptyWhitespaceRule<T>.fromMessage(
                    validationMessage: validationMessage),
              );
            });
}
