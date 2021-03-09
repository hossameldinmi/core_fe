import 'package:core_fe_dart/exceptions.dart';
import 'package:core_fe_dart/validations.dart';
import 'package:mockito/mockito.dart';

class MockValidationRule<T> extends Mock with ValidationRule<T> {}

class FakeValidationRule<T> implements ValidationRule<T> {
  FakeValidationRule(bool result, this.validationException) : _check = result;
  final bool _check;
  @override
  ValidationException validationException;

  @override
  bool check(T value) => _check;
}

class MockValidatorObject<T> extends Mock implements ValidatorObject<T> {}

class MockValidationCommand<T> extends Mock
    implements ValidationCommandBase<T> {}
