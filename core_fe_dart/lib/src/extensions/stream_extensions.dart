import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

extension StreamExtensions<T> on Stream<T> {
  Stream<T> onEvent(void Function(T) action) {
    return map((e) {
      action(e);
      return e;
    });
  }
}

extension ListStreamExtensions<T> on Stream<Iterable<T>> {
  Stream<List<T>> whereItemInList(bool Function(T) test) =>
      map((e) => e.where(test).toList());
}

extension ByteStreamExtensions on Stream<List<int>> {
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
