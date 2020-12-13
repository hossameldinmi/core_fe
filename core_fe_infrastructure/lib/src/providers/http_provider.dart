import 'dart:async';
import 'dart:io';
import 'package:core_fe_infrastructure/src/interfaces/rest_network.dart';
import 'package:core_fe_infrastructure/src/models/base_request.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart'
    as request_options;
import 'package:core_fe_infrastructure/src/utils/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';

class DioHttpProvider implements NetworkProvider {
  final Dio _dio;

  DioHttpProvider({Dio dio}) : _dio = dio ?? _getHttpClientInstance();
  @override
  Future<HttpResponse<TResponse>> get<TResponse>(
      {@required GetRequest request,
      @required request_options.RequestOptions options}) {
    return _request<TResponse>(
      options,
      (dioOptions) => _dio.get(request.url,
          queryParameters: request.queryParams, options: dioOptions),
    );
  }

  @override
  Future<HttpResponse<TResponse>> post<TResponse>(
      {@required PostRequest request,
      @required request_options.RequestOptions options}) async {
    return _request<TResponse>(
      options,
      (dioOptions) => _dio.post(
        request.url,
        options: dioOptions,
        data: request.body,
      ),
    );
  }

  @override
  Future<HttpResponse<TResponse>> put<TResponse>(
      {@required PutRequest request,
      @required request_options.RequestOptions options}) async {
    return _request<TResponse>(
      options,
      (dioOptions) => _dio.put(request.url,
          options: dioOptions,
          data: request.body,
          queryParameters: request.queryParams),
    );
  }

  @override
  Future<HttpResponse<TResponse>> delete<TResponse>(
      {@required DeleteRequest request,
      @required request_options.RequestOptions options}) async {
    return _request<TResponse>(
      options,
      (dioOptions) => _dio.delete(
        request.url,
        queryParameters: request.queryParams,
        options: dioOptions,
      ),
    );
  }

  @override
  Future<HttpResponse<TResponse>> postFile<TResponse>(
      {@required PostFileRequest request,
      @required request_options.RequestOptions options}) async {
    return DioHelper.toValidFileObject(request.data).then(
      (tuple) => _request<TResponse>(
        options.merge(length: tuple.item2),
        (dioOptions) => _dio.post(
          request.url,
          data: tuple.item1,
          queryParameters: request.queryParams,
          options: dioOptions,
        ),
      ),
    );
  }

  @override
  Future<HttpResponse<TResponse>> downloadFile<TResponse>(
      {@required DownloadFileRequest request,
      @required request_options.RequestOptions options}) async {
    return _request<TResponse>(
        options,
        (dioOptions) => _dio.download(
              request.url,
              request.savePath,
              // onReceiveProgress: (count, total) => print(
              //     'progress:${(count / total * 100).toStringAsFixed(2)}%'),
              options: dioOptions,
            ),
        resolver: (Response response) =>
            DioHelper.toHttpResponse<TResponse>(response, request.savePath));
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

  Future<HttpResponse<TResponse>> _request<TResponse>(
      request_options.RequestOptions options,
      Future<Response> Function(Options) request,
      {HttpResponse<TResponse> Function(Response) resolver}) async {
    _preRequest();
    var dioOptions = DioHelper.toDioOptions(options);
    return request(dioOptions).catchError((error) {
      if (error is DioError) {
        return error.response;
      } else {
        print(error.toString());
      }
    }).then((response) {
      if (resolver != null) {
        return resolver(response);
      }
      return DioHelper.toHttpResponse<TResponse>(response);
    }).whenComplete(_postRequest);
  }

  void _preRequest() {
    _dio.unlock();
  }

  void _postRequest() {
    _dio.lock();
  }
}
