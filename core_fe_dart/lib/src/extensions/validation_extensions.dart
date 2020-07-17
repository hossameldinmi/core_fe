extension ObjectExtension on Object {
  /// Returns true if object is:
  /// - null
  /// - empty
  /// - whitespace string.
  bool isNullEmptyOrWhitespace() {
    var value=this;
    if (value is String) {
      return value.isNullEmptyOrWhitespace();
    } else if (value is Iterable) {
      return value.isEmpty;
    } else {
      return value == null;
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
