import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/_export.dart';
import 'package:meta/meta.dart';

class IsNotNullRule<T> extends IValidationRule<T> {
  IsNotNullRule({@required this.validationException});
  IsNotNullRule.fromMessage(
      {@required String validationMessage, String errorCode})
      : this(
            validationException: ValidationException(
                validationMessage: validationMessage, errorCode: errorCode));
  @override
  bool check(T value) {
    return value != null;
  }

  @override
  ValidationException validationException;
}
