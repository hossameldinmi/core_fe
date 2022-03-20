import 'package:core_fe_dart/exceptions.dart';

abstract class BaseHttpException extends BaseException {
  final String? errorMessage;
  final String? errorDetails;
  BaseHttpException({required int? errorCode, this.errorMessage, this.errorDetails}) : super(errorCode: errorCode);
}

class ServerException extends BaseHttpException {
  ServerException({required int? errorCode, String? errorMessage, String? errorDetails})
      : super(errorCode: errorCode, errorMessage: errorMessage, errorDetails: errorDetails);
}

class ClientException extends BaseHttpException {
  ClientException({required int? errorCode, String? errorMessage, String? errorDetails})
      : super(errorCode: errorCode, errorMessage: errorMessage);
}

class ConnectionException extends BaseHttpException {
  ConnectionException({required int errorCode, String? errorMessage, String? errorDetails})
      : super(errorCode: errorCode, errorMessage: errorMessage, errorDetails: errorDetails);
}

class AuthorizationException extends BaseHttpException {
  AuthorizationException({required int? errorCode, String? errorMessage, String? errorDetails})
      : super(errorCode: errorCode, errorMessage: errorMessage, errorDetails: errorDetails);
}

class BusinessException extends BaseHttpException {
  BusinessException.fromResponse(
      {required int errorCode, this.businessErros, String? errorMessage, String? errorDetails})
      : super(errorCode: errorCode, errorMessage: errorMessage, errorDetails: errorDetails);
  final List<BaseHttpException>? businessErros;
}
