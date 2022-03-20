import 'package:core_fe_dart/src/models/domain_event.dart';

class PostUpdatedEventArg extends DomainEventArg<String?> {
  final String postId;
  final String commentId;

  PostUpdatedEventArg(this.postId, this.commentId, [String? sender]) : super(sender);
}

class PostUpdatedFullEventArg extends PostUpdatedEventArg {
  final String userId;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  PostUpdatedFullEventArg(this.userId, this.dateCreated, this.dateUpdated, String postId, String commentId,
      [String? sender])
      : super(postId, commentId, sender);
}

class PostCreatedEventArg extends DomainEventArg<String?> {
  final String postId;

  PostCreatedEventArg(this.postId, String? sender) : super(sender);
}

class DomainEvents {
  static final postCreated = DomainEvent<PostCreatedEventArg>();
  static final postUpdated = DomainEvent<PostUpdatedEventArg>();
}

void main() {
  DomainEvents.postCreated.addEvent(PostCreatedEventArg('id1', 'idc1'));
  DomainEvents.postUpdated.addEvent(PostUpdatedFullEventArg('uid1', DateTime.now(), DateTime.now(), 'pid2', 'cid2'));
}
