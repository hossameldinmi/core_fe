import 'package:core_fe_infrastructure/models.dart';

abstract class IHttpNetworkManager {
  Future<BaseResponse<TResponse?>> get<TResponse>(
      {required GetRequest request, RequestOptions? requestOptions, ResponseOptions<TResponse>? responseOptions});

  Future<BaseResponse<TResponse?>> post<TResponse>(
      {required PostRequest request, RequestOptions? requestOptions, ResponseOptions<TResponse>? responseOptions});

  Future<BaseResponse<TResponse?>> postFile<TResponse>(
      {required PostMediaRequest request, RequestOptions? requestOptions, ResponseOptions<TResponse>? responseOptions});

  Future<BaseResponse<TResponse?>> put<TResponse>(
      {required PutRequest request, RequestOptions? requestOptions, ResponseOptions<TResponse>? responseOptions});

  Future<BaseResponse<TResponse?>> delete<TResponse>(
      {required DeleteRequest request, RequestOptions? requestOptions, ResponseOptions<TResponse>? responseOptions});

  Future<BaseResponse<TResponse?>> downloadFile<TResponse>(
      {required DownloadFileRequest request,
      RequestOptions? requestOptions,
      ResponseOptions<TResponse>? responseOptions});
}

abstract class NetworkProvider {
  Future<HttpResponse<TResponse?>> get<TResponse>(
      {required GetRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions});

  Future<HttpResponse<TResponse?>> post<TResponse>(
      {required PostRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions});

  Future<HttpResponse<TResponse?>> put<TResponse>(
      {required PutRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions});

  Future<HttpResponse<TResponse?>> delete<TResponse>(
      {required DeleteRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions});

  Future<HttpResponse<TResponse?>> postFile<TResponse>(
      {required PostMediaRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions});

  Future<HttpResponse<TResponse?>> downloadFile<TResponse>(
      {required DownloadFileRequest? request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions});
}

abstract class HttpHelper {
  Future<Map<String, dynamic>?> getDefaultHeaders();
  BaseResponse<TResponse?> resolveResponse<TResponse>(HttpResponse<TResponse?> response);
  bool validateStatus(int? statusCode);
  void handleException(HttpResponse response);
}
