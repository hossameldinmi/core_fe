import 'package:core_fe_dart/src/validations/validation_rules/is_valid_price_rule.dart';
import 'package:core_fe_dart/validations.dart';

class PriceValidationCommand extends ValidationCommandBase<String> {
  PriceValidationCommand(
    ValidatorObject<String> validatorObject, {
    required String requiredMessage,
    required String priceInvalidMessage,
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
                IsValidPriceRule.fromMessage(
                    validationMessage: priceInvalidMessage),
              );
            });
}
