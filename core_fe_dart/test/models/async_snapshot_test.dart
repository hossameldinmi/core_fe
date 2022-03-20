import 'package:core_fe_dart/src/models/async_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import '../mocks/models.dart';

void main() {
  group('async snapshot', () {
    test('data', () {
      var snapshot = AsyncSnapshot(o(0), 0);
      expect(snapshot.data, o(0));
      expect(snapshot.hasData, true);
      expect(snapshot.error, isNull);
      expect(snapshot.hasError, false);
      expect(snapshot.index, 0);
    });
    test('error', () {
      var snapshot = AsyncSnapshot.error(o(0), 0);
      expect(snapshot.data, isNull);
      expect(snapshot.hasData, false);
      expect(snapshot.error, o(0));
      expect(snapshot.hasError, true);
      expect(snapshot.index, 0);
    });
  });

  group('AsyncSnapshotGroup', () {
    AsyncSnapshot<Element> d(Comparable data, int index) =>
        AsyncSnapshot(o(data), index);
    AsyncSnapshot<Element> e(Comparable error, int index) =>
        AsyncSnapshot.error(o(error), index);

    test('ordered and has no errors', () {
      var list = [d(0, 0), d(1, 1), d(2, 2), d(3, 3)];
      var snapshotGroup = AsyncSnapshotGroup(list);
      expect(snapshotGroup.results(), list);
      expect(snapshotGroup.results(orderByComplete: true), list);
      expect(snapshotGroup.hasData, true);
      expect(snapshotGroup.errors, isEmpty);
      expect(snapshotGroup.hasErrors, false);
      expect(snapshotGroup.data(), [o(0), o(1), o(2), o(3)]);
      expect(
        snapshotGroup.data(orderByComplete: true),
        [o(0), o(1), o(2), o(3)],
      );
      expect(snapshotGroup.data(ignoreErrorResults: false),
          [o(0), o(1), o(2), o(3)]);
      expect(
          snapshotGroup.data(ignoreErrorResults: false, orderByComplete: true),
          [o(0), o(1), o(2), o(3)]);
    });
    test('not ordered has errors', () async {
      var list = [
        d(0, 2),
        e(1, 3),
        d(2, 0),
        e(3, 1),
      ];
      var snapshotGroup = AsyncSnapshotGroup(list);
      expect(snapshotGroup.results(), list);
      expect(snapshotGroup.results(orderByComplete: true), [
        d(2, 0),
        e(3, 1),
        d(0, 2),
        e(1, 3),
      ]);
      expect(snapshotGroup.hasData, true);
      expect(snapshotGroup.errors, [o(1), o(3)]);
      expect(snapshotGroup.hasErrors, true);
      expect(snapshotGroup.data(), [o(0), o(2)]);
      expect(
        snapshotGroup.data(orderByComplete: true),
        [o(2), o(0)],
      );
      expect(snapshotGroup.data(ignoreErrorResults: false), [
        o(0),
        null,
        o(2),
        null,
      ]);
      expect(
          snapshotGroup.data(ignoreErrorResults: false, orderByComplete: true),
          [
            o(2),
            null,
            o(0),
            null,
          ]);
    });
  });
}
