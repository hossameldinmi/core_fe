import 'package:core_fe_flutter/src/models/types.dart';
import 'package:meta/meta.dart';

@immutable
class JsonModel<T> {
  final ToJsonFunc<T> toJson;
  final FromJsonFunc<T> fromJson;

  JsonModel({@required this.fromJson, @required this.toJson});
}
