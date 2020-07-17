import 'package:core_fe_dart/core_fe_dart.dart';
import 'package:core_fe_flutter/src/enums/language.dart';
import 'package:core_fe_flutter/src/models/types.dart';
// import 'package:intl/intl.dart';

class DateTimeFormat extends Enum<int, DateTimeFormat> {
  final String format;
  final ToDateTimeFunc toDateTimeCallback;
  final FormatterFunc formatter;

  const DateTimeFormat(
      int key, this.format, this.toDateTimeCallback, this.formatter)
      : super(key);

  /// [yyyy-MM-ddTHH:mm:ss.mmmuuu[Z]
  /// non Localized format
  static DateTimeFormat isoFormat = DateTimeFormat(
    1,
    'yyyy-MM-ddTHH:mm:ss.mmmuuuZ',
    (String dateStr) => _parseToDateTime(dateStr).toLocal(),
    (DateTime date, Language language) => date.toUtc().toIso8601String(),
  );

  // static String _format(DateTime date, String format, String locale) {
  //   return DateFormat(format, locale).format(date);
  // }

  static DateTime _parseToDateTime(String dateTimeStr) {
    return DateTime.tryParse(dateTimeStr);
  }
}
