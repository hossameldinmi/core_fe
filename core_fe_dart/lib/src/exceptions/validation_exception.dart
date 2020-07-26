import 'package:core_fe_dart/src/exceptions/base_exception.dart';
import 'package:meta/meta.dart';

class ValidationException extends BaseException {
  ValidationException({@required this.validationMessage, String errorCode})
      : super(errorCode: errorCode);

  final String validationMessage;
}
