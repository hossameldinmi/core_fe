import 'package:core_fe_flutter/models.dart';
import 'package:core_fe_infrastructure/src/models/json_model.dart';

class JsonUtil {
  static final _intJson = JsonModel<int>(
    fromJson: (json) => json as int,
    toJson: (value) => value,
  );
  static final _stringJson = JsonModel<String>(
    fromJson: (json) => json as String,
    toJson: (value) => value,
  );
  static final _numJson = JsonModel<num>(
    fromJson: (json) => json as num,
    toJson: (value) => value,
  );
  static final _doubleJson = JsonModel<double>(
    fromJson: (json) => json as double,
    toJson: (value) => value,
  );
  static final _dynamicJson = JsonModel<dynamic>(
    fromJson: (json) => json,
    toJson: (value) => value,
  );

  // final  container; //Container
  static JsonModel<TEntity> getType<TEntity>() {
    switch (TEntity) {
      case int:
        return _intJson as JsonModel<TEntity>;
      case String:
        return _stringJson as JsonModel<TEntity>;
      case num:
        return _numJson as JsonModel<TEntity>;
      case double:
        return _doubleJson as JsonModel<TEntity>;
      case dynamic:
        return _dynamicJson as JsonModel<TEntity>;
      default:
        throw ArgumentError('Key [$TEntity] is not a premitive type');
    }
  }

  static JsonModel<Iterable<TEntity>> getIterable<TEntity>({
    ToJsonFunc<TEntity> toJson,
    FromJsonFunc<TEntity> fromJson,
  }) {
    return JsonModel<Iterable<TEntity>>(
      fromJson: (json) => (json as Iterable)
          ?.map<TEntity>(fromJson ?? getType<TEntity>().fromJson)
          ?.toList(),
      toJson: (list) => list?.map(toJson ?? getType<TEntity>().toJson),
    );
  }

  static JsonModel<Map<TKey, TEntity>> getMap<TKey, TEntity>({
    ToJsonFunc<TKey> keyToJson,
    FromJsonFunc<TKey> keyFromJson,
    ToJsonFunc<TEntity> valueToJson,
    FromJsonFunc<TEntity> valueFromJson,
  }) {
    return JsonModel<Map<TKey, TEntity>>(
      fromJson: (map) => (map as Map).map<TKey, TEntity>(
        (k, v) => MapEntry<TKey, TEntity>(
          keyToJson ?? getType<TKey>().fromJson(k),
          keyFromJson ?? getType<TEntity>().fromJson(v),
        ),
      ),
      toJson: (map) => map.map<TKey, TEntity>(
        (k, v) => MapEntry<TKey, TEntity>(
          valueToJson ?? getType<TKey>().toJson(k),
          valueFromJson ?? getType<TEntity>().toJson(v),
        ),
      ),
    );
  }
}
