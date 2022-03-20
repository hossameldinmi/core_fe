import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class DomainEvent<TArg extends DomainEventArg> extends Equatable {
  final String? id;

  DomainEvent([this.id]);

  final _subject = BehaviorSubject<TArg>();
  ValueStream<TArg> get onEvent => _subject.stream;

  void addEvent(TArg event) => _subject.add(event);

  @override
  List<Object?> get props => [id];
}

abstract class DomainEventArg<TSender> {
  final TSender sender;

  DomainEventArg(this.sender);
}
