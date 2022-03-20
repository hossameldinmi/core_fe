import 'package:core_fe_dart/src/exceptions/domain_exception.dart';

import '../../exceptions.dart';

abstract class DomainExceptionsHandler {
  Future<void> handleDomainException(DomainException error);
}
