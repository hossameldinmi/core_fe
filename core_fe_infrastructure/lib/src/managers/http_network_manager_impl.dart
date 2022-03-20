import 'package:core_fe_infrastructure/src/exceptions/network_exceptions.dart';
import 'package:core_fe_infrastructure/src/interfaces/connectivity.dart';
import 'package:core_fe_infrastructure/src/interfaces/http_network.dart';
import 'package:flutter/foundation.dart';
import 'package:core_fe_infrastructure/src/constants/error_code.dart';
import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/utils.dart';
import 'package:core_fe_infrastructure/enums.dart';
import 'dart:io';

class HttpNetworkManagerImpl implements IHttpNetworkManager {
  final NetworkProvider _networkProvider;
  final HttpHelper _httpHelper;
  final Connectivity _connectivity;
  HttpNetworkManagerImpl(this._networkProvider, this._httpHelper, this._connectivity);

  @override
  Future<BaseResponse<TResponse?>> get<TResponse>({
    required GetRequest request,
    RequestOptions? requestOptions,
    ResponseOptions<TResponse>? responseOptions,
  }) {
    return _request<TResponse>(
      requestOptions,
      (updatedOptions) => _networkProvider.get<TResponse>(
          request: request, requestOptions: updatedOptions, responseOptions: updateResponseOptions(responseOptions)),
    );
  }

  @override
  Future<BaseResponse<TResponse?>> post<TResponse>({
    required PostRequest request,
    RequestOptions? requestOptions,
    ResponseOptions<TResponse>? responseOptions,
  }) {
    return _request<TResponse>(
      requestOptions,
      (updatedOptions) => _networkProvider.post<TResponse>(
          request: request, requestOptions: updatedOptions, responseOptions: updateResponseOptions(responseOptions)),
    );
  }

  @override
  Future<BaseResponse<TResponse?>> postFile<TResponse>({
    required PostMediaRequest request,
    RequestOptions? requestOptions,
    ResponseOptions<TResponse>? responseOptions,
  }) {
    return _request<TResponse>(
      requestOptions,
      (updatedOptions) => _networkProvider.postFile<TResponse>(
        request: request,
        requestOptions: updatedOptions,
        responseOptions: updateResponseOptions(responseOptions),
      ),
    );
  }

  @override
  Future<BaseResponse<TResponse?>> put<TResponse>({
    required PutRequest request,
    RequestOptions? requestOptions,
    ResponseOptions<TResponse>? responseOptions,
  }) {
    return _request<TResponse>(
      requestOptions,
      (updatedOptions) => _networkProvider.put<TResponse>(
        request: request,
        requestOptions: updatedOptions,
        responseOptions: updateResponseOptions(responseOptions),
      ),
    );
  }

  @override
  Future<BaseResponse<TResponse?>> delete<TResponse>({
    required DeleteRequest request,
    RequestOptions? requestOptions,
    ResponseOptions<TResponse>? responseOptions,
  }) {
    return _request<TResponse>(
      requestOptions,
      (updatedOptions) => _networkProvider.delete<TResponse>(
        request: request,
        requestOptions: updatedOptions,
        responseOptions: updateResponseOptions(responseOptions),
      ),
    );
  }

  @override
  Future<BaseResponse<TResponse?>> downloadFile<TResponse>({
    DownloadFileRequest? request,
    RequestOptions? requestOptions,
    ResponseOptions<TResponse>? responseOptions,
  }) {
    return _request<TResponse>(
      requestOptions,
      (updatedOptions) => _networkProvider.downloadFile<TResponse>(
        request: request,
        requestOptions: updatedOptions,
        responseOptions: updateResponseOptions(responseOptions),
      ),
    );
  }

  Future<BaseResponse<TResponse?>> _request<TResponse>(
      RequestOptions? requestOptions, Future<HttpResponse<TResponse?>> Function(RequestOptions) request) {
    return _checkConnection()
        .then((value) => updateRequestOptions(requestOptions))
        .then(request)
        .then(_httpHelper.resolveResponse);
  }

  Future<void> _checkConnection() {
    return _connectivity.isConnected().then(
          (isConnected) =>
              isConnected ? Future.value() : throw ConnectionException(errorCode: ErrorCode.noInternetError),
        );
  }

  @visibleForTesting
  Future<RequestOptions> updateRequestOptions(RequestOptions? requestOptions) {
    requestOptions ??= RequestOptions(contentType: ContentType.json);
    var headers = <String, dynamic>{};
    return _httpHelper.getDefaultHeaders().then((defaultHeaders) {
      // append default headers
      headers.addAll(defaultHeaders ?? {});
      // append requestOptions headers, existing keys will be ovveriden
      headers.addAll(requestOptions!.headers ?? {});
      return requestOptions.copyWith(
        headers: headers,
      );
    });
  }

  @visibleForTesting
  ResponseOptions<TResponse> updateResponseOptions<TResponse>(ResponseOptions<TResponse>? responseOptions) {
    responseOptions ??= ResponseOptions<TResponse>();
    return responseOptions.mergeWith(
      fromJson: responseOptions.fromJson == null && TResponse.toString() != 'void'
          ? JsonUtil.getType<TResponse>().fromJson
          : null,
      responseType: ResponseType.json,
      validateStatus: _httpHelper.validateStatus,
      receiveTimeout: 60000,
    );
  }
}
