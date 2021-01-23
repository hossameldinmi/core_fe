import 'package:meta/meta.dart';

class Lockup<T> {
  final String id;
  final T value;
  const Lockup({@required this.id, @required this.value});
}
