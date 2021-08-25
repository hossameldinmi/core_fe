import 'package:core_fe_dart/exceptions.dart';

abstract class DomainException extends BaseException {
  DomainException({required int? errorCode}) : super(errorCode: errorCode);
}
