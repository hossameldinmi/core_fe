import 'package:core_fe_flutter/src/enums/language.dart';

typedef ToDateTimeFunc = DateTime Function(String string);
typedef FormatterFunc = String Function(DateTime dateTime, Language language);
typedef FromJsonFunc<T> = T Function(dynamic value);
typedef ToJsonFunc<T> = dynamic Function(T model);
