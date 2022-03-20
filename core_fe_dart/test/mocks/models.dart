/// Wrapper objects for an `id` value.
///
/// Compares the `id` value by equality and for comparison.
/// Allows creating simple objects that are equal without being identical.
class Element implements Comparable<Element> {
  final Comparable id;
  const Element(this.id);
  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) => other is Element && id == other.id;
  @override
  int compareTo(other) => id.compareTo(other.id);

  @override
  String toString() => id.toString();
}

Element o(Comparable id) => Element(id);
