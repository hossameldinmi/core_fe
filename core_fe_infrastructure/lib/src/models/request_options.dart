import 'dart:io';
import 'package:core_fe_infrastructure/src/enums/response_type.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class RequestOptions extends Equatable {
  final ResponseType responseType;
  final Map<String, dynamic> headers; // headers
  final ContentType contentType;
  final int receiveTimeout;
  final bool Function(int) validateStatus;
  final int sendTimeout;
  final int length;

  RequestOptions({
    this.headers,
    ContentType contentType,
    this.receiveTimeout,
    this.sendTimeout,
    this.validateStatus,
    this.length,
    this.responseType = ResponseType.json,
  }) : contentType = contentType ?? ContentType.json;

  RequestOptions copyWith({
    Map<String, dynamic> headers,
    ContentType contentType,
    int receiveTimeout,
    int sendTimeout,
    bool Function(int) validateStatus,
    int length,
    ResponseType responseType,
  }) {
    return RequestOptions(
      contentType: contentType ?? this.contentType,
      headers: headers ?? this.headers,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      validateStatus: validateStatus ?? this.validateStatus,
      length: length ?? this.length,
      responseType: responseType ?? this.responseType,
    );
  }

  @override
  List<Object> get props => [
        responseType,
        headers,
        contentType,
        receiveTimeout,
        validateStatus,
        sendTimeout,
        length
      ];
}
