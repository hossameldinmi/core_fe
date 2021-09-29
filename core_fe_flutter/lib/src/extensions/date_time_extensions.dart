import 'dart:core';
import 'package:core_fe_flutter/src/enums/language.dart';
import 'package:core_fe_flutter/src/enums/date_time_format.dart';

extension DateTimeExtension on DateTime {
  /// format DateTime object to specific string format
  /// [format]: output format, default is [DateTimeFormat.isoFormat]
  /// [language] can be inserted to return the desired localized string default:[Language.enUS]
  /// ```
  ///     var date=DateTime(2020, 12, 13, 14, 15, 16, 170, 180);
  ///     date.format();                                                               // 2020-12-13T14:15:16.170180Z
  ///     date.format(format:DateTimeFormat.shortDateFormat);                          // 2020-12-13
  ///     date.format(format:DateTimeFormat.shortDateFormat,language:Language.arEG);  //٢٠٢٠–١٢–١٣
  /// ```
  String format({DateTimeFormat? format, Language language = Language.enUS}) {
    format ??= DateTimeFormat.isoFormat;
    return format.formatterFunc(this, language);
  }

  /// reset duration to covert DateTime object to date Only
  /// If the DateTime is Utc, this method will also return Utc and reset duration.
  /// ```
  ///     var date=DateTime(2020, 12, 13, 14, 15, 16, 170, 180);
  ///     date.toDate(); => /// 'DateTime(2020, 12, 13, 0, 0, 0, 0, 0)'
  ///
  ///     var dateUtc=DateTime.utc(2020, 12, 13, 14, 15, 16, 170, 180);
  ///     dateUtc.toDate(); => /// `DateTime.utc(2020, 12, 13, 0, 0, 0, 0, 0)`
  /// ```
  DateTime toDate() {
    if (isUtc) {
      return DateTime.utc(year, month, day);
    }
    return DateTime(year, month, day);
  }
}

extension StringDateTimeFormatExtension on String {
  /// parse string from certain format to DateTime object
  /// [formatIn]: String input format, default is [DateTimeFormat.isoFormat]
  DateTime? parseToDateTime({DateTimeFormat? formatIn}) {
    formatIn ??= DateTimeFormat.isoFormat;
    var date = formatIn.toDateTimeFunc(this);
    return date;
  }
}
