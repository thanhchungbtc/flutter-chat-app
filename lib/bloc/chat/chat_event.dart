import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const []]) : super(props);
}

class SelectPerson extends ChatEvent {
  final String fromUid;
  final String toUid;

  SelectPerson({@required this.fromUid, @required this.toUid})
      : super([fromUid, toUid]);

  @override
  String toString() {
    return 'SelectPerson';
  }
}

class FetchMessageStart extends ChatEvent {
  final String threadId;

  FetchMessageStart({@required this.threadId}) : super([threadId]);

  @override
  String toString() {
    return 'FetchMessageStart';
  }
}

class FetchMessageSuccess extends ChatEvent {
  final Stream<QuerySnapshot> snapshots;
  final String threadId;

  FetchMessageSuccess({@required this.snapshots, @required this.threadId})
      : super([snapshots, threadId]);

  @override
  String toString() {
    return 'FetchMessageSuccess';
  }
}

class SendMessageStart extends ChatEvent {
  final String threadId;
  final String fromUid;
  final String content;

  SendMessageStart(
      {@required this.threadId, @required this.fromUid, @required this.content})
      : super([threadId, fromUid, content]);
}

class SendMessageSuccess extends ChatEvent {}
