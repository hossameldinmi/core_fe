import 'dart:async';
import 'package:core_fe_dart/src/models/async_snapshot.dart';

extension FutureExtensions<T> on Future<T> {
  Future<T> thenAction(void Function(T) action) {
    return then((v) {
      action(v);
      return v;
    });
  }

  void toSync(void Function(T) action) async {
    await then((v) {
      action(v);
    });
  }
}

extension BoolFutureExtensions on Future<bool> {
  Future<bool> thenIfTrue(void Function() action) {
    return then((v) {
      action();
      return v;
    });
  }
}

extension FutureIterbleExtension<E> on Iterable<Future<E>> {
  Future<AsyncSnapshotGroup<E>> wait([bool safe = true]) {
    var order = -1;
    return Future.wait<AsyncSnapshot<E>>(map<Future<AsyncSnapshot<E>>>((f) {
      return f.then((v) {
        order++;
        return AsyncSnapshot<E>(v, order);
      }).catchError((error, stackTrace) {
        if (!safe) {
          throw error;
        }
        order++;
        return AsyncSnapshot<E>.error(error, order);
      });
    })).then((value) => AsyncSnapshotGroup(value));
  }

  Stream<AsyncSnapshot<E>> streamWait([bool safe = true]) {
    var order = 0;
    var controller = StreamController<AsyncSnapshot<E>>.broadcast();
    Future.wait<void>(map<Future<void>>((f) {
      return f.then((v) {
        controller.add(AsyncSnapshot<E>(v, order));
        order++;
      }).catchError((error, stackTrace) {
        if (safe) {
          controller.add(AsyncSnapshot.error(error, order));
          order++;
        } else {
          controller.addError(error, stackTrace);
          throw error;
        }
      });
    }).toList())
        .whenComplete(() {
      controller.close();
    });
    return controller.stream;
  }
}
