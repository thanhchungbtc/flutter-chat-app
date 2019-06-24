import 'package:chat_app_flutter/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final Firestore _firestore;

  MessageRepository({
    Firestore firestore,
  }) : _firestore = firestore ?? Firestore.instance;

  Future<String> getOrCreateThreadId({String fromUid, String toUid}) async {
    String threadId = "$fromUid-$toUid";

    final CollectionReference messagesRef =
    Firestore.instance.collection('messages');
    DocumentSnapshot messageSnapshot =
        await messagesRef.document(threadId).get();
    if (messageSnapshot == null || !messageSnapshot.exists) {
      threadId = "$toUid-$fromUid";
      messageSnapshot = await messagesRef.document(threadId).get();
      if (messageSnapshot == null && !messageSnapshot.exists) {
        await messagesRef.document(threadId).setData({
          'items': [],
        });
      }
    }

    return threadId;
  }

  Stream<QuerySnapshot> getMessageStream(String threadId) {
    return _firestore
        .collection('messages')
        .document(threadId)
        .collection('items')
        .orderBy('sent_date', descending: true)
        .snapshots();
  }

  void sendMessage(String threadId, Message message) {
    _firestore
        .collection('messages')
        .document(threadId)
        .collection('items')
        .document()
        .setData(message.toMap());
  }
}
