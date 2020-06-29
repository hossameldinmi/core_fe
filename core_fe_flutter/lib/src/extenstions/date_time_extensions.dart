import 'dart:core';
import 'package:core_fe_flutter/src/enums/date_time_format.dart';
import 'package:core_fe_flutter/src/enums/language.dart';

extension DateTimeExtension on DateTime {
  String format({DateTimeFormat format, Language language = Language.en_US}) {
    format ??= DateTimeFormat.isoFormat;
    return format.formatter(this, language);
  }
}

extension StringDateTimeFormatExtension on String {
  DateTime parseToDateTime({DateTimeFormat formatIn}) {
    formatIn ??= DateTimeFormat.isoFormat;
    return _parseToDateTime(this, formatIn);
  }

  DateTime _parseToDateTime(String dateStr, DateTimeFormat formatIn) {
    var date = formatIn.toDateTimeCallback(dateStr);
    return date;
  }

  String reformatDate(
      {DateTimeFormat dateFormatIn,
      DateTimeFormat dateFormatOut,
      Language language = Language.en_US}) {
    var date = parseToDateTime(formatIn: dateFormatIn);
    return date.format(format: dateFormatOut, language: language);
  }
}
