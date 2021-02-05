import 'package:core_fe_dart/exceptions.dart';
import 'package:flutter/foundation.dart';

abstract class DomainException extends BaseException {
  DomainException({@required int errorCode}) : super(errorCode: errorCode);
}
