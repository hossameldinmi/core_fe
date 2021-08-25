import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/validation_rule.dart';

class IsNotNullRule<T> extends ValidationRule<T> {
  IsNotNullRule({required this.validationException});
  IsNotNullRule.fromMessage({required String validationMessage, int? errorCode})
      : this(
            validationException: ValidationException(
                validationMessage: validationMessage, errorCode: errorCode));
  @override
  bool check(T value) {
    return value != null;
  }

  @override
  ValidationException? validationException;
}
