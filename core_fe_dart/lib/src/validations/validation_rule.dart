import 'package:core_fe_dart/src/exceptions/validation_exception.dart';

abstract class ValidationRule<T> implements ValidationRuleBase {
  bool check(T value);
}

abstract class ValidationRuleBase {
  ValidationException validationException;
}
