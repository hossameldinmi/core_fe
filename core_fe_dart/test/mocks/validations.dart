import 'package:core_fe_dart/src/validations/_export.dart';
import 'package:mockito/mockito.dart';

class MockValidationRule<T> extends Mock with IValidationRule<T> {}
class MockValidatableObject<T> extends Mock implements ValidatableObject<T> {}
class MockValidationCommand<T> extends Mock implements ValidationCommandBase<T> {}
