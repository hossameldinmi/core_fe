import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

extension StreamExtensions<T> on Stream<T?> {
  Stream<T?> onEvent(void Function(T?) action) {
    return map((e) {
      action(e);
      return e;
    });
  }
}

extension ListStreamExtensions<T> on Stream<Iterable<T>> {
  Stream<Iterable<T>> whereInIterableEvent(bool Function(T) test) => map((e) => e.where(test));

  Stream<Iterable<R>> mapIterableEvent<R>(R Function(T) mapper) => map((e) => e.map<R>(mapper));

  Stream<List<T>> mapIterableEventToList() => map((e) => e.toList());
}

extension ByteStreamExtensions on Stream<List<int>> {
  Future<Uint8List> toBytes() {
    var completer = Completer<Uint8List>();
    var sink = ByteConversionSink.withCallback((bytes) {
      return completer.complete(Uint8List.fromList(bytes));
    });
    listen(sink.add, onError: completer.completeError, onDone: sink.close, cancelOnError: true);
    return completer.future;
  }
}
