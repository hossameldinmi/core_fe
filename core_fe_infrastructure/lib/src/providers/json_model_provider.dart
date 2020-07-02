import 'package:core_fe_flutter/src/models/types.dart';
import 'package:core_fe_infrastructure/src/models/json_model.dart';
import 'package:meta/meta.dart';
import 'package:core_fe_flutter/src/utils/base_module.dart';

abstract class IJsonModelProvider {
  JsonModel<TEntity> call<TEntity>();
  JsonModel<Iterable<TEntity>> iterable<TEntity>();
  JsonModel<Map<String, TEntity>> map<TEntity>();
}

abstract class JsonModelProvider implements IJsonModelProvider {
  JsonModelProvider() {
    register<int>(fromJson: (map) => map as int, toJson: (value) => value);
    register<String>(
        fromJson: (map) => map as String, toJson: (value) => value);
    register<num>(fromJson: (map) => map as num, toJson: (value) => value);
    register<double>(fromJson: (map) => map as num, toJson: (value) => value);
  }

  final Map<Type, JsonModel> _localContext = {};
  // final  container; //Container
  @override
  JsonModel<TEntity> call<TEntity>() {
    JsonModel<TEntity> result = _localContext[TEntity];
    return result;
  }

  void register<TEntity>(
      {@required fromJsonDef<TEntity> fromJson, toJsonDef<TEntity> toJson}) {
    _localContext[TEntity] =
        JsonModel<TEntity>(fromJson: fromJson, toJson: toJson);
  }

  @override
  JsonModel<Iterable<TEntity>> iterable<TEntity>() {
    return JsonModel<Iterable<TEntity>>(
        fromJson: (json) => (json as Iterable)
            ?.map<TEntity>(jsonUtil<TEntity>().fromJson)
            ?.toList(),
        toJson: (list) => list?.map((jsonUtil<TEntity>().toJson)));
  }

  @override
  JsonModel<Map<String, TEntity>> map<TEntity>() {
    return JsonModel<Map<String, TEntity>>(
        fromJson: (map) => (map as Map).map<String, TEntity>((k, v) =>
            MapEntry<String, TEntity>(k, jsonUtil<TEntity>().toJson(v))),
        toJson: (map) => map.map<String, dynamic>((k, v) =>
            MapEntry<String, dynamic>(k, jsonUtil<TEntity>().toJson(v))));
  }
}

final jsonUtil = moduleInstance<IJsonModelProvider>();