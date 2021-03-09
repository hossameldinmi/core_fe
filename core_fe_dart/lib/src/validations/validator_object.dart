import 'dart:collection';
import 'package:core_fe_dart/src/exceptions/validation_exception.dart';
import 'package:core_fe_dart/src/validations/validation_rule.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ValidatorObject<T> {
  // ValidatorObject([T value]) : _value = value;
  ValidatorObject([T value]) : _valueSubject = BehaviorSubject.seeded(value);
  final BehaviorSubject<T> _valueSubject;

  final List<ValidationRule<T>> _validations = <ValidationRule<T>>[];
  UnmodifiableListView<ValidationRule<T>> get validations =>
      UnmodifiableListView<ValidationRule<T>>(_validations);

  List<Tuple2<ValidationRule<T>, bool>> _validationResults;
  UnmodifiableListView<Tuple2<ValidationRule<T>, bool>> get validationResults =>
      UnmodifiableListView<Tuple2<ValidationRule<T>, bool>>(
          _validationResults ?? []);

  UnmodifiableListView<ValidationException> get errors =>
      UnmodifiableListView<ValidationException>(validationResults
          .where((vs) => !vs.item2)
          .map((vs) => vs.item1.validationException));

  T get value => _valueSubject.value;
  set value(T value) => _valueSubject.add(value);
  // T _value;
  // T get value => _value;
  // set value(T value) => _value = value;

  bool isValid({bool throwException = false}) {
    _validationResults?.clear();
    _validationResults =
        validations.map((v) => Tuple2(v, v.check(value))).toList();

    if (throwException && errors.isNotEmpty) {
      throw errors.first;
    }
    return errors?.isEmpty;
  }

  Stream<T> get onValueChanged => _valueSubject.stream;

  String get firstErrorMessage => errors.first?.validationMessage;

  // Add validation rule to the object
  void add<E extends T>(ValidationRule<T> rule) {
    assert(rule != null);
    _validations.add(rule);
  }

  void clear() {
    _validationResults?.clear();
    _validations.clear();
  }
}
