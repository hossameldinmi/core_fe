import 'package:core_fe_flutter/src/enums/date_time_format.dart';
import 'package:core_fe_flutter/src/enums/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_flutter/src/extenstions/date_time_extensions.dart';

void _format(DateTime date, DateTimeFormat format, String expectedDateStr,
    [Language language = Language.en_US]) {
  expect(date.format(format: format, language: language), expectedDateStr);
}

void _parse(DateTime expectedDate, DateTimeFormat format, String dateStr) {
  expect(dateStr.parseToDateTime(formatIn: format), expectedDate);
}

void main() {
  final date = DateTime.utc(2020, 12, 13, 14, 15, 16, 170, 180);
  final date2 = DateTime.utc(2020, 6, 6, 6, 6, 6, 6, 6);
  DateTimeFormat _dateTimeFormat;
  // yyyy-MM-ddTHH:mm:ss.mmmuuuZ
  group('isoFormat', () {
    setUp(() {
      _dateTimeFormat = DateTimeFormat.isoFormat;
    });

    group('Formatting', () {
      test('expected UTC isoFormat EN formatting ', () {
        _format(date, _dateTimeFormat, '2020-12-13T14:15:16.170180Z');
        _format(date2, _dateTimeFormat, '2020-06-06T06:06:06.006006Z');
      });
    });

    group('Parsing', () {
      test('expected UTC isoFormat EN parsing ', () {
        _parse(date.toLocal(), _dateTimeFormat, '2020-12-13T14:15:16.170180Z');
        _parse(date2.toLocal(), _dateTimeFormat, '2020-06-06T06:06:06.006006Z');
      });
    });
  });
}
