import 'dart:async';
import 'package:core_fe_infrastructure/src/interfaces/http_network.dart';
import 'package:core_fe_infrastructure/src/models/base_request.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart';
import 'package:core_fe_infrastructure/src/utils/dio_helper.dart';
import 'package:dio/dio.dart' hide RequestOptions;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';
import 'package:core_fe_infrastructure/models.dart';

class DioHttpProvider implements NetworkProvider {
  final Dio _dio;

  DioHttpProvider({Dio? dio}) : _dio = dio ?? _getHttpClientInstance();
  @override
  Future<HttpResponse<TResponse?>> get<TResponse>(
      {required GetRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions}) {
    return _request<TResponse>(
      requestOptions,
      responseOptions,
      (dioOptions) => _dio.get(request.url, queryParameters: request.queryParams, options: dioOptions),
    );
  }

  @override
  Future<HttpResponse<TResponse?>> post<TResponse>(
      {required PostRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions}) async {
    if (request is PostMediaRequest) {
      return postFile(request: request, requestOptions: requestOptions, responseOptions: responseOptions);
    }
    return _request<TResponse>(
      requestOptions,
      responseOptions,
      (dioOptions) => _dio.post(
        request.url,
        options: dioOptions,
        data: request.body,
      ),
    );
  }

  @override
  Future<HttpResponse<TResponse?>> put<TResponse>(
      {required PutRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions}) async {
    if (request is PutMediaRequest) {
      return _putWithMedia(request: request, requestOptions: requestOptions, responseOptions: responseOptions);
    }
    return _request<TResponse>(
      requestOptions,
      responseOptions,
      (dioOptions) =>
          _dio.put(request.url, options: dioOptions, data: request.body, queryParameters: request.queryParams),
    );
  }

  @override
  Future<HttpResponse<TResponse?>> delete<TResponse>(
      {required DeleteRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions}) async {
    return _request<TResponse>(
      requestOptions,
      responseOptions,
      (dioOptions) => _dio.delete(
        request.url,
        queryParameters: request.queryParams,
        options: dioOptions,
      ),
    );
  }

  @override
  Future<HttpResponse<TResponse?>> postFile<TResponse>(
      {required PostMediaRequest request,
      RequestOptions? requestOptions,
      ResponseOptions<TResponse>? responseOptions}) async {
    requestOptions ?? RequestOptions();
    return DioHelper.toValidFileObject(request.body).then(
      (tuple) => _request<TResponse>(
        requestOptions!.copyWith(length: tuple.item2),
        responseOptions!,
        (dioOptions) => _dio.post(
          request.url,
          data: tuple.item1,
          options: dioOptions,
        ),
      ),
    );
  }

  Future<HttpResponse<TResponse?>> _putWithMedia<TResponse>(
      {required PutMediaRequest request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions}) async {
    return DioHelper.toValidFileObject(request.body).then(
      (tuple) => _request<TResponse>(
        requestOptions.copyWith(length: tuple.item2),
        responseOptions,
        (dioOptions) => _dio.put(
          request.url,
          data: tuple.item1,
          queryParameters: request.queryParams,
          options: dioOptions,
        ),
      ),
    );
  }

  @override
  Future<HttpResponse<TResponse?>> downloadFile<TResponse>(
      {required DownloadFileRequest? request,
      required RequestOptions requestOptions,
      required ResponseOptions<TResponse> responseOptions}) async {
    return _request<TResponse?>(
        requestOptions,
        responseOptions,
        (dioOptions) => _dio.download(
              request!.url,
              request.savePath,
              options: dioOptions,
            ),
        resolver: (Response response) => DioHelper.toHttpResponse<TResponse>(response, null, request!.savePath));
  }

  static Dio _getHttpClientInstance() {
    var _dio = Dio();
    // add dio logger
    _dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          request: true,
          maxWidth: 90),
    );
    return _dio;
  }

  Future<HttpResponse<TResponse?>> _request<TResponse>(RequestOptions requestOptions,
      ResponseOptions<TResponse> responseOptions, Future<Response> Function(Options) request,
      {HttpResponse<TResponse> Function(Response)? resolver}) async {
    _preRequest();
    var dioOptions = DioHelper.toDioOptions(requestOptions, responseOptions);
    return request(dioOptions).catchError((error) {
      if (error is DioError) {
        return error.response!;
      } else {
        // print(error.toString());
      }
    }).then((response) {
      if (resolver != null) {
        return resolver(response);
      }
      return DioHelper.toHttpResponse<TResponse>(response, responseOptions.fromJson);
    }).whenComplete(_postRequest);
  }

  void _preRequest() {
    _dio.unlock();
  }

  void _postRequest() {
    _dio.lock();
  }
}
