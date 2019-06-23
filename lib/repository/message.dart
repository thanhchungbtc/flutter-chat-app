import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final _firestore = Firestore.instance;

  Stream<QuerySnapshot> messageStream({String threadId}) {
    return _firestore
        .collection('messages')
        .document(threadId)
        .collection('items')
        .orderBy('sent_date', descending: true)
        .snapshots();
  }

  Future<String> retrieveThreadId(String fromUid, toUid) async {
    // construct thread id
    final CollectionReference messagesRef = _firestore.collection('messages');
    String threadId = "$fromUid-$toUid";
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

  Future<void> sendMessage({
    String threadId,
    String sendFromUid,
    String content,
  }) async {
    await _firestore
        .collection('messages')
        .document(threadId)
        .collection('items')
        .document()
        .setData({
      'sent_from_id': sendFromUid,
      'content': content,
      'sent_date': Timestamp.now(),
    });
  }
}
