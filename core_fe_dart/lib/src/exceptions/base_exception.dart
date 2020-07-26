class BaseException implements Exception {
  BaseException({this.errorCode});

  final String errorCode;
}
