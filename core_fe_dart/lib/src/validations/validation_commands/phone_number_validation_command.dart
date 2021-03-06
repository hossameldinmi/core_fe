import 'package:core_fe_dart/src/validations/validator_object.dart';
import 'package:core_fe_dart/src/validations/validation_command_base.dart';
import 'package:core_fe_dart/src/validations/validation_rules/is_not_null_empty_or_whitespace_rule.dart';
import 'package:core_fe_dart/src/validations/validation_rules/is_valid_phone_number_rule.dart';

class PhoneNumberValidationCommand extends ValidationCommandBase<String> {
  PhoneNumberValidationCommand(ValidatorObject<String> validatorObject,
      {String requiredMessage, String formatValidationMessage})
      : super(
            validatorObject: validatorObject,
            excuteCallBack: () {
              validatorObject.clear();

              validatorObject.add(
                IsNotNullEmptyWhitespaceRule<String>.fromMessage(
                    validationMessage: requiredMessage),
              );

              validatorObject.add(
                IsValidPhoneNumberRule.fromMessage(
                    validationMessage: formatValidationMessage),
              );
            });
}
