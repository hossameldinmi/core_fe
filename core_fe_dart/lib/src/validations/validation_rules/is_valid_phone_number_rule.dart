import 'package:core_fe_dart/exceptions.dart';
import 'package:core_fe_dart/validations.dart';
import 'package:meta/meta.dart';

class IsValidPhoneNumberRule implements ValidationRule<String> {
  IsValidPhoneNumberRule({@required this.validationException});
  IsValidPhoneNumberRule.fromMessage(
      {@required String validationMessage, int errorCode})
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
