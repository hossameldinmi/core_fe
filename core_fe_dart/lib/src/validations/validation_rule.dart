import 'package:core_fe_dart/src/exceptions/validation_exception.dart';

abstract class ValidationRule<T> {
  bool check(T value);
  ValidationException validationException;
}
