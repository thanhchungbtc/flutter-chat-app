import 'package:chat_app_flutter/bloc/auth_bloc.dart';
import 'package:chat_app_flutter/ui/widget/loading_indication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final String errorMsg;

  const LoginForm({Key key, this.errorMsg}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
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
      controller: _emailController,
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
        controller: _passwordController,
      ),
    );

    onLoginButtonPresed() {
      if (_formKey.currentState.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());
        bloc.dispatch(AuthEventSignIn(
          email: _emailController.text,
          password: _passwordController.text,
        ));
      }
    }

    onRegisterButtonPressed() {
      Navigator.of(context).pushNamed('/register');
    }

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
        onPressed: onLoginButtonPresed,
      ),
    );

    var registerButton = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FlatButton(
        onPressed: onRegisterButtonPressed,
        child: Text('Not have account yet? Register new one.'),
      ),
    );

    var errorMessageField = widget.errorMsg.isNotEmpty
        ? Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              widget.errorMsg,
              style: TextStyle(color: Colors.red),
            ),
          )
        : Container();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              logo,
              emailField,
              passwordField,
              loginButton,
              registerButton,
              errorMessageField,
            ],
          ),
        ),
      ),
    );
  }
}
