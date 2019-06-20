import 'package:chat_app_flutter/ui/home.dart';
import 'package:chat_app_flutter/ui/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String _email, _password, _errorMessage;
  bool _isLoading = false;

  void register() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

  void login(BuildContext context) async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        setState(() {
          _isLoading = true;
        });
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        setState(() {
          _isLoading = false;
        });
        print("Signed in: ${user.uid}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } catch (e) {
        print("Error ${e}");
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginForm = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => value.isEmpty ? "Email can't be empty" : null,
            onSaved: (value) => _email = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) =>
                value.isEmpty ? "Password can't be empty" : null,
            onSaved: (value) => _password = value,
          ),
          RaisedButton(
            child: Text(
              'Login',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () => login(context),
          ),
          FlatButton(
            onPressed: register,
            child: Text('Not have account yet? Register new one.'),
          ),
          Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loginForm,
      ),
    );
  }
}
