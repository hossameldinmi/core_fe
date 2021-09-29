import 'package:core_fe_infrastructure/src/models/http_response.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

@immutable
class BaseResponse<TResponse> extends Equatable {
  final TResponse data;
  final int? statusCode;
  final String? statusMessage;
  const BaseResponse(this.data, this.statusCode, this.statusMessage);

  BaseResponse.fromHttpResponse(HttpResponse<TResponse> response)
      : data = response.data,
        statusCode = response.statusCode,
        statusMessage = response.statusMessage;
  @override
  List<Object?> get props => [data, statusCode, statusMessage];
}
