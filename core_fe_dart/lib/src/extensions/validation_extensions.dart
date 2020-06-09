extension ObjectExtension on Object {
  /// Returns true if object is:
  /// - null
  /// - empty
  /// - whitespace string.
  bool isNullEmptyOrWhitespace() {
    if (this is String) {
      return (this as String).isNullEmptyOrWhitespace();
    } else if (this is Iterable) {
      return (this as Iterable).isEmpty;
    } else {
      return this == null;
    }
  }
}

extension StringExtension on String {
  /// Returns true if string is:
  /// - null
  /// - empty
  /// - whitespace string.
  bool isNullEmptyOrWhitespace() => this == null || isEmpty || trim().isEmpty;
}
