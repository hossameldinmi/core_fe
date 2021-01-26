import 'package:core_fe_infrastructure/src/models/base_request.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart';
import 'package:flutter/foundation.dart';
import 'package:core_fe_infrastructure/src/models/base_response.dart';

abstract class IHttpNetworkManager {
  Future<BaseResponse<TResponse>> get<TResponse>(
      {@required GetRequest request, @required RequestOptions options});

  Future<BaseResponse<TResponse>> post<TResponse>(
      {@required PostRequest request, @required RequestOptions options});

  Future<BaseResponse<TResponse>> postFile<TResponse>(
      {@required PostFileRequest request, @required RequestOptions options});

  Future<BaseResponse<TResponse>> put<TResponse>(
      {@required PutRequest request, @required RequestOptions options});

  Future<BaseResponse<TResponse>> delete<TResponse>(
      {@required DeleteRequest request, @required RequestOptions options});
  Future<BaseResponse<TResponse>> downloadFile<TResponse>(
      {@required DownloadFileRequest request,
      @required RequestOptions options});
}

abstract class NetworkProvider {
  Future<HttpResponse<TResponse>> get<TResponse>(
      {@required GetRequest request, @required RequestOptions options});

  Future<HttpResponse<TResponse>> post<TResponse>(
      {@required PostRequest request, @required RequestOptions options});

  Future<HttpResponse<TResponse>> put<TResponse>(
      {@required PutRequest request, @required RequestOptions options});

  Future<HttpResponse<TResponse>> delete<TResponse>(
      {@required DeleteRequest request, @required RequestOptions options});

  Future<HttpResponse<TResponse>> postFile<TResponse>(
      {@required PostFileRequest request, @required RequestOptions options});

  Future<HttpResponse<TResponse>> downloadFile<TResponse>(
      {@required DownloadFileRequest request,
      @required RequestOptions options});
}

abstract class HttpHelper {
  Future<Map<String, dynamic>> getDefaultHeaders();
  BaseResponse<TResponse> resolveResponse<TResponse>(
      HttpResponse<TResponse> response);
  bool validateStatus(int statusCode);
  void handleException(HttpResponse response);
}
