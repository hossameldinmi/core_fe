import 'package:core_fe_dart/models.dart';
import 'package:core_fe_dart/src/models/time_slot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('hasTime', () {
    test('expected true if time is within the slot ', () {
      var slot = TimeSlot(TimeInDay.midNight, TimeInDay.endOfDay);

      expect(slot.hasTime(TimeInDay.noon), true);
    });
  });

  group('generateByRange', () {
    test('expected morning slots', () {
      var list = TimeSlot.generateByRange(
          TimeInDay.midNight, TimeInDay.noon, Duration(hours: 1));
      expect(list, [
        TimeSlot(TimeInDay.midNight, TimeInDay(hour: 1)),
        TimeSlot(TimeInDay(hour: 1), TimeInDay(hour: 2)),
        TimeSlot(TimeInDay(hour: 2), TimeInDay(hour: 3)),
        TimeSlot(TimeInDay(hour: 3), TimeInDay(hour: 4)),
        TimeSlot(TimeInDay(hour: 4), TimeInDay(hour: 5)),
        TimeSlot(TimeInDay(hour: 5), TimeInDay(hour: 6)),
        TimeSlot(TimeInDay(hour: 6), TimeInDay(hour: 7)),
        TimeSlot(TimeInDay(hour: 7), TimeInDay(hour: 8)),
        TimeSlot(TimeInDay(hour: 8), TimeInDay(hour: 9)),
        TimeSlot(TimeInDay(hour: 9), TimeInDay(hour: 10)),
        TimeSlot(TimeInDay(hour: 10), TimeInDay(hour: 11)),
        TimeSlot(TimeInDay(hour: 11), TimeInDay.noon),
      ]);
    });

    test('expected night slots ', () {
      var list = TimeSlot.generateByRange(
          TimeInDay.noon, TimeInDay.endOfDay, Duration(hours: 1));
      expect(list, [
        TimeSlot(TimeInDay.noon, TimeInDay(hour: 13)),
        TimeSlot(TimeInDay(hour: 13), TimeInDay(hour: 14)),
        TimeSlot(TimeInDay(hour: 14), TimeInDay(hour: 15)),
        TimeSlot(TimeInDay(hour: 15), TimeInDay(hour: 16)),
        TimeSlot(TimeInDay(hour: 16), TimeInDay(hour: 17)),
        TimeSlot(TimeInDay(hour: 17), TimeInDay(hour: 18)),
        TimeSlot(TimeInDay(hour: 18), TimeInDay(hour: 19)),
        TimeSlot(TimeInDay(hour: 19), TimeInDay(hour: 20)),
        TimeSlot(TimeInDay(hour: 20), TimeInDay(hour: 21)),
        TimeSlot(TimeInDay(hour: 21), TimeInDay(hour: 22)),
        TimeSlot(TimeInDay(hour: 22), TimeInDay(hour: 23)),
        TimeSlot(TimeInDay(hour: 23), TimeInDay.endOfDay),
      ]);
    });

    test('expected list if time is within the slot ', () {
      var list = TimeSlot.generateByRange(
        TimeInDay.noon,
        TimeInDay.endOfDay,
        Duration(hours: 2),
        span: Duration(hours: 1),
      );
      expect(list, [
        TimeSlot(TimeInDay.noon, TimeInDay(hour: 14)),
        TimeSlot(TimeInDay(hour: 14), TimeInDay(hour: 15)), //span
        TimeSlot(TimeInDay(hour: 15), TimeInDay(hour: 17)),
        TimeSlot(TimeInDay(hour: 17), TimeInDay(hour: 18)), //span
        TimeSlot(TimeInDay(hour: 18), TimeInDay(hour: 20)),
        TimeSlot(TimeInDay(hour: 20), TimeInDay(hour: 21)), //span
        TimeSlot(TimeInDay(hour: 21), TimeInDay(hour: 23)),
      ]);
    });
  });
}
