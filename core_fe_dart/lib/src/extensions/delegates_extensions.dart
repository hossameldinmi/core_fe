extension DelegateExtension<T> on T Function() {
  Future<T> Function() toAsyncDelegate() => () => Future.value(this());
}
