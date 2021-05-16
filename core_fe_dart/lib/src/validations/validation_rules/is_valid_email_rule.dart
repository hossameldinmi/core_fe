import 'package:core_fe_dart/exceptions.dart';
import 'package:core_fe_dart/validations.dart';
import 'package:meta/meta.dart';
import 'package:string_validator/string_validator.dart';

class IsValidEmailRule implements ValidationRule<String> {
  IsValidEmailRule({@required this.validationException});
  IsValidEmailRule.fromMessage(
      {@required String validationMessage, int errorCode})
      : this(
            validationException: ValidationException(
                validationMessage: validationMessage, errorCode: errorCode));
  @override
  bool check(String value) => isEmail(value ?? '');
  @override
  ValidationException validationException;
}
