import 'package:core_fe_dart/src/exceptions/validation_exception.dart';

import 'package:core_fe_dart/extensions.dart';
import '../validation_rule.dart';

class IsNotNullEmptyWhitespaceRule<T> implements ValidationRule<T> {
  IsNotNullEmptyWhitespaceRule({required this.validationException});
  IsNotNullEmptyWhitespaceRule.fromMessage(
      {required String? validationMessage, int? errorCode})
      : this(
            validationException: ValidationException(
                validationMessage: validationMessage, errorCode: errorCode));
  @override
  bool check(T value) => !value.isNullEmptyOrWhitespace();

  @override
  ValidationException? validationException;
}
