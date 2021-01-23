import 'package:core_fe_dart/src/models/time_in_day.dart';
import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final TimeInDay start;
  final TimeInDay end;
  TimeSlot(this.start, this.end);
  TimeSlot.fromDateTimes(DateTime dateTime1, DateTime dateTime2)
      : start = TimeInDay.fromDateTime(dateTime1),
        end = TimeInDay.fromDateTime(dateTime2);
  static List<TimeSlot> generateByDurations(
      TimeInDay seed, int length, Duration duration,
      {Duration span = Duration.zero, bool trimIfException = true}) {
    var list = [TimeSlot(seed, seed.add(duration))];
    try {
      for (var i = 1; i < length; i++) {
        if (span != Duration.zero && i == length - 1) {
          list.add(TimeSlot(list[i - 1].end.add(span),
              list[i - 1].end.add(span).add(duration)));
        }
        list.add(TimeSlot(list[i - 1].end, list[i - 1].end.add(duration)));
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

  bool hasTime(TimeInDay time, {bool includeSameMoment = true}) {
    return time.isBetween(start, end, includeSameMoment: includeSameMoment);
  }

  static List<TimeSlot> generateByRange(
      TimeInDay seed, TimeInDay end, Duration duration,
      {Duration span = Duration.zero,
      TimeAddOption option = TimeAddOption.exception}) {
    var list = [TimeSlot(seed, seed.add(duration))];
    try {
      while (getNewTime(list, span, duration).isBefore(end)) {
        if (span != Duration.zero) {
          list.add(list.last.addToEnd(span));
        }
        list.add(list.last.addToEnd(duration));
      }
    } finally {
      return list;
    }
  }

  static TimeInDay getNewTime(
      List<TimeSlot> list, Duration span, Duration duration) {
    return list.last.addToEnd(span).addToEnd(duration).end;
  }

  TimeSlot shift(Duration duration,
          [TimeAddOption option = TimeAddOption.exception]) =>
      TimeSlot(start.add(duration, option), end.add(duration, option));

  TimeSlot addToEnd(Duration duration,
          [TimeAddOption option = TimeAddOption.exception]) =>
      TimeSlot(end, end.add(duration, option));
  @override
  List<Object> get props => [start, end];
}
