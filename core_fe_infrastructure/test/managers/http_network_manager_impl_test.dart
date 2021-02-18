import 'dart:io';

import 'package:core_fe_infrastructure/src/constants/error_code.dart';
import 'package:core_fe_infrastructure/src/enums/response_type.dart';
import 'package:core_fe_infrastructure/src/exceptions/network_exceptions.dart';
import 'package:core_fe_infrastructure/src/managers/http_network_manager_impl.dart';
import 'package:core_fe_infrastructure/src/models/base_request.dart';
import 'package:core_fe_infrastructure/src/models/base_response.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocks.dart';
import 'package:matcher/matcher.dart';
import 'package:core_fe_infrastructure/models.dart';
import '../shared.dart';
import 'package:core_fe_infrastructure/utils.dart';

void main() {
  final mockConnectivity = MockConnectivity();
  final mockNetworkProvider = MockNetworkProvider();
  final mockHttpHelper = MockHttpHelper();

  final networkManager = HttpNetworkManagerImpl(
      mockNetworkProvider, mockHttpHelper, mockConnectivity);
  final headers = {'h1': 'v1', 'h2': 'v2'};
  final defaultHeaders = {'dh1': 'dv1', 'dh2': 'dv2'};
  setUpAll(() {
    when(mockHttpHelper.getDefaultHeaders())
        .thenAnswer((realInvocation) => Future.value(defaultHeaders));
    when(mockConnectivity.isConnected())
        .thenAnswer((realInvocation) => Future.value(true));
    when(mockHttpHelper.validateStatus(any)).thenReturn(true);
  });
  test('Expected connection exception when no internet connection', () async {
    when(mockConnectivity.isConnected())
        .thenAnswer((realInvocation) => Future.value(false));

    expect(
      () async => await networkManager.get<Todo>(
        request: GetRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/1',
        ),
        requestOptions: RequestOptions(),
      ),
      throwsA(const TypeMatcher<ConnectionException>().having(
        (e) => e.errorCode,
        'error-code',
        equals(ErrorCode.noInternetError),
      )),
    );
  });

  group('updateRequestOptions', () {
    test('expected DefaultOptions when passed options is null', () async {
      var updatedOptions = await networkManager.updateRequestOptions(null);
      var expectedOptions = RequestOptions(
        headers: defaultHeaders,
        contentType: ContentType.json,
      );
      expect(updatedOptions, expectedOptions);
    });
    test('expect default RequestOptions when headers is null', () async {
      final options = RequestOptions();

      var updatedOptions = await networkManager.updateRequestOptions(options);

      var expectedOptions = RequestOptions(headers: defaultHeaders);

      expect(updatedOptions, expectedOptions);
    });
    test(
        'expect new requestOptions with (new+old) headers when add new headers',
        () async {
      final options = RequestOptions(headers: headers);

      var updatedOptions = await networkManager.updateRequestOptions(options);

      var expectedHeaders = {
        'h1': 'v1',
        'h2': 'v2',
        'dh1': 'dv1',
        'dh2': 'dv2'
      };

      var expectedOptions = RequestOptions(headers: expectedHeaders);

      expect(updatedOptions, expectedOptions);
    });

    test('expect updating default headers', () async {
      final options = RequestOptions(headers: {'dh1': 'New DefaultValue'});

      var updatedOptions = await networkManager.updateRequestOptions(options);

      var expectedHeaders = {'dh1': 'New DefaultValue', 'dh2': 'dv2'};

      var expectedOptions = RequestOptions(headers: expectedHeaders);

      expect(updatedOptions, expectedOptions);
    });
  });

//todo: Mock
  group('updateResponseOptions', () {
    test('expected ResponseOptions when passed options<int> is null', () async {
      var updatedOptions =
          await networkManager.updateResponseOptions<int>(null);
      var expectedOptions = ResponseOptions(
        responseType: ResponseType.json,
        fromJson: JsonUtil.getType<int>().fromJson,
        receiveTimeout: 60000,
        validateStatus: mockHttpHelper.validateStatus,
      );
      expect(updatedOptions, expectedOptions);
    });
    test('expect default ResponseOptions when passing Empty initalized Object',
        () async {
      final options = ResponseOptions<int>();
      var updatedOptions =
          await networkManager.updateResponseOptions<int>(options);
      var expectedOptions = ResponseOptions(
        responseType: ResponseType.json,
        fromJson: JsonUtil.getType<int>().fromJson,
        receiveTimeout: 60000,
        validateStatus: mockHttpHelper.validateStatus,
      );
      expect(updatedOptions, expectedOptions);
    });
    test('expect new ResponseOptions with new receiveTimeout', () async {
      final options = ResponseOptions<int>(receiveTimeout: 2000);
      var updatedOptions =
          await networkManager.updateResponseOptions<int>(options);
      var expectedOptions = ResponseOptions(
        responseType: ResponseType.json,
        fromJson: JsonUtil.getType<int>().fromJson,
        receiveTimeout: 2000,
        validateStatus: mockHttpHelper.validateStatus,
      );
      expect(updatedOptions, expectedOptions);
    });

    test('expect new ResponseOptions with new responseType', () async {
      final options = ResponseOptions<int>(
        receiveTimeout: 2000,
        responseType: ResponseType.plain,
      );
      var updatedOptions =
          await networkManager.updateResponseOptions<int>(options);
      var expectedOptions = ResponseOptions(
        responseType: ResponseType.plain,
        fromJson: JsonUtil.getType<int>().fromJson,
        receiveTimeout: 2000,
        validateStatus: mockHttpHelper.validateStatus,
      );
      expect(updatedOptions, expectedOptions);
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
      final responseOptions = ResponseOptions(
          responseType: ResponseType.json,
          fromJson: (json) => Todo.fromJson(json));
      final httpResponse = HttpResponse<Todo>(
          data: todo, statusCode: HttpStatus.ok, statusMessage: ok);
      when(mockConnectivity.isConnected())
          .thenAnswer((realInvocation) => Future.value(true));
      when(
        mockNetworkProvider.get<Todo>(
          request: anyNamed('request'),
          requestOptions: anyNamed('requestOptions'),
          responseOptions: anyNamed('responseOptions'),
        ),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));

      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.get<Todo>(
          request: getRequest, responseOptions: responseOptions);

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
      final httpResponse = HttpResponse<Todo>(
          data: todo, statusCode: HttpStatus.ok, statusMessage: ok);
      var responseOptions =
          ResponseOptions(fromJson: (json) => Todo.fromJson(json));
      when(
        mockNetworkProvider.post<Todo>(
          request: anyNamed('request'),
          requestOptions: anyNamed('requestOptions'),
          responseOptions: anyNamed('responseOptions'),
        ),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));

      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.post<Todo>(
          request: postRequest, responseOptions: responseOptions);

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
      final httpResponse = HttpResponse<Todo>(
          data: todo, statusCode: HttpStatus.ok, statusMessage: ok);

      var responseOptions =
          ResponseOptions(fromJson: (json) => Todo.fromJson(json));
      when(
        mockNetworkProvider.put<Todo>(
          request: anyNamed('request'),
          requestOptions: anyNamed('requestOptions'),
          responseOptions: anyNamed('responseOptions'),
        ),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));
      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.put<Todo>(
          request: putRequest, responseOptions: responseOptions);

      var expectedResponse = BaseResponse<Todo>(todo, HttpStatus.ok, ok);
      expect(response, equals(expectedResponse));
    });
  });

  group('Delete', () {
    test('valid delete request with valid 200 valid response', () async {
      var putRequest = DeleteRequest(
        url: 'https://jsonplaceholder.typicode.com/posts/2',
      );
      final requestOptions = RequestOptions();
      final httpResponse = HttpResponse<void>(
          data: null, statusCode: HttpStatus.ok, statusMessage: ok);

      when(
        mockNetworkProvider.delete<void>(
          request: anyNamed('request'),
          requestOptions: anyNamed('requestOptions'),
          responseOptions: anyNamed('responseOptions'),
        ),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));
      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.delete<void>(
        request: putRequest,
        requestOptions: requestOptions,
      );

      var expectedResponse = BaseResponse<void>(null, HttpStatus.ok, ok);
      expect(response, equals(expectedResponse));
    });
  });

  group('Post file', () {
    test('valid post file request with valid 200 valid response', () async {
      var postFileRequest = PostFileRequest(
        url: 'https://jsonplaceholder.typicode.com/posts/2',
        data: file1,
      );
      final requestOptions = RequestOptions();
      final httpResponse = HttpResponse<void>(
          data: null, statusCode: HttpStatus.ok, statusMessage: ok);

      when(
        mockNetworkProvider.postFile<void>(
          request: anyNamed('request'),
          requestOptions: anyNamed('requestOptions'),
          responseOptions: anyNamed('responseOptions'),
        ),
      ).thenAnswer((realInvocation) => Future.value(httpResponse));
      when(mockHttpHelper.resolveResponse(httpResponse))
          .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
      var response = await networkManager.postFile<void>(
        request: postFileRequest,
        requestOptions: requestOptions,
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
    final requestOptions = RequestOptions();
    final httpResponse = HttpResponse<void>(
        data: null, statusCode: HttpStatus.ok, statusMessage: ok);

    when(
      mockNetworkProvider.downloadFile<void>(
        request: anyNamed('request'),
        requestOptions: anyNamed('requestOptions'),
        responseOptions: anyNamed('responseOptions'),
      ),
    ).thenAnswer((realInvocation) => Future.value(httpResponse));
    when(mockHttpHelper.resolveResponse(httpResponse))
        .thenReturn(BaseResponse.fromHttpResponse(httpResponse));
    var response = await networkManager.downloadFile<void>(
      request: putRequest,
      requestOptions: requestOptions,
    );

    var expectedResponse = BaseResponse<void>(null, HttpStatus.ok, ok);
    expect(response, equals(expectedResponse));
  });
}
