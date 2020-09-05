import 'package:core_fe_flutter/models.dart';
import 'package:core_fe_infrastructure/src/enums/response_type.dart';
import 'package:meta/meta.dart';

@immutable
class ResponseOptions<TResponse> {
  final ResponseType responseType;
  final FromJsonFunc<TResponse> fromJson;
  final bool Function(int) validateStatus;

  ResponseOptions({
    this.fromJson,
    this.validateStatus,
    this.responseType = ResponseType.json,
  });

  ResponseOptions<TResponse> merge({
    bool Function(int) validateStatus,
    FromJsonFunc<TResponse> fromJson,
    ResponseType responseType,
  }) =>
      ResponseOptions<TResponse>(
        fromJson: fromJson ?? this.fromJson,
        validateStatus: validateStatus ?? this.validateStatus,
        responseType: responseType ?? this.responseType,
      );
}
