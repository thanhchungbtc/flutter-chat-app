import 'package:chat_app_flutter/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final Firestore _firestore;

  MessageRepository({
    Firestore firestore,
  }) : _firestore = firestore ?? Firestore.instance;

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
