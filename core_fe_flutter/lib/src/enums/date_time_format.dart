import 'package:core_fe_dart/core_fe_dart.dart';
import 'package:core_fe_flutter/src/enums/language.dart';
import 'package:core_fe_flutter/src/models/types.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';

class DateTimeFormat extends Enum<int, DateTimeFormat> {
  final String format;
  final ToDateTimeFunc toDateTimeFunc;
  final FormatterFunc formatterFunc;

  const DateTimeFormat(int key,
      {@required this.format,
      @required this.toDateTimeFunc,
      @required this.formatterFunc})
      : super(key);

  /// [yyyy-MM-ddTHH:mm:ss.mmmuuu[Z]
  /// non Localized format
  static DateTimeFormat isoFormat = DateTimeFormat(
    1,
    format: 'yyyy-MM-ddTHH:mm:ss.mmmuuuZ',
    toDateTimeFunc: (String dateStr) => _parseToDateTime(dateStr).toLocal(),
    formatterFunc: (DateTime date, Language language) =>
        date.toUtc().toIso8601String(),
  );

  static DateTimeFormat shortDateFormat = DateTimeFormat(
    1,
    format: 'yyyy-MM-dd',
    toDateTimeFunc: (String dateStr) => _parseToDateTime(dateStr).toLocal(),
    formatterFunc: (DateTime date, Language language) =>
        _format(date.toLocal(), 'yyyy-MM-dd', language.toLocale()),
  );

  static String _format(DateTime date, String format, String locale) {
    return DateFormat(format, locale).format(date);
  }

  static DateTime _parseToDateTime(String dateTimeStr) {
    return DateTime.tryParse(dateTimeStr);
  }
}
