import 'dart:collection';

import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/i_validation.dart';

class ValidatableObject<T> {
  ValidatableObject(T value)
      : _value = value,
        _errors = <ValidationException>[],
        _validations = <IValidationRule<T>>[];

  List<IValidationRule<T>> _validations;
  UnmodifiableListView<IValidationRule<T>> get validations =>
      UnmodifiableListView<IValidationRule<T>>(_validations);

  List<ValidationException> _errors;
  UnmodifiableListView<ValidationException> get errors =>
      UnmodifiableListView<ValidationException>(_errors);

  T _value;
  T get value => _value;
  set value(T value) => _value = value;

  bool isValid({bool throwException = false}) {
    _errors.clear();
    _errors = validations
        .where((v) => !v.check(value))
        .map((v) => v.validationException)
        .toList();
    if (throwException && _errors.isNotEmpty) {
      throw _errors.first;
    }
    return errors.isEmpty;
  }

  // Add validation rule to the object
  void add<E extends T>(IValidationRule<T> rule) {
    _validations.add(rule);
  }

  void clear() {
    _errors = <ValidationException>[];
    _validations = <IValidationRule<T>>[];
  }
}
