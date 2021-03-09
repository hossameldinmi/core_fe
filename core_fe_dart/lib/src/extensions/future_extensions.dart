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
