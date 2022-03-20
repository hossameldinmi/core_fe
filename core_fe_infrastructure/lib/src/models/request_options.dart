import 'dart:io';
import 'package:core_fe_infrastructure/src/enums/response_type.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class RequestOptions extends Equatable {
  final Map<String, dynamic>? headers; // headers
  final ContentType contentType;
  final int? sendTimeout;
  final int? length;

  RequestOptions({
    this.headers,
    ContentType? contentType,
    this.sendTimeout,
    this.length,
  }) : contentType = contentType ?? ContentType.json;

  RequestOptions copyWith({
    Map<String, dynamic>? headers,
    ContentType? contentType,
    int? receiveTimeout,
    int? sendTimeout,
    bool Function(int)? validateStatus,
    int? length,
    ResponseType? responseType,
  }) {
    return RequestOptions(
      contentType: contentType ?? this.contentType,
      headers: headers ?? this.headers,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      length: length ?? this.length,
    );
  }

  @override
  List<Object?> get props => [headers, contentType, sendTimeout, length];
}
