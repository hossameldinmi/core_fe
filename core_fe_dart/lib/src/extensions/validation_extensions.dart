extension OjbectIterableExtension on Iterable<Object?> {
  /// Returns true if any object in the Iterable is:
  /// - null
  /// - empty
  /// - whitespace string.
  bool anyIsNullEmptyOrWhitespace() =>
      any((element) => element.isNullEmptyOrWhitespace());

  /// Returns true if any object in the Iterable is NOT:
  /// - null
  /// - empty
  /// - whitespace string.
  bool anyIsNotNullEmptyOrWhitespace() =>
      any((element) => !element.isNullEmptyOrWhitespace());

  /// Returns true if all object in the Iterable is ```NOT```:
  /// - null
  /// - empty
  /// - whitespace string.
  bool allIsNotNullEmptyOrWhitespace() => !anyIsNullEmptyOrWhitespace();
}

extension ObjectExtension on Object? {
  /// Returns true if object is:
  /// - null
  /// - empty
  /// - whitespace string.
  bool isNullEmptyOrWhitespace() {
    var value = this;
    if (value is String) {
      return value.isEmpty || value.trim().isEmpty;
    } else if (value is Iterable) {
      return value.isEmpty;
    } else if (value is Map) {
      return value.isEmpty;
    } else {
      return value == null;
    }
  }
}
