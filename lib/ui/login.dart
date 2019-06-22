import 'package:chat_app_flutter/services/api.dart';
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

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    setState(() {
      _isLoading = true;
    });
    final isSignedIn = await Auth.isSignedIn();
    if (isSignedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void register(BuildContext context) async {
    Navigator.of(context).pushNamed('/register');
  }

  void login(BuildContext context) async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        setState(() {
          _errorMessage = null;
          _isLoading = true;
        });
        FirebaseUser user = await Auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacementNamed('/home');

      } catch (e) {
        print("Error ${e}");
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var logo = Padding(
      padding: const EdgeInsets.all(32.0),
      child: FlutterLogo(
        size: 96.0,
      ),
    );

    var emailField = TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
        icon: Icon(Icons.mail, color: Colors.grey),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value.isEmpty ? "Email can't be empty" : null,
      onSaved: (value) => _email = value,
    );

    var passwordField = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        obscureText: true,
        validator: (value) => value.isEmpty ? "Password can't be empty" : null,
        onSaved: (value) => _password = value,
      ),
    );

    var errorMessageField = _errorMessage != null
        ? Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red,
              ),
            ))
        : Container();

    var loginButton = Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: MaterialButton(
        padding: EdgeInsets.all(10.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        color: Theme.of(context).buttonTheme.colorScheme.primary,
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        onPressed: () => login(context),
      ),
    );

    var registerButton = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FlatButton(
        onPressed: () => register(context),
        child: Text('Not have account yet? Register new one.'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  logo,
                  emailField,
                  passwordField,
                  errorMessageField,
                  loginButton,
                  registerButton,
                ],
              ),
            ),
            Positioned(
              child: _isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
