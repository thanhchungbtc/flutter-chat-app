import 'package:chat_app_flutter/services/api.dart';
import 'package:chat_app_flutter/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormFieldState>();

  String _email, _password, _passwordConfirmation, _errorMessage;
  bool _isLoading = false;

  void register(BuildContext context) async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      try {
        setState(() {
          _errorMessage = null;
          _isLoading = true;
        });
        FirebaseUser user = await Auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print("BTC $e");
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var emailField = TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
        icon: Icon(Icons.mail, color: Colors.grey),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern);
        if (value.length == 0) {
          return "Email can't be empty";
        } else if (!regExp.hasMatch(value)) {
          return "Invalid Email";
        } else {
          return null;
        }
      },
      onSaved: (value) => _email = value,
    );

    var logo = Padding(
      padding: const EdgeInsets.all(32.0),
      child: FlutterLogo(
        size: 96.0,
      ),
    );

    var passwordField = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        key: passwordKey,
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

    var passwordConfirmationField = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Password Confirmation',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        obscureText: true,
        validator: (value) {
          return value.isEmpty
              ? "Password confirmation can't be empty"
              : value != passwordKey.currentState.value
                  ? 'Password did not match'
                  : null;
        },
      ),
    );

    var registerButton = Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: MaterialButton(
        padding: EdgeInsets.all(10.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        color: Theme.of(context).buttonTheme.colorScheme.primary,
        child: Text(
          'Create account',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        onPressed: () => register(context),
      ),
    );

    var errorMessageField = _errorMessage != null
        ? Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red,
              ),
            ))
        : Container();

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Center(
              child: _isLoading ? CircularProgressIndicator() : null,
            ),
            Form(
              key: formKey,
              autovalidate: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  logo,
                  emailField,
                  passwordField,
                  passwordConfirmationField,
                  registerButton,
                  errorMessageField,
                ],
              ),
            ),
            Positioned(
              child: _isLoading ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                color: Colors.white.withOpacity(0.8),
              ) : Container(),
            )
          ],
        ),
      ),
    );
  }
}
