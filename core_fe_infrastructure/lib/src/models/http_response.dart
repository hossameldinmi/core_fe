import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

/// Response describes the http Response info.
@immutable
class HttpResponse<T> extends Equatable {
  HttpResponse({
    @required this.data,
    @required this.statusCode,
    this.headers,
    // this.request,
    this.isRedirect = false,
    this.statusMessage,
    // this.redirects,
    Map<String, dynamic> extra,
  }) : extra = extra ?? {};

  /// Response body. may have been transformed, please refer to [ResponseType].
  final T data;

  /// Response headers.
  final Map<String, dynamic> headers;

  /// The corresponding request info.
  // RequestOptions request;

  /// Http status code.
  final int statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  final String statusMessage;

  /// Custom field that you can retrieve it later in `then`.
  final Map<String, dynamic> extra;

  /// Returns the series of redirects this connection has been through. The
  /// list will be empty if no redirects were followed. [redirects] will be
  /// updated both in the case of an automatic and a manual redirect.
  ///
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  // List<RedirectRecord> redirects;

  /// Whether this response is a redirect.
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  final bool isRedirect;

  /// Return the final real request uri (maybe redirect).
  ///
  /// ** Attention **: Whether this field is available depends on whether the
  /// implementation of the adapter supports it or not.
  // Uri get realUri => redirects.last?.location ?? request.uri;

  /// We are more concerned about `data` field.

  HttpResponse<TResponse> merge<TResponse>({
    TResponse data,
    int statusCode,
    Map<String, dynamic> headers,
    // this.request,
    bool isRedirect,
    String statusMessage,
    // this.redirects,
    Map<String, dynamic> extra,
  }) {
    return HttpResponse<TResponse>(
        data: data ?? this.data,
        statusCode: statusCode ?? this.statusCode,
        headers: headers ?? this.headers,
        isRedirect: isRedirect ?? this.isRedirect,
        extra: extra ?? this.extra,
        statusMessage: statusMessage ?? this.statusMessage);
  }

  @override
  List<Object> get props =>
      [data, statusCode, statusMessage, extra, isRedirect];
}

class Progress extends Equatable {
  final RequestStatus status;
  final double count;
  final double total;

  Progress({@required this.status, @required this.count, @required this.total});
  double get percentage => count / total * 100;

  @override
  List<Object> get props => [status, count, total];
}

enum RequestStatus {
  sending,
  recieving,
  complete,
}
