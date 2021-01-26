import 'package:equatable/equatable.dart';
import 'package:core_fe_dart/extensions.dart';

class TimeInDay extends Equatable implements Comparable<TimeInDay> {
  static const _dummyYear = 1900;
  static const _dummyMonth = 1;
  static const _dummyDay = 1;
  static final _dummyDate = DateTime(_dummyYear, _dummyMonth, _dummyDay);
  final DateTime _date;
  static final midNight = TimeInDay();
  static final noon = TimeInDay(hour: 12);
  static final lastTimeInDay = TimeInDay(
      hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
  TimeInDay.fromDateTime(DateTime dateTime)
      : _date = dateTime.resetDate(_dummyDate);
  TimeInDay.now() : this.fromDateTime(DateTime.now());
  TimeInDay({
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  })  : assert(hour < Duration.hoursPerDay),
        assert(minute < Duration.minutesPerHour),
        assert(second < Duration.secondsPerMinute),
        assert(millisecond < Duration.millisecondsPerSecond),
        assert(microsecond < Duration.microsecondsPerMillisecond),
        _date = DateTime(
          _dummyYear,
          _dummyMonth,
          _dummyDay,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );
  TimeInDay.dayPeriod({
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    DayPeriod period = DayPeriod.am,
  })  : assert(hour <= 12),
        assert(minute < Duration.minutesPerHour),
        assert(second < Duration.secondsPerMinute),
        assert(millisecond < Duration.millisecondsPerSecond),
        assert(microsecond < Duration.microsecondsPerMillisecond),
        _date = DateTime(
          _dummyYear,
          _dummyMonth,
          _dummyDay,
          hour + (period == DayPeriod.pm && hour != 12 ? 12 : 0),
          minute,
          second,
          millisecond,
          microsecond,
        );

  int get hour => _date.hour;
  int get minute => _date.minute;
  int get second => _date.second;
  int get millisecond => _date.millisecond;
  int get microsecond => _date.microsecond;

  DayPeriod get period => hour < 12 ? DayPeriod.am : DayPeriod.pm;
  int get perdiodHour => hour - (hour > 12 ? 12 : 0);
  DateTime toDateTime() => _date;
  static List<TimeInDay> generateByDurations(
      TimeInDay seed, int length, Duration duration,
      {bool trimIfException = true}) {
    var list = [seed];
    try {
      for (var i = 1; i < length; i++) {
        list.add(list[i - 1].add(duration));
      }
      return list;
    } catch (e) {
      if (trimIfException) {
        return list;
      } else {
        rethrow;
      }
    }
  }

  TimeInDay add(Duration duration,
      [TimeAddOption mode = TimeAddOption.exception]) {
    var newDate = _date.add(duration);
    if (_date.isSameDate(newDate)) {
      return TimeInDay.fromDateTime(_date.add(duration));
    } else {
      switch (mode) {
        case TimeAddOption.startFromZero:
          return TimeInDay.fromDateTime(_dummyDate.add(duration));
          break;
        case TimeAddOption.overflow:
          return TimeInDay.fromDateTime(_date.add(duration));
          break;
        case TimeAddOption.exception:
        default:
          throw ArgumentError.value(duration, 'duration',
              'added duration should not allow time to exceed ${lastTimeInDay}');
      }
    }
  }

  bool isAfter(TimeInDay other, {bool includeSameMoment = true}) {
    return _date.isAfter(other._date) ||
        (includeSameMoment ? _date.isAtSameMomentAs(other._date) : false);
  }

  bool isBefore(TimeInDay other, {bool includeSameMoment = true}) {
    return _date.isBefore(other._date) ||
        (includeSameMoment ? _date.isAtSameMomentAs(other._date) : false);
  }

  bool isBetween(TimeInDay time1, TimeInDay time2,
      {bool includeSameMoment = true}) {
    return isAfter(time1, includeSameMoment: includeSameMoment) &&
        isBefore(time2, includeSameMoment: includeSameMoment);
  }

  @override
  int compareTo(TimeInDay other) => _date.compareTo(other._date);

  @override
  List<Object> get props => [_date];
}

/// Whether the [TimeInDay] is before or after noon.
enum DayPeriod {
  /// Ante meridiem (before noon).
  am,

  /// Post meridiem (after noon).
  pm,
}
enum TimeAddOption {
  exception,
  overflow,
  startFromZero,
}
