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
    var intersection = where((element) => other.contains(element));
    return intersection;
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
}
