import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/extensions.dart';

const timoutProplemSkip = false; //'Timout Proplem';
const ok = 'OK';
const created = 'Created';
const notFound = 'Not Found';
const internalServerError = 'Internal Server Error';
const noInternectConnection = 'No Internet Connection';
// const directory = 'test/assets/'; // test explorer
const directory = './assets/'; // cmd
const imagePath = '${directory}image.png';
const flutterLogo = '${directory}flutter_logo.png';
final file1 = File(imagePath);
final file2 = File(flutterLogo);
Future<void> expectStream(
    Stream<List<int>> actual, Stream<List<int>> expected) async {
  print('expectStream');
  var actualBytes = await actual.toBytes();
  var expectedBytes = await expected.toBytes();
  expect(actualBytes.length, expectedBytes.length);
  expect(actualBytes.lengthInBytes, expectedBytes.lengthInBytes);
  expect(actualBytes, equals(expectedBytes));
}

Future<void> expectMultiepartFile(
    MultipartFile actual, MultipartFile expected) async {
  print('expectMultiepartFile');
  await expectStream(await actual.finalize(), await expected.finalize());
  expect(actual.length, expected.length);
}

ResponseBody getBytesResponseBody(List<int> bytes, int statusCode,
    {String statusMessage,
    bool isRedirect = false,
    String contentTypeHeader = Headers.jsonContentType}) {
  return ResponseBody.fromBytes(bytes, statusCode,
      headers: {
        Headers.contentTypeHeader: [contentTypeHeader],
        Headers.contentLengthHeader: [(bytes?.length).toString()],
      },
      isRedirect: isRedirect,
      statusMessage: statusMessage);
}

Future<ResponseBody> getStreamResponseBody(
    Stream<Uint8List> stream, int statusCode,
    {String statusMessage,
    bool isRedirect = false,
    String contentTypeHeader}) async {
  return ResponseBody(stream, statusCode,
      headers: {
        Headers.contentTypeHeader: [
          contentTypeHeader ?? ContentType.binary.value
        ],
        Headers.contentLengthHeader: [(await stream?.length)?.toString()],
      },
      isRedirect: isRedirect,
      statusMessage: statusMessage);
}
