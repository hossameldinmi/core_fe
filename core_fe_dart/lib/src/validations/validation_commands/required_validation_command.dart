import 'package:core_fe_dart/validations.dart';
import 'package:meta/meta.dart';

class RequiredValidationCommand<T> extends ValidationCommandBase<T> {
  RequiredValidationCommand(
      Iterable<ValidatableObject<T>> validatableObjectList,
      {@required String validationMessage,
      bool isAutoExcute = false})
      : super(
            validatableObjectList: validatableObjectList,
            isAutoExcute: isAutoExcute,
            excuteCallBack: (v) {
              v.clear();

              v.add(
                IsNotNullEmptyWhitespaceRule<T>.fromMessage(
                    validationMessage: validationMessage),
              );
            });
}
