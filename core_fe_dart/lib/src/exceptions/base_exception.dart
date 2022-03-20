class BaseException implements Exception {
  BaseException({this.errorCode});

  final int? errorCode;
}
