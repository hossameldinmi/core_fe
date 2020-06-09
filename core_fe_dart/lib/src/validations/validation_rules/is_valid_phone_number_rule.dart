import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/_export.dart';
import 'package:core_fe_dart/src/validations/validation_rules/_export.dart';
import 'package:meta/meta.dart';

class IsValidPhoneNumberRule implements IValidationRule<String> {
  IsValidPhoneNumberRule({@required this.validationException});
  IsValidPhoneNumberRule.fromMessage(
      {@required String validationMessage, String errorCode})
      : this(
            validationException: ValidationException(
                validationMessage: validationMessage, errorCode: errorCode));
  @override
  bool check(String value) => IsRegexMatchedRule(
          validationException: validationException,
          pattern: '^01([0,2]|5){1}[0-9]{8}')
      .check(value);
  @override
  ValidationException validationException;
}
