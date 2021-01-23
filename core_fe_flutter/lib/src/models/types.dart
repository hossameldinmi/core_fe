import 'package:core_fe_flutter/src/enums/language.dart';

typedef ToDurationFunc = Duration Function(String string);
typedef DurationFormatterFunc = String Function(
    Duration duration, Language language);
typedef ToDateTimeFunc = DateTime Function(String string);
typedef DateFormatterFunc = String Function(
    DateTime dateTime, Language language);
typedef FromJsonFunc<T> = T Function(dynamic value);
typedef ToJsonFunc<T> = dynamic Function(T model);
