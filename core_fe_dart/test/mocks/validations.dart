import 'package:core_fe_dart/validations.dart';
import 'package:mockito/mockito.dart';

class MockValidationRule<T> extends Mock with ValidationRule<T> {}
class MockValidatableObject<T> extends Mock implements ValidatableObject<T> {}
class MockValidationCommand<T> extends Mock implements ValidationCommandBase<T> {}
