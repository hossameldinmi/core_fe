import 'package:core_fe_flutter/models.dart';
import 'package:core_fe_infrastructure/src/enums/response_type.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class ResponseOptions<TResponse> extends Equatable {
  final int? receiveTimeout;
  final ResponseType? responseType;
  final FromJsonFunc<TResponse>? fromJson;
  final bool Function(int?)? validateStatus;

  const ResponseOptions({
    this.receiveTimeout = 60000,
    this.fromJson,
    this.validateStatus,
    this.responseType = ResponseType.json,
  });

  ResponseOptions<TResponse> copyWith({
    int? receiveTimeout,
    ResponseType? responseType,
    FromJsonFunc<TResponse>? fromJson,
    bool Function(int?)? validateStatus,
  }) {
    return ResponseOptions<TResponse>(
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      responseType: responseType ?? this.responseType,
      fromJson: fromJson ?? this.fromJson,
      validateStatus: validateStatus ?? this.validateStatus,
    );
  }

  ResponseOptions<TResponse> mergeWith({
    int receiveTimeout = 60000,
    ResponseType responseType = ResponseType.json,
    FromJsonFunc<TResponse>? fromJson,
    bool Function(int?)? validateStatus,
  }) {
    return ResponseOptions<TResponse>(
      receiveTimeout: this.receiveTimeout ?? receiveTimeout,
      responseType: this.responseType ?? responseType,
      fromJson: this.fromJson ?? fromJson,
      validateStatus: this.validateStatus ?? validateStatus,
    );
  }

  @override
  List<Object?> get props => [receiveTimeout, responseType, fromJson, validateStatus];
}
