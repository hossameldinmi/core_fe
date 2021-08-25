import 'package:core_fe_dart/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/src/extensions/date_time_extensions.dart';

void main() {
  group('isSameDate', () {
    test('expected true if date = Now', () {
      var date = DateTime.now();
      expect(date.isSameDate(date), true);
    });

    test('expected true if same date', () {
      var date = DateTime(2020, 1, 2, 3, 4, 5);
      var date2 = DateTime(2020, 1, 2, 20, 4, 5);
      expect(date.isSameDate(date2), true);
    });

    test('expected false if NOT same date', () {
      var date = DateTime(2020, 1, 2, 3, 4, 5);
      var date2 = DateTime(2020, 1, 3, 20, 4, 5);
      expect(date.isSameDate(date2), false);
    });
  });

  group('resetDate', () {
    test('expected newDate when resetting', () {
      var date = DateTime(2020, 1, 2, 3, 4, 5);
      var actual = date.resetDate(DateTime(2020, 1, 3));
      var expectedDate = DateTime(2020, 1, 3, 3, 4, 5);
      expect(actual, expectedDate);
    });

    test('expected UTC newDate when resetting with UTC date', () {
      var date = DateTime(2020, 1, 2, 3, 4, 5);
      var actual = date.resetDate(DateTime.utc(2020, 1, 3));
      var expectedDate = DateTime.utc(2020, 1, 3, 3, 4, 5);
      expect(actual, expectedDate);
      expect(actual.isUtc, expectedDate.isUtc);
    });

    test('expected newDate and ignoring new hours and minutes when resetting',
        () {
      var date = DateTime(2020, 1, 2, 3, 4, 5);
      var actual = date.resetDate(DateTime(2020, 1, 3, 5, 7, 8));
      var expectedDate = DateTime(2020, 1, 3, 3, 4, 5);
      expect(actual, expectedDate);
    });
  });

  group('resetTime', () {
    test('expected newDate when resetting', () {
      var date = DateTime(2020, 1, 2, 3, 4, 5);
      var actual = date.resetTime(TimeInDay(
          hour: 5, minute: 6, second: 2, millisecond: 3, microsecond: 5));
      var expectedDate = DateTime(2020, 1, 2, 5, 6, 2, 3, 5);
      expect(actual, expectedDate);
    });

    test('expected UTC newDate when resetting ', () {
      var date = DateTime.utc(2020, 1, 2, 3, 4, 5);
      var actual = date.resetTime(TimeInDay(
          hour: 5, minute: 6, second: 2, millisecond: 3, microsecond: 5));
      var expectedDate = DateTime.utc(2020, 1, 2, 5, 6, 2, 3, 5);
      expect(actual, expectedDate);
      expect(actual.isUtc, expectedDate.isUtc);
    });

    test('expected midnight Time when not passing time argument', () {
      var date = DateTime(2020, 1, 2, 3, 4, 5);
      var expected = DateTime(2020, 1, 2);
      expect(date.resetTime(), expected);
    });
  });

  group('isToday', () {
    test('expected true when date is now', () {
      expect(DateTime.now().isToday(), true);
      expect(DateTime.now().resetTime().isToday(), true);
    });

    test('expected false when date is NOT today', () {
      var date = DateTime.now().subtract(Duration(days: 1));
      expect(date.isToday(), false);
    });
  });
}
