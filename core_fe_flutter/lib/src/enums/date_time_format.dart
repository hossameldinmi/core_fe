import 'package:core_fe_dart/enums.dart';
import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_flutter/models.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class DateTimeFormat extends Enum {
  final String format;
  final ToDateTimeFunc _toDateTimeFunc;
  ToDateTimeFunc get toDateTimeFunc => _toDateTimeFunc ?? _parseToDateTime;
  final DateFormatterFunc _formatterFunc;
  DateFormatterFunc get formatterFunc =>
      _formatterFunc ??
      (DateTime date, Language lang) => _format(date, format, lang.locale);

  const DateTimeFormat(int key,
      {@required this.format,
      ToDateTimeFunc toDateTimeFunc,
      DateFormatterFunc formatterFunc})
      : _toDateTimeFunc = toDateTimeFunc,
        _formatterFunc = formatterFunc,
        super();

  /// [yyyy-MM-ddTHH:mm:ss.mmmuuu[Z]
  /// non Localized format
  static DateTimeFormat isoFormat = DateTimeFormat(
    1,
    format: 'yyyy-MM-ddTHH:mm:ss.mmmuuuZ',
    toDateTimeFunc: (String dateStr) => _parseToDateTime(dateStr).toLocal(),
    formatterFunc: (DateTime date, Language language) =>
        date.toUtc().toIso8601String(),
  );

  static final values = [isoFormat];

  /// [yyyy-MM-dd]
  static const DateTimeFormat shortDateFormat = DateTimeFormat(
    1,
    format: 'yyyy-MM-dd',
  );

  static String _format(DateTime date, String format, String locale) {
    return DateFormat(format, locale).format(date);
  }

  static DateTime _parseToDateTime(String dateTimeStr) {
    return DateTime.tryParse(dateTimeStr);
  }

  @override
  List<Object> get props => [format];
}
