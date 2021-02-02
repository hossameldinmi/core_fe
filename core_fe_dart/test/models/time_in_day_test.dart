import 'package:core_fe_dart/src/models/time_in_day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Constructor', () {
    group('Default Constructor', () {
      test('Expected run normaly when Initialize Time with hour = 0', () {
        expect(() => TimeInDay(), returnsNormally);
      });
      test('Expected run normaly when Initialize Time with hour less than 24',
          () {
        expect(() => TimeInDay(hour: 23), returnsNormally);
      });

      test('Expected AssertionError when initialize Time with hour = 24', () {
        expect(() => TimeInDay(hour: 24), throwsAssertionError);
      });

      test(
          'Expected run normaly when initialize Time with hour = 23 and minute with less than 60',
          () {
        expect(() => TimeInDay(hour: 23, minute: 24), returnsNormally);
      });
      test('Expected AssertionError when initialize Time with minute = 60', () {
        expect(() => TimeInDay(hour: 24, minute: 60), throwsAssertionError);
      });
      test(
          'Expected run normaly when initialize Time with hour = 23 and second with less than 60',
          () {
        expect(() => TimeInDay(hour: 23, second: 24), returnsNormally);
      });

      test('Expected AssertionError when initialize Time with second = 60', () {
        expect(() => TimeInDay(hour: 24, second: 60), throwsAssertionError);
      });

      test(
          'Expected run normaly when initialize Time with hour = 23 and millisecond with less than 1000',
          () {
        expect(() => TimeInDay(hour: 23, millisecond: 24), returnsNormally);
        expect(() => TimeInDay(hour: 23, millisecond: 999), returnsNormally);
      });
      test(
          'Expected AssertionError when initialize Time with millisecond = 1000',
          () {
        expect(
            () => TimeInDay(hour: 24, millisecond: 1000), throwsAssertionError);
      });

      test(
          'Expected run normaly when initialize Time with hour = 23 and microsecond with less than 1000',
          () {
        expect(() => TimeInDay(hour: 23, microsecond: 24), returnsNormally);
        expect(() => TimeInDay(hour: 23, microsecond: 999), returnsNormally);
      });

      test(
          'Expected AssertionError when initialize Time with microsecond = 1000',
          () {
        expect(
            () => TimeInDay(hour: 24, microsecond: 1000), throwsAssertionError);
      });
    });
    group('dayPeriod', () {
      test('Expected medNight time when Initialize Time with hour = 12 AM', () {
        var time = TimeInDay.dayPeriod();
        var time2 = TimeInDay.dayPeriod(periodHour: 12, period: DayPeriod.am);
        expect(time, TimeInDay.midNight);
        expect(time2, TimeInDay.midNight);
      });
      test('Expected AssertionError when Initialize Time with hour > 12', () {
        expect(() => TimeInDay.dayPeriod(periodHour: 13), throwsAssertionError);
      });

      test('Expected noon time when Initialize Time with hour = 12 PM', () {
        var time = TimeInDay.dayPeriod(periodHour: 12, period: DayPeriod.pm);
        expect(time, TimeInDay.noon);
      });

      test('Expected hour=hours+12 when Initialize Time with period= PM', () {
        var time = TimeInDay.dayPeriod(periodHour: 6, period: DayPeriod.pm);
        expect(time.hour, 18);
      });

      test('Expected hour=12 when Initialize Time with period=PM and hour=12',
          () {
        var time = TimeInDay.dayPeriod(periodHour: 12, period: DayPeriod.pm);
        expect(time.hour, 12);
        expect(time, equals(TimeInDay.noon));
      });
    });
  });

  group('hour', () {
    test('expected hour=1 if time is exactly 1 hour', () {
      var time = TimeInDay(hour: 1);
      expect(time.hour, 1);
    });
    test(
        'expected exact hour if time has extra minutes,seconds,milliseconds and microseconds',
        () {
      var hour = 3;
      var time = TimeInDay(hour: hour, minute: 30);
      var time2 = TimeInDay(hour: hour, minute: 49);
      var time3 = TimeInDay(hour: hour, minute: 30, second: 20);
      var time4 = TimeInDay(hour: hour, minute: 49, second: 50);
      var time5 =
          TimeInDay(hour: hour, minute: 49, second: 59, millisecond: 45);
      var time6 = TimeInDay(hour: hour, minute: 49, second: 59, millisecond: 1);
      var time7 = TimeInDay(
          hour: hour, minute: 49, second: 59, millisecond: 59, microsecond: 5);
      var time8 = TimeInDay(
          hour: hour, minute: 49, second: 59, millisecond: 59, microsecond: 59);
      expect(time.hour, hour);
      expect(time2.hour, hour);
      expect(time3.hour, hour);
      expect(time4.hour, hour);
      expect(time5.hour, hour);
      expect(time6.hour, hour);
      expect(time7.hour, hour);
      expect(time8.hour, hour);
    });
  });

  group('hourOfPeriod', () {
    test(
        'expected exact hourOfPeriod if time has extra minutes,seconds,milliseconds and microseconds',
        () {
      var time = TimeInDay(hour: 1, minute: 30);
      var time2 = TimeInDay(hour: 12, minute: 49);
      var time3 = TimeInDay(hour: 16, minute: 30, second: 20);
      var time4 = TimeInDay(hour: 23, minute: 49, second: 50);
      var time5 = TimeInDay(hour: 0, minute: 49, second: 50);

      expect(time.hourOfPeriod, 1);
      expect(time2.hourOfPeriod, 12);
      expect(time3.hourOfPeriod, 4);
      expect(time4.hourOfPeriod, 11);
      expect(time5.hourOfPeriod, 12);
    });
  });

  group('period', () {
    test('expected exact dayPeriod', () {
      var time = TimeInDay(hour: 1, minute: 30);
      var time2 = TimeInDay(hour: 12, minute: 49);
      var time3 = TimeInDay(hour: 16, minute: 30, second: 20);
      var time4 = TimeInDay(hour: 23, minute: 49, second: 50);
      var time5 = TimeInDay(hour: 0, minute: 49, second: 50);

      expect(time.period, DayPeriod.am);
      expect(time2.period, DayPeriod.pm);
      expect(time3.period, DayPeriod.pm);
      expect(time4.period, DayPeriod.pm);
      expect(time5.period, DayPeriod.am);
    });
  });
  group('minute', () {
    test('expected exact minute', () {
      var time = TimeInDay(hour: 1, minute: 30);
      var time2 = TimeInDay(hour: 2, minute: 49);
      var time3 = TimeInDay(hour: 23, minute: 59, second: 20);
      var time4 = TimeInDay(hour: 10, minute: 0, second: 50);
      var time5 = TimeInDay(hour: 12, minute: 20, second: 59, millisecond: 45);
      var time6 = TimeInDay(hour: 15, minute: 54, second: 59, millisecond: 1);
      var time7 = TimeInDay(
        minute: 1,
        second: 50,
        millisecond: 59,
        microsecond: 5,
      );
      var time8 = TimeInDay(
        hour: 6,
        minute: 30,
        second: 30,
        millisecond: 59,
        microsecond: 59,
      );
      expect(time.minute, 30);
      expect(time2.minute, 49);
      expect(time3.minute, 59);
      expect(time4.minute, 0);
      expect(time5.minute, 20);
      expect(time6.minute, 54);
      expect(time7.minute, 1);
      expect(time8.minute, 30);
    });
  });

  group('second', () {
    test('expected exact second', () {
      var time = TimeInDay(hour: 1, minute: 30);
      var time2 = TimeInDay(hour: 2, second: 49);
      var time3 = TimeInDay(hour: 23, minute: 59, second: 20);
      var time4 = TimeInDay(hour: 10, minute: 0, second: 50);
      var time5 = TimeInDay(hour: 12, minute: 20, second: 59, millisecond: 45);
      var time6 = TimeInDay(hour: 15, minute: 54, second: 59, millisecond: 1);
      var time7 = TimeInDay(
        minute: 1,
        second: 1,
        millisecond: 59,
        microsecond: 5,
      );
      var time8 = TimeInDay(
        hour: 6,
        minute: 30,
        millisecond: 59,
        microsecond: 59,
      );
      expect(time.second, 0);
      expect(time2.second, 49);
      expect(time3.second, 20);
      expect(time4.second, 50);
      expect(time5.second, 59);
      expect(time6.second, 59);
      expect(time7.second, 1);
      expect(time8.second, 0);
    });
  });

  group('millisecond', () {
    test('expected exact millisecond', () {
      var time = TimeInDay(hour: 1, minute: 30);
      var time2 = TimeInDay(hour: 2, minute: 30, second: 49, millisecond: 49);
      var time3 = TimeInDay(hour: 23, second: 59, millisecond: 20);
      var time4 = TimeInDay(hour: 10, minute: 0, millisecond: 50);
      var time5 = TimeInDay(hour: 12, minute: 20, second: 59, millisecond: 999);
      var time6 = TimeInDay(hour: 15, minute: 54, second: 59, millisecond: 1);
      var time7 = TimeInDay(
        hour: 20,
        minute: 1,
        second: 1,
        microsecond: 500,
      );
      var time8 = TimeInDay(
        hour: 6,
        minute: 30,
        millisecond: 500,
        microsecond: 999,
      );
      expect(time.millisecond, 0);
      expect(time2.millisecond, 49);
      expect(time3.millisecond, 20);
      expect(time4.millisecond, 50);
      expect(time5.millisecond, 999);
      expect(time6.millisecond, 1);
      expect(time7.millisecond, 0);
      expect(time8.millisecond, 500);
    });
  });
  group('toDateTime', () {
    test('expected exact DateTime', () {
      var date = TimeInDay(hour: 1, minute: 30).toDateTime();
      var date2 = TimeInDay(hour: 23, minute: 30, second: 49, millisecond: 49)
          .toDateTime();
      expect(date, DateTime(1900, 1, 1, 1, 30));
      expect(date2, DateTime(1900, 1, 1, 23, 30, 49, 49));
    });
  });

  group('generateByDurations', () {
    test('expected exact Time List', () {
      var list = TimeInDay.generateByDurations(
          TimeInDay.midNight, 24, Duration(hours: 1));
      expect(list, [
        TimeInDay.midNight,
        TimeInDay(hour: 1),
        TimeInDay(hour: 2),
        TimeInDay(hour: 3),
        TimeInDay(hour: 4),
        TimeInDay(hour: 5),
        TimeInDay(hour: 6),
        TimeInDay(hour: 7),
        TimeInDay(hour: 8),
        TimeInDay(hour: 9),
        TimeInDay(hour: 10),
        TimeInDay(hour: 11),
        TimeInDay(hour: 12),
        TimeInDay(hour: 13),
        TimeInDay(hour: 14),
        TimeInDay(hour: 15),
        TimeInDay(hour: 16),
        TimeInDay(hour: 17),
        TimeInDay(hour: 18),
        TimeInDay(hour: 19),
        TimeInDay(hour: 20),
        TimeInDay(hour: 21),
        TimeInDay(hour: 22),
        TimeInDay(hour: 23),
      ]);
    });
    test('expected list with only 1 Time if length = 1', () {
      var list = TimeInDay.generateByDurations(
          TimeInDay.midNight, 1, Duration(hours: 1));
      expect(list, [
        TimeInDay.midNight,
      ]);
    });
    test('expected trimed List if time exceded the day Time', () {
      var list =
          TimeInDay.generateByDurations(TimeInDay.noon, 24, Duration(hours: 1));
      expect(list, [
        TimeInDay(hour: 12),
        TimeInDay(hour: 13),
        TimeInDay(hour: 14),
        TimeInDay(hour: 15),
        TimeInDay(hour: 16),
        TimeInDay(hour: 17),
        TimeInDay(hour: 18),
        TimeInDay(hour: 19),
        TimeInDay(hour: 20),
        TimeInDay(hour: 21),
        TimeInDay(hour: 22),
        TimeInDay(hour: 23),
      ]);
    });

    test('expected exception if time exceded the day Time', () {
      expect(
          () => TimeInDay.generateByDurations(
              TimeInDay.noon, 24, Duration(hours: 1),
              trimIfException: false),
          throwsArgumentError);
    });
  });

  group('isAfter', () {
    test('expcetd true when noon is after midnight', () {
      expect(TimeInDay.noon.isAfter(TimeInDay.midNight), true);
    });
  });

  group('isBefore', () {
    test('expcetd true when noon is after midnight', () {
      expect(TimeInDay.noon.isBefore(TimeInDay(hour: 23)), true);
    });
  });
}
