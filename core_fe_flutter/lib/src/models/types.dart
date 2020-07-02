import 'package:core_fe_flutter/src/enums/language.dart';

typedef toDateTimeDef = DateTime Function(String string);
typedef formatterDef = String Function(DateTime dateTime, Language language);
typedef fromJsonDef<T> = T Function(dynamic value);
typedef toJsonDef<T> = dynamic Function(T model);
