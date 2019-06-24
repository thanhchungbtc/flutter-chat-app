import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sentFromId;
  String content;
  Timestamp sentTimestamp;
  bool isOutgoingMessage;

  Message({this.sentFromId, this.content, this.isOutgoingMessage, this.sentTimestamp});

  Map<String, dynamic> toMap() {
    return {
      'sent_from_id': sentFromId,
      'content': content,
      'sent_timestamp': sentTimestamp,
    };
  }
}

class User {
  String uid, displayName, email;
  User({this.uid, this.displayName, this.email});
}
