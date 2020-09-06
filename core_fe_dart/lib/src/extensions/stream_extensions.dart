import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

extension StreamExtensions on Stream<List<int>> {
  Future<Uint8List> toBytes() {
    var completer = Completer<Uint8List>();
    var sink = ByteConversionSink.withCallback((bytes) {
      print('toBytes:Done');
      return completer.complete(Uint8List.fromList(bytes));
    });
    listen(sink.add,
        onError: completer.completeError,
        onDone: sink.close,
        cancelOnError: true);
    return completer.future;
  }
}
