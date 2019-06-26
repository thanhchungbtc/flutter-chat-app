import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message {
  String fromUid;
  String content;
  Timestamp sentTimestamp;
  bool isOutgoingMessage;

  Message({
    this.fromUid,
    this.content,
    this.isOutgoingMessage,
    this.sentTimestamp,
  });

  factory Message.create(String fromUid, String content) => Message(
        fromUid: fromUid,
        content: content,
        sentTimestamp: Timestamp.now(),
      );

  Map<String, dynamic> toMap() {
    return {
      'from_uid': fromUid,
      'content': content,
      'sent_timestamp': sentTimestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        fromUid: map['from_uid'],
        content: map['content'],
        sentTimestamp: map['sent_timestamp'],
      );
}

class User {
  String email;
  String uid;
  String displayName;
  String photoUrl;

  User({
    this.email,
    this.uid,
    this.displayName,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) => User(
        uid: map['uid'],
        email: map['email'],
        displayName: map['displayName'],
        photoUrl: map['photoUrl'],
      );

  factory User.fromFirebaseUser(FirebaseUser user) => User(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
      );
}
