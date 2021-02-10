import 'package:equatable/equatable.dart';
import 'package:core_fe_dart/extensions.dart';

class TimeInDay extends Equatable implements Comparable<TimeInDay> {
  final int _value;
  static const int _maxValue = Duration.microsecondsPerDay;
  static final midNight = TimeInDay();
  static final noon = TimeInDay(hour: 12);
  static final endOfDay = TimeInDay(hour: 24);

  TimeInDay._microseconds(int value)
      : assert(_isValidValue(value)),
        _value = value;

  TimeInDay.fromDateTime(DateTime dateTime)
      : this._microseconds(_getMicroseconds(dateTime.hour, dateTime.minute,
            dateTime.second, dateTime.millisecond, dateTime.microsecond));

  TimeInDay.now() : this.fromDateTime(DateTime.now());
  TimeInDay({
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) : this._microseconds(_getMicroseconds(
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        ));
  TimeInDay.dayPeriod({
    int periodHour = 12,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    DayPeriod period = DayPeriod.am,
  })  : assert(periodHour > 0 && periodHour <= 12),
        assert(period != null),
        _value = _getMicroseconds(
          _getHour(periodHour, period),
          minute,
          second,
          millisecond,
          microsecond,
        );

  static int _getHour(int hourOfPeriod, DayPeriod period) {
    if (period == DayPeriod.pm) {
      if (hourOfPeriod == 12) {
        return hourOfPeriod;
      } else {
        return hourOfPeriod + 12;
      }
    } else {
      if (hourOfPeriod == 12 || hourOfPeriod == 0) {
        return 0;
      } else {
        return hourOfPeriod;
      }
    }
  }

  int get hour => _value == Duration.microsecondsPerDay
      ? 24
      : Duration(microseconds: _value).hours;
  int get minute => Duration(microseconds: _value).minutes;
  int get second => Duration(microseconds: _value).seconds;
  int get millisecond => Duration(microseconds: _value).milliseconds;
  int get microsecond => Duration(microseconds: _value).microseconds;
  // int get hourOfPeriod => hour - periodOffset;

  /// The hour at which the current period starts.
  // int get periodOffset => period == DayPeriod.am ? 0 : 12;
  DayPeriod get period => hour < 12 || hour == 24 ? DayPeriod.am : DayPeriod.pm;
  int get hourOfPeriod =>
      hour -
      (hour > 12
          ? 12
          : hour == 0
              ? -12
              : 0);

  static List<TimeInDay> generateByDurations(
      TimeInDay seed, int length, Duration duration,
      {TimeAddOption mode = TimeAddOption.exception,
      bool trimIfException = true}) {
    var list = [seed];
    try {
      for (var i = 1; i < length; i++) {
        list.add(list[i - 1].add(duration, mode));
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
    var newValue = _value + duration.inMicroseconds;
    if (_isValidValue(newValue)) {
      return TimeInDay._microseconds(newValue);
    } else {
      switch (mode) {
        case TimeAddOption.startFromZero:
          return TimeInDay._microseconds(duration.inMicroseconds);
        case TimeAddOption.overflow:
          return TimeInDay._microseconds(
              newValue - Duration.microsecondsPerDay);
        case TimeAddOption.exception:
        default:
          throw ArgumentError.value(duration, 'duration',
              'added duration should not allow time to exceed ${endOfDay.toString()}');
      }
    }
  }

  bool isAfter(TimeInDay other, {bool orSameMoment = true}) =>
      orSameMoment ? _value >= other._value : _value > other._value;

  bool isBefore(TimeInDay other, {bool orSameMoment = true}) =>
      orSameMoment ? _value <= other._value : _value < other._value;

  bool isBetween(TimeInDay time1, TimeInDay time2,
      {bool includeSameMoment = true}) {
    return isAfter(time1, orSameMoment: includeSameMoment) &&
        isBefore(time2, orSameMoment: includeSameMoment);
  }

  @override
  int compareTo(TimeInDay other) => _value.compareTo(other._value);

  @override
  List<Object> get props => [_value];

  @override
  String toString() =>
      'h:$hour m:$minute s:$second ms:$millisecond μs:$microsecond';

  static int _getMicroseconds(
      int hours, int minutes, int seconds, int milliseconds, int microseconds) {
    assert(hours <= 24);
    assert(minutes < 60);
    assert(seconds < 60);
    assert(milliseconds < 1000);
    assert(microseconds < 1000);
    var value = Duration.microsecondsPerHour * hours +
        Duration.microsecondsPerMinute * minutes +
        Duration.microsecondsPerSecond * seconds +
        Duration.microsecondsPerMillisecond * milliseconds +
        microseconds;
    assert(_isValidValue(value));
    return value;
  }

  static bool _isValidValue(int microseconds) => microseconds <= _maxValue;
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
