import 'package:core_fe_flutter/src/enums/date_time_format.dart';
import 'package:core_fe_flutter/src/enums/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_flutter/src/extenstions/date_time_extensions.dart';
import 'package:intl/date_symbol_data_local.dart';

void _format(DateTime date, DateTimeFormat format, String expectedDateStr,
    [Language language = Language.en_US]) {
  expect(date.format(format: format, language: language), expectedDateStr);
}

void _parse(DateTime expectedDate, DateTimeFormat format, String dateStr) {
  expect(dateStr.parseToDateTime(formatIn: format), expectedDate);
}

void main() async {
  await initializeDateFormatting(Language.en_US.toLocale());
  final date = DateTime(2020, 12, 13, 14, 15, 16, 170, 180);
  final date2 = DateTime(2020, 6, 6, 6, 6, 6, 6, 6);
  final dateUtc = DateTime.utc(2020, 12, 13, 14, 15, 16, 170, 180);
  final dateUtc2 = DateTime.utc(2020, 6, 6, 6, 6, 6, 6, 6);

  DateTimeFormat _dateTimeFormat;

  test('toDate only', () {
    expect(date.toDate(), DateTime(2020, 12, 13));
    expect(date2.toDate(), DateTime(2020, 6, 6));
    expect(dateUtc.toDate(), DateTime.utc(2020, 12, 13));
    expect(dateUtc2.toDate(), DateTime.utc(2020, 6, 6));
  });
  test('default format', () {
    expect(dateUtc.format(), '2020-12-13T14:15:16.170180Z');
  });
  test('default parsing format', () {
    expect('2020-12-13T14:15:16.170180Z'.parseToDateTime(), dateUtc.toLocal());
  });

  // yyyy-MM-ddTHH:mm:ss.mmmuuuZ
  group('isoFormat', () {
    setUp(() {
      _dateTimeFormat = DateTimeFormat.isoFormat;
    });

    group('Formatting', () {
      test('expected UTC isoFormat EN formatting ', () {
        _format(dateUtc, _dateTimeFormat, '2020-12-13T14:15:16.170180Z');
        _format(dateUtc2, _dateTimeFormat, '2020-06-06T06:06:06.006006Z');
      });
    });

    group('Parsing', () {
      test('expected UTC isoFormat EN parsing ', () {
        _parse(
            dateUtc.toLocal(), _dateTimeFormat, '2020-12-13T14:15:16.170180Z');
        _parse(
            dateUtc2.toLocal(), _dateTimeFormat, '2020-06-06T06:06:06.006006Z');
      });
    });
  });

  group('shortDateFormat', () {
    setUp(() {
      _dateTimeFormat = DateTimeFormat.shortDateFormat;
    });
    final dateStr = '2020-12-13';
    final date2Str = '2020-06-06';

    group('Formatting', () {
      test('expected shortDateFormat EN formatting ', () {
        _format(date, _dateTimeFormat, dateStr);
        _format(date2, _dateTimeFormat, date2Str);
      });
    });
    group('Parsing', () {
      test('expected shortDateFormat EN parsing ', () {
        _parse(date.toDate(), _dateTimeFormat, dateStr);
        _parse(date2.toDate(), _dateTimeFormat, date2Str);
      });
    });
  });
  group('reformating', () {
    test('reformating from isoFormat to shortDateFormat', () {
      final dateStr = '2020-12-13T14:15:16.170180Z';
      final expected = '2020-12-13';
      var actual =
          dateStr.reformatDate(dateFormatOut: DateTimeFormat.shortDateFormat);
      expect(actual, expected);
    });
  });
}
