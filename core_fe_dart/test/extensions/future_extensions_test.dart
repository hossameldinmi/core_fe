@Skip('currently failing')
import 'package:core_fe_dart/src/models/async_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/src/extensions/future_extensions.dart';
import 'package:matcher/matcher.dart';

import '../mocks/models.dart';

Future<Element> data(Element result, [int milliseconds = 0]) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
  return Future.value(result);
}

Future<Element> error(Element result, [int milliseconds = 0]) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
  return Future<Element>.error(result);
}

void main() {
  group('FutureIterable Extensions', () {
    group('wait', () {
      AsyncSnapshot<Element> d(Comparable data, int index) =>
          AsyncSnapshot(o(data), index);
      AsyncSnapshot<Element> e(Comparable error, int index) =>
          AsyncSnapshot.error(o(error), index);
      AsyncSnapshotGroup<Element> g(Iterable<AsyncSnapshot<Element>> l) =>
          AsyncSnapshotGroup(l);

      group('ordered', () {
        test('expected all futures complets successfuly', () async {
          var result =
              await [data(o(0)), data(o(1)), data(o(2)), data(o(3))].wait();
          expect(result, g([d(0, 0), d(1, 1), d(2, 2), d(3, 3)]));
        });
        test('expected last futures completed with errors', () async {
          var result =
              await [data(o(0)), data(o(1)), error(o(2)), error(o(3))].wait();
          expect(result, g([d(0, 0), d(1, 1), e(2, 2), e(3, 3)]));
        });

        test('expected first futures completed with errors', () async {
          var result =
              await [error(o(2)), error(o(3)), data(o(0)), data(o(1))].wait();
          expect(result, g([e(2, 0), e(3, 1), d(0, 2), d(1, 3)]));
        });

        test('expected all futures completed with errors', () async {
          var result =
              await [error(o(2)), error(o(3)), error(o(2)), error(o(3))].wait();

          expect(result, g([e(2, 0), e(3, 1), e(2, 2), e(3, 3)]));
        });

        test('expected error when any future returns error', () {
          expect(
            () async => await [data(o(0)), data(o(1)), error(o(2)), error(o(3))]
                .wait(false),
            throwsA(TypeMatcher<Element>().having((e) => e, 'o(2)', o(2))),
          );
        });
      });

      group('not ordered', () {
        test('expected all futures complets successfuly', () async {
          var result = await [
            data(o(0), 900), //3
            data(o(1), 23), //1
            data(o(2), 9), //0
            data(o(3), 200) //2
          ].wait();
          expect(result, g([d(0, 3), d(1, 1), d(2, 0), d(3, 2)]));
        });
        test('expected last futures completed with errors', () async {
          var result = await [
            data(o(0), 300), //2
            data(o(1), 100), //0
            error(o(2), 200), //1
            error(o(3), 800) //3
          ].wait();
          expect(result, g([d(0, 2), d(1, 0), e(2, 1), e(3, 3)]));
        });
      });
    });

    group('stream wait', () {
      AsyncSnapshot<Element> e(dynamic error, int index) =>
          AsyncSnapshot.error(error, index);
      AsyncSnapshot<Element> r<T>(Comparable id, int index) =>
          AsyncSnapshot(o(id), index);

      group('ordered', () {
        test('expected all futures complets successfuly', () async {
          var result =
              [data(o(0)), data(o(1)), data(o(2)), data(o(3))].streamWait();
          await expectLater(
              result,
              emitsInOrder([
                r(0, 0),
                r(1, 1),
                r(2, 2),
                r(3, 3),
              ]));
        });
        test('expected last futures completed with errors', () async {
          var result =
              [data(o(0)), data(o(1)), error(o(2)), error(o(3))].streamWait();
          await expectLater(
              result,
              emitsInOrder([
                r(0, 0),
                r(1, 1),
                e(o(2), 2),
                e(o(3), 3),
              ]));
        });

        test('expected first futures completed with errors', () async {
          var result =
              [error(o(2)), error(o(3)), data(o(0)), data(o(1))].streamWait();
          await expectLater(
              result,
              emitsInOrder([
                e(o(2), 0),
                e(o(3), 1),
                r(0, 2),
                r(1, 3),
              ]));
        });

        test('expected all futures completed with errors', () async {
          var result =
              [error(o(2)), error(o(3)), error(o(2)), error(o(3))].streamWait();
          await expectLater(
              result,
              emitsInOrder([
                e(o(2), 0),
                e(o(3), 1),
                e(o(2), 2),
                e(o(3), 3),
              ]));
        });

        test('expected error when any future returns error', () async {
          await expectLater(
              [
                data(o(0)),
                data(o(1), 1),
                error(o(2), 2),
                error(o(3), 3),
              ].streamWait(false),
              emitsInOrder([
                r(0, 0),
                r(1, 1),
                emitsError(
                    TypeMatcher<Element>().having((e) => e, 'o(2)', o(2)))
              ]));
        });
      }, skip: 'fix error on terminal');

      group('not ordered', () {
        test('expected all futures complets successfuly', () async {
          var result = [
            data(o(0), 900), //4
            data(o(1), 23), //2
            data(o(2), 9), //1
            data(o(3), 200) //3
          ].streamWait();
          await expectLater(
              result,
              emitsInOrder([
                r(2, 0),
                r(1, 1),
                r(3, 2),
                r(0, 3),
              ]));
        });
        test('expected last futures completed with errors', () async {
          var result = [
            data(o(0), 300), //3
            data(o(1), 100), //1
            error(o(2), 200), //2
            error(o(3), 800) //4
          ].streamWait();
          await expectLater(
              result,
              emitsInOrder([
                r(1, 0),
                e(o(2), 1),
                r(0, 2),
                e(o(3), 3),
              ]));
        });
      });
    });
  });
}
