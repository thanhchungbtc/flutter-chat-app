import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

abstract class ChatState extends Equatable {
  ChatState([List props = const []]) : super(props);
}

class FetchOnlineUserStart extends ChatState {
  @override
  String toString() {
    return 'FetchOnlineUserStart';
  }
}

class MessagesLoaded extends ChatState {
  final Stream<QuerySnapshot> snapshots;
  final String threadId;

  MessagesLoaded({@required this.snapshots, this.threadId})
      : super([snapshots, threadId]);

  @override
  String toString() {
    return 'MessagesLoaded';
  }
}
