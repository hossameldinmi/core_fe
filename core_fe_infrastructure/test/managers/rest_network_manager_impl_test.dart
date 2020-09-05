import 'dart:io';

import 'package:core_fe_infrastructure/src/constants/error_code.dart';
import 'package:core_fe_infrastructure/src/enums/response_type.dart';
import 'package:core_fe_infrastructure/src/exceptions/network_exceptions.dart';
import 'package:core_fe_infrastructure/src/managers/rest_network_manager_impl.dart';
import 'package:core_fe_infrastructure/src/models/base_request.dart';
import 'package:core_fe_infrastructure/src/models/base_response.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart';
import 'package:core_fe_infrastructure/src/utils/i_http_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocks.dart';
import 'package:matcher/matcher.dart';

import '../shared.dart';

void main() {
  final mockConnectivity = MockConnectivity();
  final mockNetwork = MockNetwork();
  final mockHttpHelper = MockHttpHelper();

  final networkManager =
      RestNetworkManagerImpl(mockNetwork, mockHttpHelper, mockConnectivity);
  final headers = {'h1': 'v1', 'h2': 'v2'};
  final defaultHeaders = {'dh1': 'dv1', 'dh2': 'dv2'};
  setUpAll(() {
    when(mockHttpHelper.getDefaultHeaders())
        .thenAnswer((realInvocation) => Future.value(defaultHeaders));
    when(mockConnectivity.isConnected())
        .thenAnswer((realInvocation) => Future.value(true));
  });
  test('Expected connection exception when no internet connection', () async {
    when(mockConnectivity.isConnected())
        .thenAnswer((realInvocation) => Future.value(false));

    expect(
      () async => await networkManager.get<Todo>(
        request: GetRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/1',
        ),
        options: RequestOptions(responseType: ResponseType.json),
      ),
      throwsA(const TypeMatcher<ConnectionException>().having(
        (e) => e.errorCode,
        'error-code',
        equals(ErrorCode.noInternetError),
      )),
    );
  });

  group('updateOptions', () {
    test('verify updateOptions default headers', () async {
      final options =
          RequestOptions(responseType: ResponseType.json, headers: headers);
      var validateStatus = (int status) => true;
      when(mockHttpHelper.validateStatus(any)).thenReturn(true);

      var updatedOptions = await networkManager.updateOptions(options);

      var expectedHeaders = <String, dynamic>{};
      expectedHeaders.addAll(headers);
      expectedHeaders.addAll(defaultHeaders);

      var expectedOptions = RequestOptions(
          responseType: ResponseType.json,
          headers: expectedHeaders,
          validateStatus: validateStatus);

      expect(updatedOptions.responseType, expectedOptions.responseType);
      expect(updatedOptions.headers, expectedOptions.headers);
      expect(updatedOptions.validateStatus(-1),
          expectedOptions.validateStatus(-1));
    });

    test('verify updateOptions appending default headers', () async {
      final options = RequestOptions(
          responseType: ResponseType.json,
          headers: {'dh1': 'New one', 'h2': 'v2'});
      var validateStatus = (int status) => true;

      when(mockHttpHelper.validateStatus(any)).thenReturn(true);

      var updatedOptions = await networkManager.updateOptions(options);

      var expectedHeaders = {'dh1': 'New one', 'h2': 'v2', 'dh2': 'dv2'};

      var expectedOptions = RequestOptions(
          responseType: ResponseType.json,
          headers: expectedHeaders,
          validateStatus: validateStatus);

      expect(updatedOptions.responseType, expectedOptions.responseType);
      expect(updatedOptions.headers, expectedOptions.headers);
      expect(updatedOptions.validateStatus(-1),
          expectedOptions.validateStatus(-1));
    });

    test('verify updateOptions when headers is null', () async {
      final options = RequestOptions(
        responseType: ResponseType.json,
      );
      var validateStatus = (int status) => true;

      when(mockHttpHelper.validateStatus(any)).thenReturn(true);

      var updatedOptions = await networkManager.updateOptions(options);

      var expectedOptions = RequestOptions(
          responseType: ResponseType.json,
          headers: defaultHeaders,
          validateStatus: validateStatus);

      expect(updatedOptions.responseType, expectedOptions.responseType);
      expect(updatedOptions.headers, expectedOptions.headers);
      expect(updatedOptions.validateStatus(-1),
          expectedOptions.validateStatus(-1));
    });
  });

  group('get', () {
    test('valid GET request with valid 200 valid response', () async {
      var todo = Todo(
          userId: 1,
          id: 1,
          title:
              'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
          body:
              'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto');
      var getRequest = GetRequest(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
      );
      final options = RequestOptions(responseType: ResponseType.json);
      final httpResponse = HttpResponse<Todo>(
          headers: headers,
          data: todo,
          statusCode: HttpStatus.ok,
          statusMessage: ok);
      when(mockConnectivity.isConnected())
          .thenAnswer((realInvocation) => Future.value(true));
      when(
        mockNetwork.get<Todo>(
            request: anyNamed('request'), options: anyNamed('options')),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));

      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.get<Todo>(
        request: getRequest,
        options: options,
      );

      var expectedResponse = BaseResponse<Todo>(todo, HttpStatus.ok, ok);

      expect(response, equals(expectedResponse));
    });
  });

  group('POST', () {
    test('valid POST request with valid 200 valid response', () async {
      var todo = Todo(
          userId: 1,
          id: 1,
          title:
              'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
          body:
              'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto');
      var postRequest = PostRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/1', body: todo);
      final options = RequestOptions(responseType: ResponseType.json);
      final httpResponse = HttpResponse<Todo>(
          headers: headers,
          data: todo,
          statusCode: HttpStatus.ok,
          statusMessage: ok);

      when(
        mockNetwork.post<Todo>(
            request: anyNamed('request'), options: anyNamed('options')),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));

      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.post<Todo>(
        request: postRequest,
        options: options,
      );

      var expectedResponse = BaseResponse<Todo>(todo, HttpStatus.ok, ok);

      expect(response, equals(expectedResponse));
    });
  });

  group('PUT', () {
    test('valid put request with valid 200 valid response', () async {
      var todo = Todo(
          userId: 1,
          id: 2,
          title: 'Hossam Eldin',
          body:
              'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto');
      var putRequest = PutRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/2',
          body: todo.toJson());
      final options = RequestOptions(responseType: ResponseType.json);
      final httpResponse = HttpResponse<Todo>(
          headers: headers,
          data: todo,
          statusCode: HttpStatus.ok,
          statusMessage: ok);

      when(
        mockNetwork.put<Todo>(
            request: anyNamed('request'), options: anyNamed('options')),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));
      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.put<Todo>(
        request: putRequest,
        options: options,
      );

      var expectedResponse = BaseResponse<Todo>(todo, HttpStatus.ok, ok);
      expect(response, equals(expectedResponse));
    });
  });

  group('Delete', () {
    test('valid delete request with valid 200 valid response', () async {
      var putRequest = DeleteRequest(
        url: 'https://jsonplaceholder.typicode.com/posts/2',
      );
      final options = RequestOptions(responseType: ResponseType.json);
      final httpResponse = HttpResponse<void>(
          headers: headers,
          data: null,
          statusCode: HttpStatus.ok,
          statusMessage: ok);

      when(
        mockNetwork.delete<void>(
            request: anyNamed('request'), options: anyNamed('options')),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));
      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.delete<void>(
        request: putRequest,
        options: options,
      );

      var expectedResponse = BaseResponse<void>(null, HttpStatus.ok, ok);
      expect(response, equals(expectedResponse));
    });
  });

  test('Download files request with valid 200 valid response', () async {
    var putRequest = DownloadFileRequest(
        url:
            'https://cdn.iconscout.com/icon/free/png-512/flutter-2038877-1720090.png',
        savePath: imagePath);
    final options = RequestOptions(responseType: ResponseType.json);
    final httpResponse = HttpResponse<void>(
        headers: headers,
        data: null,
        statusCode: HttpStatus.ok,
        statusMessage: ok);

    when(
      mockNetwork.downloadFile<void>(
          request: anyNamed('request'), options: anyNamed('options')),
    ).thenAnswer((realInvocation) => Future.value(httpResponse));
    when(mockHttpHelper.resolveResponse(httpResponse))
        .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
    var response = await networkManager.downloadFile<void>(
      request: putRequest,
      options: options,
    );

    var expectedResponse = BaseResponse<void>(null, HttpStatus.ok, ok);
    expect(response, equals(expectedResponse));
  });
}
