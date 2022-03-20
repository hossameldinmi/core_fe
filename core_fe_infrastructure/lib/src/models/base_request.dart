import 'package:flutter/foundation.dart';
import 'package:core_fe_dart/extensions.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class BaseRequest extends Equatable {
  final String url; // action
  BaseRequest(this.url) : assert(!url.isNullEmptyOrWhitespace());
}

@immutable
class GetRequest extends BaseRequest {
  final Map<String, dynamic>? queryParams;
  GetRequest({required String url, this.queryParams}) : super(url);

  @override
  List<Object?> get props => [super.url, queryParams];
}

@immutable
class PostRequest extends BaseRequest {
  final dynamic body;
  PostRequest({required String url, required this.body}) : super(url);

  @override
  List<Object?> get props => [super.url, body];
}

@immutable
class PostMediaRequest extends PostRequest {
  final int? contentLength;
  PostMediaRequest({required String url, dynamic body, this.contentLength})
      : super(
          url: url,
          body: body,
        );

  @override
  List<Object?> get props => [super.url, super.body, contentLength];
}

@immutable
class PutRequest extends BaseRequest {
  final Map<String, dynamic>? queryParams;
  final dynamic body;
  PutRequest({required String url, required this.body, this.queryParams}) : super(url);

  @override
  List<Object?> get props => [super.url, body, queryParams];
}

@immutable
class PutMediaRequest extends PutRequest {
  final int? contentLength;
  PutMediaRequest({required String url, dynamic body, Map<String, dynamic>? queryParams, this.contentLength})
      : super(url: url, body: body, queryParams: queryParams);

  @override
  List<Object?> get props => [super.url, super.body, super.queryParams, contentLength];
}

@immutable
class DeleteRequest extends BaseRequest {
  final Map<String, dynamic>? queryParams;
  DeleteRequest({required String url, this.queryParams}) : super(url);

  @override
  List<Object?> get props => [super.url, queryParams];
}

@immutable
class DownloadFileRequest extends BaseRequest {
  final String savePath;
  DownloadFileRequest({required String url, required this.savePath})
      : assert(!savePath.isNullEmptyOrWhitespace()),
        super(url);

  @override
  List<Object> get props => [super.url, savePath];
}
