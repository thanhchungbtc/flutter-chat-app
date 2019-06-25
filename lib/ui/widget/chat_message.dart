import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final bool isOutgoingMessage;
  final String photoUrl;

  ChatMessageWidget({
    this.text,
    this.isOutgoingMessage,
    this.photoUrl,
  });

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