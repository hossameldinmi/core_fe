import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/validation_rule.dart';

class IsRegexMatchedRule implements ValidationRule<String> {
  IsRegexMatchedRule(
      {required this.validationException, required String pattern})
      : _pattern = pattern;

  IsRegexMatchedRule.fromMessage(
      {required String validationMessage,
      required String pattern,
      int? errorCode})
      : this(
          validationException: ValidationException(
              validationMessage: validationMessage, errorCode: errorCode),
          pattern: pattern,
        );
  @override
  bool check(String value) {
    try {
      return RegExp(_pattern).hasMatch(value);
    } catch (e) {
      return false;
    }
  }

  final String _pattern;
  @override
  ValidationException? validationException;
}
