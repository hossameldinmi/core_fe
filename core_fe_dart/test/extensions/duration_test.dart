import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/src/extensions/duration_extensions.dart';

void main() {
  group('hour', () {
    test('expected hour=1 if duration is exactly 1 hour', () {
      var duration = Duration(hours: 1);
      expect(duration.inHours, 1);
    });
    test(
        'expected exact hour if duration has extra minutes,seconds,milliseconds and microseconds',
        () {
      var hour = 3;
      var duration = Duration(hours: hour, minutes: 30);
      var duration2 = Duration(hours: hour, minutes: 49);
      var duration3 = Duration(hours: hour, minutes: 30, seconds: 20);
      var duration4 = Duration(hours: hour, minutes: 49, seconds: 50);
      var duration5 =
          Duration(hours: hour, minutes: 49, seconds: 59, milliseconds: 45);
      var duration6 =
          Duration(hours: hour, minutes: 49, seconds: 59, milliseconds: 1);
      var duration7 = Duration(
          hours: hour,
          minutes: 49,
          seconds: 59,
          milliseconds: 59,
          microseconds: 5);
      var duration8 = Duration(
          hours: hour,
          minutes: 49,
          seconds: 59,
          milliseconds: 59,
          microseconds: 59);
      expect(duration.inHours, hour);
      expect(duration2.inHours, hour);
      expect(duration3.inHours, hour);
      expect(duration4.inHours, hour);
      expect(duration5.inHours, hour);
      expect(duration6.inHours, hour);
      expect(duration7.inHours, hour);
      expect(duration8.inHours, hour);
    });
  });

  group('minute', () {
    test('expected exact minute', () {
      var duration = Duration(hours: 1, minutes: 30);
      var duration2 = Duration(hours: 2, minutes: 49);
      var duration3 = Duration(hours: 23, minutes: 59, seconds: 20);
      var duration4 = Duration(hours: 10, minutes: 0, seconds: 50);
      var duration5 =
          Duration(hours: 12, minutes: 20, seconds: 59, milliseconds: 45);
      var duration6 =
          Duration(hours: 15, minutes: 54, seconds: 59, milliseconds: 1);
      var duration7 = Duration(
        minutes: 1,
        seconds: 50,
        milliseconds: 59,
        microseconds: 5,
      );
      var duration8 = Duration(
        hours: 6,
        minutes: 30,
        seconds: 30,
        milliseconds: 59,
        microseconds: 59,
      );
      expect(duration.minutes, 30);
      expect(duration2.minutes, 49);
      expect(duration3.minutes, 59);
      expect(duration4.minutes, 0);
      expect(duration5.minutes, 20);
      expect(duration6.minutes, 54);
      expect(duration7.minutes, 1);
      expect(duration8.minutes, 30);
    });
  });

  group('second', () {
    test('expected exact second', () {
      var duration = Duration(hours: 1, minutes: 30);
      var duration2 = Duration(hours: 2, seconds: 49);
      var duration3 = Duration(hours: 23, minutes: 59, seconds: 20);
      var duration4 = Duration(hours: 10, minutes: 0, seconds: 50);
      var duration5 =
          Duration(hours: 12, minutes: 20, seconds: 59, milliseconds: 45);
      var duration6 =
          Duration(hours: 15, minutes: 54, seconds: 59, milliseconds: 1);
      var duration7 = Duration(
        minutes: 1,
        seconds: 1,
        milliseconds: 59,
        microseconds: 5,
      );
      var duration8 = Duration(
        hours: 6,
        minutes: 30,
        milliseconds: 59,
        microseconds: 59,
      );
      expect(duration.seconds, 0);
      expect(duration2.seconds, 49);
      expect(duration3.seconds, 20);
      expect(duration4.seconds, 50);
      expect(duration5.seconds, 59);
      expect(duration6.seconds, 59);
      expect(duration7.seconds, 1);
      expect(duration8.seconds, 0);
    });
  });

  group('millisecond', () {
    test('expected exact millisecond', () {
      var duration = Duration(hours: 1, minutes: 30);
      var duration2 =
          Duration(hours: 2, minutes: 30, seconds: 49, milliseconds: 49);
      var duration3 = Duration(hours: 23, seconds: 59, milliseconds: 20);
      var duration4 = Duration(hours: 10, minutes: 0, milliseconds: 50);
      var duration5 =
          Duration(hours: 12, minutes: 20, seconds: 59, milliseconds: 999);
      var duration6 =
          Duration(hours: 15, minutes: 54, seconds: 59, milliseconds: 1);
      var duration7 = Duration(
        hours: 20,
        minutes: 1,
        seconds: 1,
        microseconds: 500,
      );
      var duration8 = Duration(
        hours: 6,
        minutes: 30,
        milliseconds: 500,
        microseconds: 999,
      );
      expect(duration.milliseconds, 0);
      expect(duration2.milliseconds, 49);
      expect(duration3.milliseconds, 20);
      expect(duration4.milliseconds, 50);
      expect(duration5.milliseconds, 999);
      expect(duration6.milliseconds, 1);
      expect(duration7.milliseconds, 0);
      expect(duration8.milliseconds, 500);
    });
  });
}
