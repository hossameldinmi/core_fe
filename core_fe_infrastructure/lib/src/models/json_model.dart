import 'package:core_fe_flutter/src/models/types.dart';
import 'package:meta/meta.dart';

class JsonModel<T> {
  final toJsonDef<T> toJson;
  final fromJsonDef<T> fromJson;

  JsonModel({@required this.fromJson, @required this.toJson});
}
