import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class AsyncSnapshot<T> extends Equatable {
  final T data;
  final dynamic error;
  final int index;

  AsyncSnapshot(this.data, this.index) : error = null;
  AsyncSnapshot.error(this.error, this.index) : data = null;
  bool get hasError => _hasValue(error);

  bool get hasData => _hasValue(data);

  bool _hasValue(dynamic e) {
    return e != null;
  }

  @override
  String toString() => {
        'index': index,
        'data': data,
        'error': error,
      }.toString();

  @override
  List<Object> get props => [index, data, error];
}

@immutable
class AsyncSnapshotGroup<T> extends Equatable {
  final Iterable<AsyncSnapshot<T>> _results;
  AsyncSnapshotGroup(this._results);
  bool get hasErrors => _results.any((r) => r.hasError);
  bool get hasData => _results != null && _results.any((r) => r.hasData);
  List<dynamic> get errors =>
      _results?.where((r) => r.hasError)?.map((r) => r.error)?.toList();

  Iterable<AsyncSnapshot<T>> results({bool orderByComplete = false}) {
    if (orderByComplete) {
      var list = _results.toList();
      list.sort((r1, r2) => r1.index.compareTo(r2.index));
      return list;
    }
    return _results;
  }

  List<T> data({bool orderByComplete = false, bool ignoreErrorResults = true}) {
    return results(orderByComplete: orderByComplete)
            ?.where((r) => r.hasData || (!ignoreErrorResults && r.hasError))
            ?.map((r) => r.data)
            ?.toList() ??
        <T>[];
  }

  @override
  List<Object> get props => [_results];
}
