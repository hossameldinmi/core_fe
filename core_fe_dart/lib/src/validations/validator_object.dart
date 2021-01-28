import 'dart:collection';
import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/validation_rule.dart';

class ValidatorObject<T> {
  ValidatorObject([this._value]);

  final List<ValidationRule<T>> _validations = <ValidationRule<T>>[];
  UnmodifiableListView<ValidationRule<T>> get validations =>
      UnmodifiableListView<ValidationRule<T>>(_validations);

  List<ValidationException> _errors;
  UnmodifiableListView<ValidationException> get errors =>
      UnmodifiableListView<ValidationException>(_errors);

  T _value;
  T get value => _value;
  set value(T value) => _value = value;

  bool isValid({bool throwException = false}) {
    _errors?.clear();
    _errors = validations
        .where((v) => !v.check(value))
        .map((v) => v.validationException)
        .toList();
    if (throwException && _errors.isNotEmpty) {
      throw _errors.first;
    }
    return errors?.isEmpty;
  }

  String get firstErrorMessage => errors.first?.validationMessage;

  // Add validation rule to the object
  void add<E extends T>(ValidationRule<T> rule) {
    _validations.add(rule);
  }

  void clear() {
    _errors?.clear();
    _validations.clear();
  }
}
