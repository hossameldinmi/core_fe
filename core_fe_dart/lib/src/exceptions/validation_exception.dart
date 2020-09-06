import 'package:meta/meta.dart';
import 'base_exception.dart';

class ValidationException extends BaseException {
  ValidationException({@required this.validationMessage, int errorCode})
      : super(errorCode: errorCode);

  final String validationMessage;
}
