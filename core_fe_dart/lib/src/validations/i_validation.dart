import 'package:core_fe_dart/src/exceptions/validation_exception.dart';

abstract class IValidity {
  bool get isValid;
}

abstract class IValidationRule<T> implements IValidationException {
  bool check(T value);
}

abstract class IValidationException {
  ValidationException validationException;
}
