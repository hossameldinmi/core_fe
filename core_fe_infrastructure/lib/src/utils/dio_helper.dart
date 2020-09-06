import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:core_fe_infrastructure/src/models/request_options.dart'
    as request_options;
import 'package:core_fe_infrastructure/src/enums/response_type.dart'
    as response_type;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';
import 'package:core_fe_dart/extensions.dart';
import 'package:rxdart/subjects.dart';
import 'package:tuple/tuple.dart';

class DioHelper {
  static Options toDioOptions(request_options.RequestOptions options,
      [int length]) {
    var headers = <String, dynamic>{};
    if (options.length != null) {
      headers[HttpHeaders.contentLengthHeader] = options.length;
    } else if (length != null) {
      headers[HttpHeaders.contentLengthHeader] = length;
    }
    headers.addAll(options.headers ?? {});
    return Options(
        headers: headers,
        contentType: options.contentType.value,
        responseType: DioHelper.toDioResponseType(options.responseType),
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        validateStatus: options.validateStatus);
  }

  static HttpResponse<TResponse> toHttpResponse<TResponse>(Response response,
      [String savePath]) {
    assert(!response.isNullEmptyOrWhitespace());
    TResponse data;

    // if TResponse is dynamic
    if (TResponse == dynamic) {
      data = response.data;
    } else if (TResponse.toString() == 'void') {
      data = null;
    } else {
      // if data is not null
      if (!(response.data as Object).isNullEmptyOrWhitespace()) {
        if (response.headers[HttpHeaders.contentTypeHeader] // if data is json
            .contains(Headers.jsonContentType)) {
          data = jsonFactory<TResponse>().fromJson(response.data);
        }
        // if data is stream
        else if (response.data is ResponseBody &&
            (response.data as ResponseBody).stream != null) {
          if (TResponse == Stream ||
              TResponse.toString() == 'Stream<dynamic>' ||
              TResponse.toString() == 'Stream<List<int>>' ||
              TResponse.toString() == 'Stream<Uint8List>') {
            StreamController<Uint8List> actualController = BehaviorSubject();
            // data = (response.data as ResponseBody).stream as TResponse;
            var subscription = (response.data as ResponseBody)
                .stream
                .asBroadcastStream()
                .listen(actualController.add);
            subscription.onError(actualController.addError);
            subscription.onDone(actualController.close);
            data = actualController.stream as TResponse;
          }
          // if data
          else if (TResponse == File) {
            data = File(savePath) as TResponse;
          }
        }
      }
    }
    return HttpResponse<TResponse>(
        data: data,
        extra: response.extra,
        isRedirect: response.isRedirect,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        headers: response.headers.map);
  }

  static Future<Tuple2<dynamic, int>> toValidFileObject(dynamic data) async {
    assert(!(data as Object).isNullEmptyOrWhitespace());
    dynamic result;
    int length;
    if (data is Map) {
      var input = ((await DioHelper.toFileCollection(data)) as Map)
          .cast<String, dynamic>();
      result = FormData.fromMap(input);
      length = (result as FormData).length;
    } else if (data is Iterable) {
      result = (await DioHelper.toFileCollection(data) as Iterable)
          .cast<MultipartFile>();
      // length = (result as Iterable<MultipartFile>)
      //     .fold(0, (l, element) => element.length + l);
    } else {
      result = await DioHelper.toMultipartFile(data);
      length = (result as MultipartFile).length;
    }
    return Tuple2(result, length);
  }

  @visibleForTesting
  static Future<dynamic> toFileCollection(dynamic data) async {
    assert(data != null);
    return (data as Object).castAllIn<MultipartFile>(toMultipartFile);
  }

  @visibleForTesting
  static Future<MultipartFile> toMultipartFile(Object value) async {
    assert(value != null);
    // value is File
    if (value is File) {
      return MultipartFile.fromFile(value.path);
    }
    // value is Stream
    else if (value is Stream<List<int>>) {
      return MultipartFile.fromBytes(await value.toBytes());
    }
    // value is bytes
    else if (value is List<int>) {
      return MultipartFile.fromBytes(value);
    }
    // value is bytes
    else if (value is MultipartFile) {
      return Future.value(value);
    } else {
      return null;
    }
  }

  static ResponseType toDioResponseType(
      response_type.ResponseType responseType) {
    switch (responseType) {
      case response_type.ResponseType.json:
        return ResponseType.json;
      case response_type.ResponseType.stream:
        return ResponseType.stream;
      case response_type.ResponseType.bytes:
        return ResponseType.bytes;
      case response_type.ResponseType.plain:
        return ResponseType.plain;
      default:
        return ResponseType.json;
    }
  }
}
