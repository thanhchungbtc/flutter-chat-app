import 'package:chat_app_flutter/model.dart';
import 'package:chat_app_flutter/redux/action.dart';
import 'package:chat_app_flutter/redux/reducer/root_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class _ViewModel {
  Stream<QuerySnapshot> messageStream;
  String threadId;
  String uid;
  Function(String) onSubmitMessage;

  _ViewModel(
      {this.messageStream, this.threadId, this.uid, this.onSubmitMessage});
}

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
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
          messageStream: store.state.chat.messageStream,
          threadId: store.state.chat.threadId,
          uid: store.state.login.user.uid,
          onSubmitMessage: (text) {
            _textController.clear();
            store.dispatch(SendMessageRequestAction(
                threadId: store.state.chat.threadId,
                message: Message(
                  sentFromId: store.state.login.user.uid,
                  content: text,
                  sentTimestamp: Timestamp.now(),
                )));
          }),
      builder: (context, vm) {
        print(vm.threadId);
        final messageList = StreamBuilder(
          stream: vm.messageStream,
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
                        documents[index]['sent_from_id'] == vm.uid,
                  );
                },
              );
            } else {
              return Container();
            }
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
                    onSubmitted: vm.onSubmitMessage,
                    decoration:
                        InputDecoration.collapsed(hintText: 'Send a message'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      print("PRESS");
                      vm.onSubmitMessage(_textController.text);
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
      },
    );
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
            color: Colors.blue,
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
