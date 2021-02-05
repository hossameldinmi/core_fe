import 'package:core_fe_dart/validations.dart';
import 'package:mockito/mockito.dart';

class MockValidationRule<T> extends Mock with ValidationRule<T> {}

class MockValidatorObject<T> extends Mock implements ValidatorObject<T> {}

class MockValidationCommand<T> extends Mock
    implements ValidationCommandBase<T> {}
