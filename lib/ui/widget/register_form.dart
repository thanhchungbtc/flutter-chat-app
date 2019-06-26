import 'package:chat_app_flutter/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthEvent, AuthState>(
      bloc: bloc,
      builder: (context, state) {
        onRegisterButtonPresed() {
          if (_formKey.currentState.validate()) {
            FocusScope.of(context).requestFocus(FocusNode());
            bloc.dispatch(AuthEventSignUp(
              email: _emailController.text,
              password: _passwordController.text,
            ));
          }
        }

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
            validator: (value) =>
                value.isEmpty ? "Password can't be empty" : null,
            controller: _passwordController,
          ),
        );

        var passwordConfirmField = Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
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
              'Register',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: onRegisterButtonPresed,
          ),
        );

        var errorMessageField = state.hasError()
            ? Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  state.errorMsg,
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
                  passwordConfirmField,
                  registerButton,
                  errorMessageField,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
