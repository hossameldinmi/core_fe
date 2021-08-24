import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:core_fe_infrastructure/src/models/base_request.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart';
import 'package:core_fe_infrastructure/src/models/response_options.dart';
import 'package:core_fe_infrastructure/src/providers/http_provider.dart';
import 'package:dio/dio.dart' hide RequestOptions, ResponseType;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../mocks/mocks.dart';
import '../mocks/providers_mocks.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:core_fe_infrastructure/src/enums/response_type.dart';

import '../shared.dart';

ResponseBody _getJsonResponseBody(dynamic data, int statusCode,
    {String statusMessage, bool isRedirect = false, String contentTypeHeader = Headers.jsonContentType}) {
  return ResponseBody.fromString(json.encode(data), statusCode,
      headers: {
        Headers.contentTypeHeader: [contentTypeHeader],
      },
      isRedirect: isRedirect,
      statusMessage: statusMessage);
}

void addLoggerInterceptor(Dio dio) {
  dio.interceptors.add(
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
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final bytes1 = await file1.readAsBytes();

  final dio = Dio();
  // addLoggerInterceptor(dio);
  final mockHttpClientAdapter = MockHttpClientAdapter();
  dio.httpClientAdapter = mockHttpClientAdapter;
  final httpProvider = DioHttpProvider(dio: dio);
  group('HTTP get', () {
    test('valid GET request with valid 200 valid response', () async {
      var todo = Todo(
          userId: 1,
          id: 1,
          title: 'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
          body:
              'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto');
      when(
        mockHttpClientAdapter.fetch(any, any, any),
      ).thenAnswer(
          (realInvocation) => Future.value(_getJsonResponseBody(todo.toJson(), HttpStatus.ok, statusMessage: ok)));
      var response = await httpProvider.get<Todo>(
        request: GetRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/1',
        ),
        requestOptions: RequestOptions(contentType: ContentType.json),
        responseOptions: ResponseOptions(fromJson: (json) => Todo.fromJson(json)),
      );

      var expectedResponse = HttpResponse<Todo>(data: todo, statusCode: HttpStatus.ok, statusMessage: ok);
      expect(response, equals(expectedResponse));
    });

    test('get request with NOT FOUND error response', () async {
      when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
          (realInvocation) => Future.value(_getJsonResponseBody(null, HttpStatus.notFound, statusMessage: notFound)));
      var response = await httpProvider.get<Todo>(
        request: GetRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/222',
        ),
        requestOptions: RequestOptions(sendTimeout: 20),
        responseOptions: ResponseOptions(
          fromJson: (json) => Todo.fromJson(json),
        ),
      );

      var expectedResponse = HttpResponse<Todo>(data: null, statusCode: HttpStatus.notFound, statusMessage: notFound);
      expect(response, expectedResponse);
    });
  });

  group('HTTP post', () {
    test('valid post request with valid HttpStatus.created valid response', () async {
      var todo = Todo(
          userId: 1,
          id: 101,
          title: 'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
          body:
              'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto');
      when(
        mockHttpClientAdapter.fetch(any, any, any),
      ).thenAnswer((realInvocation) =>
          Future.value(_getJsonResponseBody(todo.toJson(), HttpStatus.created, statusMessage: created)));
      var response = await httpProvider.post<Todo>(
        request: PostRequest(
          url: 'https://jsonplaceholder.typicode.com/posts',
          body: todo.toJson(),
        ),
        requestOptions: RequestOptions(),
        responseOptions: ResponseOptions(
          fromJson: (json) => Todo.fromJson(json),
        ),
      );

      var expectedResponse = HttpResponse<Todo>(data: todo, statusCode: HttpStatus.created, statusMessage: created);
      expect(response, equals(expectedResponse));
    });

    test('post request with Not Found error response', () async {
      when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
          (realInvocation) => Future.value(_getJsonResponseBody(null, HttpStatus.notFound, statusMessage: notFound)));
      var response = await httpProvider.post<Todo>(
        request: PostRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/1',
          body: null,
        ),
        requestOptions: RequestOptions(sendTimeout: 20),
        responseOptions: ResponseOptions(
          fromJson: (json) => Todo.fromJson(json),
        ),
      );

      var expectedResponse = HttpResponse<Todo>(data: null, statusCode: HttpStatus.notFound, statusMessage: notFound);
      expect(response, expectedResponse);
    });
  });

  group('HTTP put', () {
    test('valid put request with valid 200 valid response', () async {
      var todo = Todo(
          userId: 1,
          id: 2,
          title: 'Hossam Eldin',
          body:
              'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto');
      when(
        mockHttpClientAdapter.fetch(any, any, any),
      ).thenAnswer(
          (realInvocation) => Future.value(_getJsonResponseBody(todo.toJson(), HttpStatus.ok, statusMessage: ok)));
      var response = await httpProvider.put<Todo>(
        request: PutRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/2',
          body: todo.toJson(),
        ),
        requestOptions: RequestOptions(),
        responseOptions: ResponseOptions(
          fromJson: (json) => Todo.fromJson(json),
        ),
      );

      var expectedResponse = HttpResponse<Todo>(
        data: todo,
        statusMessage: ok,
        statusCode: HttpStatus.ok,
      );
      expect(response, equals(expectedResponse));
    });

    test('put request with Internal Server Error response', () async {
      when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer((realInvocation) =>
          Future.value(_getJsonResponseBody(null, HttpStatus.internalServerError, statusMessage: internalServerError)));
      var response = await httpProvider.put<Todo>(
        request: PutRequest(
          body: null,
          url: 'https://jsonplaceholder.typicode.com/posts/101',
        ),
        requestOptions: RequestOptions(sendTimeout: 20),
        responseOptions: ResponseOptions(
          fromJson: (json) => Todo.fromJson(json),
        ),
      );

      var expectedResponse = HttpResponse<Todo>(
          data: null, statusCode: HttpStatus.internalServerError, statusMessage: internalServerError);
      expect(response, expectedResponse);
    });
  });

  group('HTTP delete', () {
    test('valid delete request with valid 200 valid response', () async {
      when(
        mockHttpClientAdapter.fetch(any, any, any),
      ).thenAnswer((realInvocation) => Future.value(_getJsonResponseBody(null, HttpStatus.ok, statusMessage: ok)));
      var response = await httpProvider.delete<void>(
        request: DeleteRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/2',
        ),
        requestOptions: RequestOptions(),
        responseOptions: ResponseOptions(),
      );

      var expectedResponse = HttpResponse<void>(
        data: null,
        statusMessage: ok,
        statusCode: HttpStatus.ok,
      );
      expect(response, equals(expectedResponse));
    });

    test('delete request with notFound error response', () async {
      when(
        mockHttpClientAdapter.fetch(any, any, any),
      ).thenAnswer(
          (realInvocation) => Future.value(_getJsonResponseBody(null, HttpStatus.notFound, statusMessage: notFound)));
      var response = await httpProvider.delete<void>(
        request: DeleteRequest(
          url: 'https://jsonplaceholder.typicode.com/posts/',
        ),
        requestOptions: RequestOptions(),
        responseOptions: ResponseOptions(),
      );

      var expectedResponse = HttpResponse<void>(
        data: null,
        statusMessage: notFound,
        statusCode: HttpStatus.notFound,
      );
      expect(response, equals(expectedResponse));
    });
  });

  group('Download Files', () {
    test('download image and get File Object with valid 200 valid response', () async {
      when(
        mockHttpClientAdapter.fetch(any, any, any),
      ).thenAnswer(
        (realInvocation) async => getBytesResponseBody(bytes1, HttpStatus.ok,
            contentTypeHeader: ContentType.parse('image/png').value, statusMessage: ok),
      );

      var response = await httpProvider.downloadFile<File>(
          request: DownloadFileRequest(
            savePath: imagePath,
            url: 'https://cdn.iconscout.com/icon/free/png-512/flutter-2038877-1720090.png',
          ),
          requestOptions: RequestOptions(
            contentType: ContentType.json,
          ),
          responseOptions: ResponseOptions(responseType: ResponseType.bytes));
      var expectedResponse = HttpResponse<File>(
        data: file1,
        statusMessage: ok,
        statusCode: HttpStatus.ok,
      );
      expect(response.extra, expectedResponse.extra);
      // expect(response.headers, expectedResponse.headers);
      expect(response.isRedirect, expectedResponse.isRedirect);
      expect(response.statusCode, expectedResponse.statusCode);
      expect(response.statusMessage, expectedResponse.statusMessage);
      var expectedBytes = await expectedResponse.data.readAsBytes();
      var actualBytes = await response.data.readAsBytes();
      expect(actualBytes, equals(expectedBytes));
      // after testing
      deleteFile(imagePath);
    });

    test(
      'download image and get dynamic Object',
      () async {
        when(
          mockHttpClientAdapter.fetch(any, any, any),
        ).thenAnswer(
          (realInvocation) async => getBytesResponseBody(bytes1, HttpStatus.ok,
              contentTypeHeader: ContentType.parse('image/png').value, statusMessage: ok),
        );

        var response = await httpProvider.downloadFile(
            request: DownloadFileRequest(
              savePath: imagePath,
              url: 'https://cdn.iconscout.com/icon/free/png-512/flutter-2038877-1720090.png',
            ),
            requestOptions: RequestOptions(
              contentType: ContentType.json,
            ),
            responseOptions: ResponseOptions(responseType: ResponseType.bytes));
        var expectedResponse = HttpResponse(
          data: getBytesResponseBody(bytes1, HttpStatus.ok,
              contentTypeHeader: ContentType.parse('image/png').value, statusMessage: ok),
          statusMessage: ok,
          statusCode: HttpStatus.ok,
        );
        expect(response.extra, expectedResponse.extra);
        expect(response.isRedirect, expectedResponse.isRedirect);
        expect(response.statusCode, expectedResponse.statusCode);
        expect(response.statusMessage, expectedResponse.statusMessage);
        // expect(response.data, equals(expectedResponse.data));
        var expectedStream = expectedResponse.data.stream.asBroadcastStream();
        var stream = (response.data as ResponseBody).stream.asBroadcastStream();
        await expectStream(stream.asBroadcastStream(), expectedStream.asBroadcastStream());
      },
      skip: 'Fix stream error',
    );

    test('download image and get void', () async {
      when(
        mockHttpClientAdapter.fetch(any, any, any),
      ).thenAnswer(
        (realInvocation) async => getBytesResponseBody(bytes1, HttpStatus.ok,
            contentTypeHeader: ContentType.parse('image/png').value, statusMessage: ok),
      );

      var response = await httpProvider.downloadFile<void>(
        request: DownloadFileRequest(
          savePath: imagePath,
          url: 'https://cdn.iconscout.com/icon/free/png-512/flutter-2038877-1720090.png',
        ),
        requestOptions: RequestOptions(
          contentType: ContentType.json,
        ),
        responseOptions: ResponseOptions(responseType: ResponseType.bytes),
      );

      var expectedResponse = HttpResponse<void>(
        data: null,
        statusMessage: ok,
        statusCode: HttpStatus.ok,
      );
      expect(response, expectedResponse);
      // after testing
      deleteFile(imagePath);
    });
  });
  group('Post File', () {
    test('upload valid file to google Drive', () async {
      var response = await httpProvider.postFile(
          request: PostFileRequest(
              url: 'https://www.googleapis.com/upload/drive/v3/files',
              data: File(imagePath),
              queryParams: {'uploadType': 'multipart', 'API_KEY': 'AIzaSyCscBiYqmCWMcLniZxzFP_aA0qq8B4v6sA'}),
          requestOptions: RequestOptions(
            contentType: ContentType.parse('application/multipart'),
          ),
          responseOptions: ResponseOptions(responseType: ResponseType.bytes));

      expect(response.data, response.data);
    }, skip: true);
  });
}
