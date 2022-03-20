import 'package:core_fe_dart/src/exceptions/domain_exception.dart';

class ValidationException extends DomainException {
  ValidationException({required this.validationMessage, int? errorCode})
      : super(errorCode: errorCode);

  final String? validationMessage;
}
