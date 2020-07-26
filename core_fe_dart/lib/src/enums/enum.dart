import 'package:equatable/equatable.dart';

abstract class Enum<TKey, TValue> extends Equatable {
  final TKey key;
  const Enum(this.key);

  @override
  List<Object> get props => [key];
}
