import 'dart:collection';
import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/validation_rule.dart';
import 'package:rxdart/rxdart.dart';

class ValidatorObject<T> {
  // ValidatorObject([T value]) : _value = value;
  ValidatorObject([T value]) : _valueSubject = BehaviorSubject.seeded(value);
  final BehaviorSubject<T> _valueSubject;

  final List<ValidationRule<T>> _validations = <ValidationRule<T>>[];
  UnmodifiableListView<ValidationRule<T>> get validations =>
      UnmodifiableListView<ValidationRule<T>>(_validations);

  List<ValidationException> _errors;
  UnmodifiableListView<ValidationException> get errors =>
      UnmodifiableListView<ValidationException>(_errors);

  T get value => _valueSubject.value;
  set value(T value) => _valueSubject.add(value);
  // T _value;
  // T get value => _value;
  // set value(T value) => _value = value;

  bool isValid({bool throwException = false}) {
    _errors?.clear();
    _errors = validations
        .where((v) => !v.check(value))
        .map((v) => v.validationException)
        .toList();
    if (throwException && errors.isNotEmpty) {
      throw errors.first;
    }
    return errors?.isEmpty;
  }

  Stream<T> get onValueChanged => _valueSubject.stream;

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
