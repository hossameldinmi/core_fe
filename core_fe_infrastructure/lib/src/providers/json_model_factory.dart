import 'package:core_fe_flutter/models.dart';
import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_infrastructure/src/models/json_model.dart';
import 'package:meta/meta.dart';

abstract class IJsonModelFactory {
  JsonModel<TEntity> call<TEntity>();
  JsonModel<Iterable<TEntity>> iterable<TEntity>();
  JsonModel<Map<TKey, TEntity>> map<TKey, TEntity>();
}

class JsonModelFactory implements IJsonModelFactory {
  JsonModelFactory() {
    register<int>(
      fromJson: (json) => json as int,
      toJson: (value) => value,
    );
    register<String>(
      fromJson: (json) => json as String,
      toJson: (value) => value,
    );
    register<num>(
      fromJson: (json) => json as num,
      toJson: (value) => value,
    );
    register<double>(
      fromJson: (json) => json as double,
      toJson: (value) => value,
    );
    register<dynamic>(
      fromJson: (json) => json,
      toJson: (value) => value,
    );
  }

  final Map<Type, JsonModel> _localContext = {};
  // final  container; //Container
  @override
  JsonModel<TEntity> call<TEntity>() {
    JsonModel<TEntity> result = _localContext[TEntity];
    return result;
  }

  void register<TEntity>(
      {@required FromJsonFunc<TEntity> fromJson, ToJsonFunc<TEntity> toJson}) {
    _localContext[TEntity] =
        JsonModel<TEntity>(fromJson: fromJson, toJson: toJson);
  }

  @override
  JsonModel<Iterable<TEntity>> iterable<TEntity>() {
    return JsonModel<Iterable<TEntity>>(
      fromJson: (json) => (json as Iterable)
          ?.map<TEntity>(jsonFactory<TEntity>().fromJson)
          ?.toList(),
      toJson: (list) => list?.map(jsonFactory<TEntity>().toJson),
    );
  }

  @override
  JsonModel<Map<TKey, TEntity>> map<TKey, TEntity>() {
    return JsonModel<Map<TKey, TEntity>>(
      fromJson: (map) => (map as Map).map<TKey, TEntity>(
        (k, v) => MapEntry<TKey, TEntity>(
          jsonFactory<TKey>().fromJson(k),
          jsonFactory<TEntity>().fromJson(v),
        ),
      ),
      toJson: (map) => map.map<TKey, dynamic>(
        (k, v) => MapEntry<TKey, dynamic>(
          jsonFactory<TKey>().toJson(k),
          jsonFactory<TEntity>().toJson(v),
        ),
      ),
    );
  }
}

final jsonFactory = factoryInstance<IJsonModelFactory>();
