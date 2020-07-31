import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/i_validation.dart';
import 'package:meta/meta.dart';

class IsRegexMatchedRule implements IValidationRule<String> {
  IsRegexMatchedRule(
      {@required this.validationException, @required String pattern})
      : _pattern = pattern;

  IsRegexMatchedRule.fromMessage(
      {@required String validationMessage,
      @required String pattern,
      String errorCode})
      : this(
          validationException: ValidationException(
              validationMessage: validationMessage, errorCode: errorCode),
          pattern: pattern,
        );
  @override
  bool check(String value) => RegExp(_pattern).hasMatch(value);

  final String _pattern;
  @override
  ValidationException validationException;
}
