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
class PutRequest extends BaseRequest {
  final Map<String, dynamic>? queryParams;
  final dynamic body;
  PutRequest({required String url, required this.body, this.queryParams})
      : super(url);

  @override
  List<Object?> get props => [super.url, body, queryParams];
}

@immutable
class DeleteRequest extends BaseRequest {
  final Map<String, dynamic>? queryParams;
  DeleteRequest({required String url, this.queryParams}) : super(url);

  @override
  List<Object?> get props => [super.url, queryParams];
}

@immutable
class PostFileRequest extends BaseRequest {
  final dynamic data;
  final Map<String, dynamic>? queryParams;
  final int? length;
  PostFileRequest(
      {required String url,
      required this.data,
      this.queryParams,
      this.length})
      : assert(!(data as Object).isNullEmptyOrWhitespace()),
        super(url);

  @override
  List<Object?> get props => [super.url, data, queryParams, length];
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
