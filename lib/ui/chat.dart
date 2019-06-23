import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  String _fromUid, _toUid;
  String _messageId;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final fromUid = prefs.get('uid');
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final toUid = args['toUserId'];

    // construct thread id
    final CollectionReference messagesRef =
        Firestore.instance.collection('messages');
    String messageId = "$fromUid-$toUid";
    DocumentSnapshot messageSnapshot =
        await messagesRef.document(messageId).get();
    if (messageSnapshot == null || !messageSnapshot.exists) {
      messageId = "$toUid-$fromUid";
      messageSnapshot = await messagesRef.document(messageId).get();
      if (messageSnapshot == null && !messageSnapshot.exists) {
        await messagesRef.document(messageId).setData({
          'items': [],
        });
      }
    }
    setState(() {
      _messageId = messageId;
    });

    setState(() {
      _fromUid = fromUid;
      _toUid = toUid;
    });
  }

  void _handleSendMessage(text) {
    _textController.clear();
    final message = ChatMessageWidget(
      text: text,
      isOutgoingMessage: true,
    );

    Firestore.instance
        .collection('messages')
        .document(_messageId)
        .collection('items')
        .document()
        .setData({
      'sent_from_id': _fromUid,
      'content': text,
      'sent_date': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageList = _messageId != null
        ? StreamBuilder(
            stream: Firestore.instance
                .collection('messages')
                .document(_messageId)
                .collection('items')
                .orderBy('sent_date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final documents = snapshot.data.documents;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: documents.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return ChatMessageWidget(
                      text: documents[index]['content'],
                      isOutgoingMessage:
                          documents[index]['sent_from_id'] == _fromUid,
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          )
        : Container();

    final composeText = IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {},
                onSubmitted: _handleSendMessage,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _handleSendMessage(_textController.text);
                },
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: messageList,
              ),
              Divider(),
              composeText,
            ],
          ),
        ));
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final bool isOutgoingMessage;

  ChatMessageWidget({this.text, this.isOutgoingMessage});

  @override
  Widget build(BuildContext context) {
    var inComingMessage = Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            radius: 16.0,
            child: Text(text[0]),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(100),
          ),
        )
      ],
    );

    var outGoingMessage = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: isOutgoingMessage ? outGoingMessage : inComingMessage,
    );
  }
}
