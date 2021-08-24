import 'package:core_fe_dart/exceptions.dart';
import 'package:core_fe_dart/validations.dart';
import 'package:meta/meta.dart';

class IsValidPriceRule implements ValidationRule<String> {
  final IsRegexMatchedRule regexRule;
  IsValidPriceRule({@required this.validationException})
      : regexRule = IsRegexMatchedRule(
            validationException: validationException,
            pattern: r'^\d{0,}(\.\d{1,})?$');
  IsValidPriceRule.fromMessage(
      {@required String validationMessage, int errorCode})
      : this(
            validationException: ValidationException(
                validationMessage: validationMessage, errorCode: errorCode));
  @override
  bool check(String value) => regexRule.check(value ?? '');
  @override
  ValidationException validationException;
}
