import 'package:meta/meta.dart';

class Lockup {
  final String id;
  final String name;
  const Lockup(this.id, this.name);
}

class LockupModel<T> {
  final String id;
  final T value;
  const LockupModel({@required this.id, @required this.value});
}
