import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }

}

class _RegisterScreenState extends State<RegisterScreen> {

  void register() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration:InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                decoration:InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                decoration:InputDecoration(labelText: 'Confirm password'),
                obscureText: true,
              ),
              RaisedButton(
                child: Text('Register',
                style: TextStyle(fontSize: 20),),
                onPressed: register,
              )
            ],
          ),
        )
      ),
    );
  }

}