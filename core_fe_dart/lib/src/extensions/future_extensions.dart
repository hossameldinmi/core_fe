extension FutureExtensions<T> on Future<T> {
  Future<T> thenAction(void Function(T) action) {
    return then((v) {
      action(v);
      return v;
    });
  }
}
