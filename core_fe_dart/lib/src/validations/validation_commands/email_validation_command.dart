import 'package:core_fe_dart/src/validations/validation_rules/is_valid_email_rule.dart';
import 'package:core_fe_dart/validations.dart';
import 'package:flutter/foundation.dart';

class EmailValidationCommand extends ValidationCommandBase<String> {
  EmailValidationCommand(
    ValidatorObject<String> validatorObject, {
    @required String requiredMessage,
    @required String emailInvalidMessage,
    bool isRequired = true,
  }) : super(
            validatorObject: validatorObject,
            excuteCallBack: () {
              validatorObject.clear();
              if (isRequired) {
                validatorObject.add(
                  IsNotNullEmptyWhitespaceRule<String>.fromMessage(
                      validationMessage: requiredMessage),
                );
              }

              validatorObject.add(
                IsValidEmailRule.fromMessage(
                    validationMessage: emailInvalidMessage),
              );
            });
}
