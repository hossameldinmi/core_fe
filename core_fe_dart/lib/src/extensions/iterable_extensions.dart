import 'package:collection/collection.dart';

extension IterableExtensions<T> on Iterable<T> {
  bool isEqual(Iterable<T> other,
      {Equality<T> elementEquality = const DefaultEquality(), bool isOrderEquality = true}) {
    if (isOrderEquality) {
      return IterableEquality<T>(elementEquality).equals(this, other);
    } else {
      return UnorderedIterableEquality<T>(elementEquality).equals(this, other);
    }
  }

  Iterable<T> intersection(Iterable<T> other) {
    return where(other.contains);
  }

  Iterable<T> distinct(Iterable<T> other) {
    var list = where((i) => !other.contains(i)).toList();
    list.addAll(other.where((i) => !contains(i)));
    return list;
  }

  List<R> indexMap<R>(R Function(int, T) mapFunc) {
    List<R>? list;
    list ??= <R>[];
    for (var i = 0; i < length; i++) {
      list.add(mapFunc(i, elementAt(i)));
    }
    return list;
  }

  Future<List<R>> asyncMap<R>(Future<R> Function(T) mapFunc) async {
    var list = <R>[];
    for (var item in this) {
      list.add(await mapFunc(item));
    }
    return list;
  }

  Future<void> asyncForEach<R>(Future<void> Function(T) action) {
    return Future.forEach(this, action);
  }
}

extension ListExtension<T> on List<T> {
  void addOrUpdate(T newElement, {bool Function(T)? test}) {
    test ??= (e) => e == newElement;
    var oldObject = firstWhereOrNull(test);
    if (oldObject == null) {
      add(newElement);
    } else {
      replaceWith(oldObject, newElement);
    }
  }

  List<T> replaceManyWith(List<T> other, bool Function(T old, T newItem) test) {
    var newList = <T>[];
    forEach((old) {
      var matchedItem = other.firstWhereOrNull((newItem) {
        return test(old, newItem);
      });
      if (matchedItem != null) {
        newList.add(matchedItem);
      } else {
        newList.add(old);
      }
    });
    return newList;
  }

  void replaceWhere(bool Function(T) test, T Function(T oldObject) newElementFactory) {
    where(test).forEach((old) => replaceWith(old, newElementFactory(old)));
  }

  void replaceWith(T old, T newElement) {
    var index = indexOf(old);
    this[index] = newElement;
  }

  T? firstWhereOrNullIndexed(bool Function(T, int) test, {T? Function()? orElse}) {
    for (var i = 0; i < length; i++) {
      var item = this[i];
      if (test(this[i], i)) {
        return item;
      }
    }
    orElse ??= () => null;
    return orElse();
  }

  Iterable<T> removeNotExisting(Iterable<T> updated, [bool Function(T original, T updated)? test]) {
    test ??= (c, e) => c == e;
    List<T>? removed;
    if (updated.isEmpty) {
      removed = toList();
      clear();
      return removed;
    }
    removed ??= [];
    removeWhere((o) {
      var isExist = updated.any((u) => test!(o, u));
      if (!isExist) {
        removed!.add(o);
      }
      return !isExist;
    });
    return removed;
  }
}
