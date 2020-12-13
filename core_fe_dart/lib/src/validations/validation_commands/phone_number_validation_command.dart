import 'package:core_fe_dart/src/validations/validatable_object.dart';
import 'package:core_fe_dart/src/validations/validation_command_base.dart';
import 'package:core_fe_dart/src/validations/validation_rules/is_not_null_empty_or_whitespace_rule.dart';
import 'package:core_fe_dart/src/validations/validation_rules/is_valid_phone_number_rule.dart';

class PhoneNumberValidationCommand extends ValidationCommandBase<String> {
  PhoneNumberValidationCommand(ValidatableObject<String> validatableObject)
      : super(
            validatableObject: validatableObject,
            excuteCallBack: () {
              validatableObject.clear();

              validatableObject.add(
                IsNotNullEmptyWhitespaceRule<String>.fromMessage(
                    validationMessage: 'Please Enter phone number'),
              );

              validatableObject.add(
                IsValidPhoneNumberRule.fromMessage(
                    validationMessage: 'Invalid phone number'),
              );
            });
}
