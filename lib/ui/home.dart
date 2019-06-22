import 'package:chat_app_flutter/services/api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  void handleSignOut(BuildContext context) async {
    await Auth.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => handleSignOut(context),
          )
        ],
      ),
      body: Container(),
    );
  }
}
