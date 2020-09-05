import 'dart:async';
import 'dart:io';
import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart'
    as request_options;
import 'package:core_fe_infrastructure/src/utils/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_infrastructure/src/enums/response_type.dart'
    as response_type;

import '../core_fe_infrastructure.dart';
import '../shared.dart';
import 'package:core_fe_dart/extensions.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart'
    as http_response;

void main() async {
  group('Dio Helper Tests', () {
    test('toDioResponseType', () {
      expect(DioHelper.toDioResponseType(response_type.ResponseType.bytes),
          ResponseType.bytes);
      expect(DioHelper.toDioResponseType(response_type.ResponseType.json),
          ResponseType.json);
      expect(DioHelper.toDioResponseType(response_type.ResponseType.plain),
          ResponseType.plain);
      expect(DioHelper.toDioResponseType(response_type.ResponseType.stream),
          ResponseType.stream);
      expect(DioHelper.toDioResponseType(null), ResponseType.json);
    });
    group('toDioOptions', () {
      void expectOptions(Options actual, Options expected) {
        expect(actual.contentType, expected.contentType);
        expect(actual.extra, expected.extra);
        expect(actual.followRedirects, expected.followRedirects);
        expect(actual.headers, expected.headers);
        expect(actual.maxRedirects, expected.maxRedirects);
        expect(actual.receiveTimeout, expected.receiveTimeout);
        expect(actual.sendTimeout, expected.sendTimeout);
        expect(actual.responseType, expected.responseType);
        expect(actual.validateStatus, expected.validateStatus);
      }

      test('convert request options to dioOptions', () {
        var headers = {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.acceptLanguageHeader: 'en'
        };
        var options = request_options.RequestOptions(
          headers: headers,
          contentType: ContentType.json,
          responseType: response_type.ResponseType.json,
          receiveTimeout: 100,
          sendTimeout: 200,
        );

        var expectedDioOptions = Options(
            contentType: ContentType.json.value,
            headers: headers,
            receiveTimeout: 100,
            sendTimeout: 200,
            responseType: ResponseType.json);
        var actualOptions = DioHelper.toDioOptions(options);
        expectOptions(actualOptions, expectedDioOptions);
      });

      test('convert request options to dioOptions with length value', () {
        var headers = {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.acceptLanguageHeader: 'en'
        };
        var options = request_options.RequestOptions(
          headers: headers,
          contentType: ContentType.json,
          length: 100,
          responseType: response_type.ResponseType.json,
        );

        var expectedDioOptions = Options(
            contentType: ContentType.json.value,
            headers: {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.acceptLanguageHeader: 'en',
              HttpHeaders.contentLengthHeader: 100,
            },
            responseType: ResponseType.json);
        var actualOptions = DioHelper.toDioOptions(options);
        expectOptions(actualOptions, expectedDioOptions);
      });

      test('convert request options to dioOptions with length value', () {
        var headers = {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.acceptLanguageHeader: 'en'
        };
        var options = request_options.RequestOptions(
          headers: headers,
          contentType: ContentType.json,
          responseType: response_type.ResponseType.json,
        );

        var expectedDioOptions = Options(
            contentType: ContentType.json.value,
            headers: {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.acceptLanguageHeader: 'en',
              HttpHeaders.contentLengthHeader: 100,
            },
            responseType: ResponseType.json);
        var actualOptions = DioHelper.toDioOptions(options, 100);
        expectOptions(actualOptions, expectedDioOptions);
      });

      test('convert request options to dioOptions with null header value', () {
        var options = request_options.RequestOptions(
          contentType: ContentType.json,
          responseType: response_type.ResponseType.json,
        );

        var expectedDioOptions = Options(
            contentType: ContentType.json.value,
            headers: {
              HttpHeaders.contentLengthHeader: 100,
            },
            responseType: ResponseType.json);
        var actualOptions = DioHelper.toDioOptions(options, 100);
        expectOptions(actualOptions, expectedDioOptions);
      });
    });

    group('File Conversion', () {
      // final path = 'image.png';
      // final file = File(path);
      // MultipartFile part1;
      Stream<List<int>> stream1;

      setUp(() async {
        // part1 = await MultipartFile.fromFile(file1.path);
        // stream1 = part1.finalize();
        stream1 = file1.openRead();
      });
      group('toMultipartFile', () {
        test('validation when value is null', () {
          expect(() => DioHelper.toMultipartFile(null), throwsAssertionError);
        });

        test('casting when value is file', () async {
          var actualFile = await DioHelper.toMultipartFile(file1);
          await expectStream(actualFile.finalize(), stream1);
        });

        test('casting when value is Stream', () async {
          var actualFile = await DioHelper.toMultipartFile(file1.openRead());
          await expectStream(actualFile.finalize(), stream1);
        });

        test('casting when value is MultipartFile', () async {
          var tempPart = await MultipartFile.fromFile(file1.path);
          var actualFile = await DioHelper.toMultipartFile(tempPart);
          await expectStream(actualFile.finalize(), stream1);
        });

        test('casting when value is MultipartFile', () async {
          var actualFile =
              await DioHelper.toMultipartFile(await file1.readAsBytes());
          await expectStream(actualFile.finalize(), stream1);
        });
      });

      group('toFileCollection', () {
        // MultipartFile part2;
        Stream<List<int>> stream2;

        setUpAll(() async {
          // part2 = await MultipartFile.fromFile(flutterLogo);
          // stream2 = part2.finalize();
          stream2 = file2.openRead();
        });
        test('validation when value is null', () {
          expect(() => DioHelper.toFileCollection(null), throwsAssertionError);
        });

        test('casting when value is File', () async {
          final actualFile =
              await DioHelper.toFileCollection(file1) as MultipartFile;
          await expectStream(actualFile.finalize(), stream1);
        });

        test('casting when value is List of Files', () async {
          final actualFiles =
              (await DioHelper.toFileCollection([file1, file2]) as List)
                  .cast<MultipartFile>();
          var p1 = actualFiles[0];
          var p2 = actualFiles[1];
          await expectStream(p1.finalize(), stream1);
          await expectStream(p2.finalize(), stream2);
        }, timeout: Timeout.none);

        test('casting when value is Map<String,File>', () async {
          final actualFiles =
              (await DioHelper.toFileCollection({'f1': file1, 'f2': file2})
                      as Map)
                  .cast<String, MultipartFile>();
          var f1Stream = await actualFiles['f1'].finalize();
          var f2Stream = await actualFiles['f2'].finalize();
          print('get streams');
          await expectStream(f1Stream, stream1);
          await expectStream(f2Stream, stream2);
        }, skip: 'Timout Proplem', timeout: Timeout.none);

        test('casting when value is Map<String,List<File>>', () async {
          final actualFiles = await DioHelper.toFileCollection({
            'f1': [file1, file2],
            'f2': [file1, file2]
          }) as Map;

          var list = (actualFiles['f1'] as List).cast<MultipartFile>();
          var list2 = (actualFiles['f2'] as List).cast<MultipartFile>();
          await expectStream(list[0].finalize(), stream1);
          await expectStream(list[1].finalize(), stream2);
          await expectStream(list2[0].finalize(), stream1);
          await expectStream(list2[1].finalize(), stream2);
        }, timeout: Timeout.none, skip: 'Timout Proplem');

        test('casting when value is Map<String,dynamic>(List<File> & File)',
            () async {
          final actualFiles = (await DioHelper.toFileCollection({
            'f1': [file1, file2],
            'f2': file1
          }) as Map);

          var list = (actualFiles['f1'] as List).cast<MultipartFile>();
          await expectStream(list[0].finalize(), stream1);
          await expectStream(list[1].finalize(), stream2);
          await expectStream(
              (actualFiles['f2'] as MultipartFile).finalize(), stream1);
        }, timeout: Timeout.none, skip: 'Timout Proplem');
      });
    });

    group('toValidFileObject', () {
      Future<void> equalsFormData(
          FormData actualForm, FormData expectedForm) async {
        expect(actualForm.fields, equals(expectedForm.fields));
        expect(actualForm.length, expectedForm.length);
        expect(actualForm.fields.length, expectedForm.fields.length);
        expect(actualForm.files.length, expectedForm.files.length);
        // expect(
        //     actualForm.files.equals(expectedForm.files, elementEquality:
        //         EqualityBy<MapEntry<String, MultipartFile>,
        //             Future<Tuple2<String, Uint8List>>>((entry) async {
        //       var bytes = await entry.value.finalize().toBytes();
        //       var key = Tuple2(entry.key, bytes);
        //       print(key.toString());
        //       return key;
        //     })),
        //     true);
        for (var i = 0; i < expectedForm.files.length; i++) {
          var file = actualForm.files[i];
          var expectedFile = expectedForm.files[i];
          expect(file.key, expectedFile.key);
          await expectMultiepartFile(file.value, expectedFile.value);
        }
      }

      test('validate null value object', () {
        expect(() => DioHelper.toValidFileObject(null), throwsAssertionError);
      });

      test('expected casting when data is Map<String,List<File>>', () async {
        var expectedFile = await MultipartFile.fromFile(file1.path);
        var result = await DioHelper.toValidFileObject(file1);
        await expectMultiepartFile(result.item1 as MultipartFile, expectedFile);
      }, skip: 'test list on dio');
      test('expected casting when data is Map<String,List<File>>', () async {
        var body = {
          'f1': file1,
          'f2': [file1, file2]
        };

        var expectedBody = {
          'f1': await MultipartFile.fromFile(file1.path),
          'f2': [
            await MultipartFile.fromFile(file1.path),
            await MultipartFile.fromFile(file2.path)
          ]
        };
        var result = await DioHelper.toValidFileObject(body);
        var formData = result.item1 as FormData;
        await equalsFormData(formData, FormData.fromMap(expectedBody));
      });

      test('expected casting when data is List<List<File>>', () async {},
          skip: 'test list on dio');
    });
  });

  group('toHttpResponse', () {
    BaseFactory.init(CoreFeInfrastructureTest());
    void expectResponse(http_response.HttpResponse actual,
        http_response.HttpResponse expected) {
      expect(actual.extra, expected.extra);
      expect(actual.headers, expected.headers);
      expect(actual.isRedirect, expected.isRedirect);
      expect(actual.statusCode, expected.statusCode);
      expect(actual.statusMessage, expected.statusMessage);
    }

    test('assertion error when data is null', () {
      expect(() => DioHelper.toHttpResponse<int>(null), throwsAssertionError);
    });

    test('response when data is int', () {
      var httpResponse = DioHelper.toHttpResponse<int>(
        Response(
          data: 1,
          isRedirect: false,
          statusCode: HttpStatus.ok,
          headers: Headers.fromMap({
            HttpHeaders.contentTypeHeader: [Headers.jsonContentType]
          }),
        ),
      );

      var expectedResponse = http_response.HttpResponse<int>(
          data: 1,
          statusCode: HttpStatus.ok,
          headers: {
            HttpHeaders.contentTypeHeader: [Headers.jsonContentType]
          });

      expect(httpResponse, expectedResponse);
    });

    test('response when data is map and TResponse is dynamic', () {
      var data = {
        'd1': 1,
        'list': [2, 3, 5]
      };
      var httpResponse = DioHelper.toHttpResponse(
        Response(
          data: data,
          isRedirect: false,
          statusCode: HttpStatus.ok,
          headers: Headers.fromMap({
            HttpHeaders.contentTypeHeader: [Headers.jsonContentType]
          }),
        ),
      );

      var expectedResponse = http_response.HttpResponse(
          data: data,
          statusCode: HttpStatus.ok,
          headers: {
            HttpHeaders.contentTypeHeader: [Headers.jsonContentType]
          });

      expect(httpResponse.data, isMap);
      expect((httpResponse.data as Map).equals(expectedResponse.data), true);
      expectResponse(httpResponse, expectedResponse);
    });

    test('response when data is map and TResponse is void', () {
      var data = {
        'd1': 1,
        'list': [2, 3, 5]
      };
      var httpResponse = DioHelper.toHttpResponse<void>(
        Response(
          data: data,
          isRedirect: false,
          statusCode: HttpStatus.ok,
          headers: Headers.fromMap({
            HttpHeaders.contentTypeHeader: [Headers.jsonContentType]
          }),
        ),
      );

      var expectedResponse = http_response.HttpResponse(
          data: data,
          statusCode: HttpStatus.ok,
          headers: {
            HttpHeaders.contentTypeHeader: [Headers.jsonContentType]
          });

      expect(httpResponse.data as Type, isNull);
      expectResponse(httpResponse, expectedResponse);
    });

    test('response when data is Stream and TResponse is Stream', () async {
      var data =
          await getBytesResponseBody(await file1.readAsBytes(), HttpStatus.ok);
      var httpResponse = DioHelper.toHttpResponse<Stream>(
        Response(
          data: data,
          isRedirect: false,
          statusCode: HttpStatus.ok,
          headers: Headers.fromMap({
            HttpHeaders.contentTypeHeader: [
              ContentType.parse('image/png').value
            ]
          }),
        ),
      );

      var expectedResponse = http_response.HttpResponse<Stream<List<int>>>(
          data: file1.openRead(),
          statusCode: HttpStatus.ok,
          headers: {
            HttpHeaders.contentTypeHeader: [
              ContentType.parse('image/png').value
            ]
          });

      await expectStream(
          httpResponse.data as Stream<List<int>>, expectedResponse.data);
      expectResponse(httpResponse, expectedResponse);
    }, timeout: Timeout.none);

    test('response when data is Stream with null value and TResponse is Stream',
        () async {
      var data = await getStreamResponseBody(null, HttpStatus.ok,
          contentTypeHeader: ContentType.parse('image/png').value);
      var httpResponse = DioHelper.toHttpResponse<Stream>(
        Response(
          data: data,
          isRedirect: false,
          statusCode: HttpStatus.ok,
          headers: Headers.fromMap(data.headers),
        ),
      );

      var expectedResponse = http_response.HttpResponse<Stream<List<int>>>(
          data: null,
          statusCode: HttpStatus.ok,
          headers: {
            HttpHeaders.contentTypeHeader: [
              ContentType.parse('image/png').value
            ],
            Headers.contentLengthHeader: [null],
          });

      expect(httpResponse.data, isNull);
      expectResponse(httpResponse, expectedResponse);
    });

    test('response when data is Stream and TResponse is Stream<List<int>>',
        () async {
      var data =
          await getBytesResponseBody(await file1.readAsBytes(), HttpStatus.ok);
      var httpResponse = DioHelper.toHttpResponse<Stream<List<int>>>(
        Response(
          data: data,
          isRedirect: false,
          statusCode: HttpStatus.ok,
          headers: Headers.fromMap({
            HttpHeaders.contentTypeHeader: [
              ContentType.parse('image/png').value
            ]
          }),
        ),
      );

      var expectedResponse = http_response.HttpResponse<Stream<List<int>>>(
          data: file1.openRead(),
          statusCode: HttpStatus.ok,
          headers: {
            HttpHeaders.contentTypeHeader: [
              ContentType.parse('image/png').value
            ]
          });

      await expectStream(httpResponse.data, expectedResponse.data);
      expectResponse(httpResponse, expectedResponse);
    });
  });
}
