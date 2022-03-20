void validate(bool condition, {Object? message}) {
  if (!condition) {
    throw AssertionError(message);
  }
}
