import 'package:collection/collection.dart';
import 'iterable_extensions.dart';

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
              convert) =>
      entries.asyncMap(convert).then((list) => Map.fromEntries(list));

  Future<void> asyncForEach(
          Future<void> Function(MapEntry<TKey, TValue>) action) =>
      entries.asyncForEach(action);
}
