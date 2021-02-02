import 'package:core_fe_dart/models.dart';

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime resetDate(DateTime other) {
    if (other.isUtc) {
      return DateTime.utc(other.year, other.month, other.day, hour, minute,
          second, millisecond, microsecond);
    } else {
      return DateTime(other.year, other.month, other.day, hour, minute, second,
          millisecond, microsecond);
    }
  }

  DateTime resetTime([TimeInDay timeInDay]) {
    timeInDay ??= TimeInDay.midNight;
    if (isUtc) {
      return DateTime.utc(year, month, day, timeInDay.hour, timeInDay.minute,
          timeInDay.second, timeInDay.millisecond, timeInDay.microsecond);
    } else {
      return DateTime(year, month, day, timeInDay.hour, timeInDay.minute,
          timeInDay.second, timeInDay.millisecond, timeInDay.microsecond);
    }
  }
}
