import 'package:chat_app_flutter/bloc/authentication/authentication.dart';
import 'package:chat_app_flutter/bloc/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ChatBloc chatBloc = BlocProvider.of(context);
    final AuthenticationBloc authenticationBloc = BlocProvider.of(context);
    String threadId;
    if (chatBloc.currentState is MessagesLoaded) {
      threadId = (chatBloc.currentState as MessagesLoaded).threadId;
    }

    final fromUid =
        (authenticationBloc.currentState as AuthenticationAuthenticated).uid;

    handleSendMessage(threadId, text) {
      _textController.clear();
      chatBloc.dispatch(SendMessageStart(
          threadId: threadId, fromUid: fromUid, content: text));
    }

    final messageList = BlocBuilder(
      bloc: chatBloc,
      builder: (context, state) {
        if (state is MessagesLoaded) {
          return StreamBuilder(
            stream: state.snapshots,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final documents = snapshot.data.documents;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: documents.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return ChatMessageWidget(
                      text: doc['content'],
                      isOutgoingMessage: doc['sent_from_id'] == fromUid,
//                      photoUrl: doc['photoUrl'],
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          );
        }
        return Container();
      },
    );

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
                onSubmitted: (text) => handleSendMessage(threadId, text),
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  handleSendMessage(threadId, _textController.text);
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
//  final String photoUrl;

  ChatMessageWidget({
    this.text,
    this.isOutgoingMessage,
//    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    var inComingMessage = Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            radius: 16.0,
//            backgroundImage: NetworkImage(photoUrl),
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
