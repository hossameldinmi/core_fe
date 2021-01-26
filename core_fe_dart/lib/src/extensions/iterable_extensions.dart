import 'package:collection/collection.dart';

extension IterableExtensions<T> on Iterable<T> {
  bool equals(Iterable<T> other,
      {Equality<T> elementEquality = const DefaultEquality(),
      bool isOrderEquality = true}) {
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

  Future<List<R>> asyncMap<R>(Future<R> Function(T) mapFunc) async {
    assert(mapFunc != null);
    var list = <R>[];
    for (var item in this) {
      list.add(await mapFunc(item));
    }
    return list;
  }

  Future<void> asyncForEach<R>(Future<void> Function(T) action) {
    assert(action != null);
    return Future.forEach(this, action);
  }
}

extension ListExtension<T> on List<T> {
  void addOrUpdate(T newElement, {bool Function(T) test}) {
    test ??= (e) => e == newElement;
    var oldObject = firstWhereOrDefault(test);
    if (oldObject == null) {
      add(newElement);
    } else {
      replaceWith(oldObject, newElement);
    }
  }

  List<T> replaceManyWith(List<T> other, bool Function(T old, T newItem) test) {
    var newList = [];
    forEach((old) {
      var matchedItem = other.firstWhereOrDefault((newItem) {
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

  void replaceWhere(
      bool Function(T) test, T Function(T oldObject) newElementFactory) {
    where(test).forEach((old) => replaceWith(old, newElementFactory(old)));
  }

  void replaceWith(T old, T newElement) {
    var index = indexOf(old);
    this[index] = newElement;
  }

  T firstWhereOrDefault(bool Function(T) test, {T Function() orElse}) {
    orElse ??= () => null;

    return firstWhere(test, orElse: orElse);
  }

  T firstWhereOrDefaultIndexed(bool Function(T, int) test,
      {T Function() orElse}) {
    for (var i = 0; i < length; i++) {
      var item = this[i];
      if (test(this[i], i)) {
        return item;
      }
    }
    orElse ??= () => null;
    return null;
  }
}

extension MapExtensions<TKey, TValue> on Map<TKey, TValue> {
  bool equals(Map<TKey, TValue> other,
      {Equality<TKey> keyEquality = const DefaultEquality(),
      Equality<TValue> valueEquality = const DefaultEquality()}) {
    var listEquality =
        MapEquality<TKey, TValue>(keys: keyEquality, values: valueEquality);
    return listEquality.equals(this, other);
  }

  Map<TKey, TValue> intersection(Map<TKey, TValue> other) {
    var map = <TKey, TValue>{};
    forEach((key, value) {
      if (other.containsKey(key) && other[key] == value) {
        map[key] = value;
      }
    });
    return map;
  }

  Future<Map<TKey2, TValue2>> asyncMap<TKey2, TValue2>(
      Future<MapEntry<TKey2, TValue2>> Function(MapEntry<TKey, TValue>)
          convert) {
    return entries.asyncMap(convert).then((list) => Map.fromEntries(list));
  }

  Future<void> asyncForEach(
      Future<void> Function(MapEntry<TKey, TValue>) action) {
    return entries.asyncForEach(action);
  }
}

extension ItemFold on Object {
  dynamic castAllInSync<T>(T Function(dynamic) castCallBack) {
    print('Calling castAllInSync<$T>');
    var data = this;
    if (data == null) return null;
    if (data is Map) {
      var map = {};
      for (var key in data.keys) {
        map[key] = (data[key] as Object).castAllInSync(castCallBack);
      }
      return map;
    } else if (data is List) {
      var list = [];
      for (var element in data) {
        list.add((element as Object).castAllInSync(castCallBack));
      }
      return list;
    } else {
      return castCallBack(data);
    }
  }

  Future<dynamic> castAllIn<T>(Future<T> Function(dynamic) castCallBack) async {
    print('Calling castAllIn<&$T>');
    var data = this;
    if (data == null) return Future.value();
    if (data is Map) {
      var map = {};
      for (var key in data.keys) {
        map[key] = await (data[key] as Object).castAllIn(castCallBack);
      }
      return map;
    } else if (data is List) {
      var list = [];
      for (var element in data) {
        list.add(await (element as Object).castAllIn(castCallBack));
      }
      return list;
    } else {
      return castCallBack(data);
    }
  }
}
