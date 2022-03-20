import 'package:core_fe_dart/src/exceptions/base_exception.dart';

abstract class OperationException extends BaseException {
  OperationException({required int errorCode}) : super(errorCode: errorCode);
}
