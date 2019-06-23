import 'package:chat_app_flutter/bloc/authentication/authentication.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    final AuthenticationBloc bloc = BlocProvider.of(context);
    bloc.state.listen((state) {
      if (state is AuthenticationAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  Widget build(BuildContext context) {
    final AuthenticationBloc bloc = BlocProvider.of(context);

    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        _onRegisterButtonPressed() {
          if (_formKey.currentState.validate()) {
            bloc.dispatch(RegisterStart(
              email: _emailController.text,
              password: _passwordConfirmController.text,
            ));
          }
        }

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
          controller: _emailController,
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
            decoration: InputDecoration(
              hintText: 'Password',
              icon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
            ),
            obscureText: true,
            validator: (value) =>
                value.isEmpty ? "Password can't be empty" : null,
            controller: _passwordController,
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
                  : value != _passwordController.text
                      ? 'Password did not match'
                      : null;
            },
            controller: _passwordConfirmController,
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
            onPressed: _onRegisterButtonPressed,
          ),
        );

        var errorMessageField = state is AuthenticationError
            ? Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  state.error,
                  style: TextStyle(color: Colors.red),
                ),
              )
            : Container();

        var loadingIndicator = (state is AuthenticationLoading)
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                color: Colors.white.withOpacity(0.8),
              )
            : Container();

        return Scaffold(
          appBar: AppBar(
            title: Text('Register'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
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
                loadingIndicator,
              ],
            ),
          ),
        );
      },
    );
  }
}
