import 'package:chat_app_flutter/bloc/auth_bloc.dart';
import 'package:chat_app_flutter/bloc/chat_bloc.dart';
import 'package:chat_app_flutter/ui/widget/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String uid;

  @override
  void initState() {
    super.initState();
    final authBloc = BlocProvider.of<AuthBloc>(context);
    if (authBloc.currentState.isAuthenticated()) {
      uid = authBloc.currentState.uid;
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatEvent, ChatState>(
        bloc: BlocProvider.of<ChatBloc>(context),
        builder: (context, state) {
          if (state.isLoading) {
            return Scaffold(
              appBar: AppBar(title: Text('Chat')),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text('Chat')),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ChatMessageListWidget(),
                  ),
                  Divider(),
                  ComposeMessageWidget(
                    uid: uid,
                    threadId: state.threadId,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ChatMessageListWidget extends StatelessWidget {
  final String uid;

  ChatMessageListWidget({this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatEvent, ChatState>(
      bloc: BlocProvider.of<ChatBloc>(context),
      builder: (context, state) {
        if (state.isLoading) {
          return Container();
        }
        return StreamBuilder<QuerySnapshot>(
          stream: state.messageStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final documents = snapshot.data.documents;
            print("LENGTH ${documents.length}");
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: documents.length,
              reverse: true,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return ChatMessageWidget(
                  text: doc['content'],
                  isOutgoingMessage: doc['sent_from_id'] == uid,
                );
              },
            );
          },
        );
      },
    );
  }
}

class ComposeMessageWidget extends StatefulWidget {
  final String uid, threadId;

  const ComposeMessageWidget(
      {Key key, @required this.uid, @required this.threadId})
      : super(key: key);

  @override
  _ComposeMessageWidgetState createState() => _ComposeMessageWidgetState();
}

class _ComposeMessageWidgetState extends State<ComposeMessageWidget> {
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String content) {
    if (content.isEmpty) {
      return;
    }
    _textController.clear();
    BlocProvider.of<ChatBloc>(context).dispatch(ChatEventSendMessage(
      threadId: widget.threadId,
      content: content,
      fromUid: widget.uid,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
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
                onPressed: () => _handleSendMessage(_textController.text),
              ),
            )
          ],
        ),
      ),
    );
  }
}
