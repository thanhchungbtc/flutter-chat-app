import 'package:chat_app_flutter/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final Firestore _firestore;

  MessageRepository({
    Firestore firestore,
  }) : _firestore = firestore ?? Firestore.instance;

  Future<String> getOrCreateThreadId({String fromUid, String toUid}) async {
    String threadId = "$fromUid-$toUid";

    var snapshot =
        await _firestore.collection('messages').document(threadId).get();
    if (snapshot == null || !snapshot.exists) {
      threadId = "$toUid-$fromUid";
      snapshot =  await _firestore.collection('messages').document(threadId).get();
      if (snapshot == null && !snapshot.exists) {
        await _firestore.collection('messages').document(threadId).setData({
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
        .orderBy('sent_timestamp', descending: true)
        .snapshots();
  }

  void sendMessage(String threadId, Message message) async {
    return await _firestore
        .collection('messages')
        .document(threadId)
        .collection('items')
        .document()
        .setData(message.toMap());
  }
}
