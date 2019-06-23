import 'package:chat_app_flutter/bloc/authentication/authentication.dart';
import 'package:chat_app_flutter/repository/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc bloc = BlocProvider.of(context);

    return BlocListener(
      bloc: bloc,
      listener: (context, state) {
        if (state is AuthenticationError) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('${state.error}'),
            backgroundColor: Colors.red,
          ));
        }
        if (state is AuthenticationAuthenticated) {
          Navigator.of(context).pushNamed('/home');
        }
      },
      child: BlocBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: bloc,
        builder: (context, state) {

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

          onLoginButtonPresed() {
            bloc.dispatch(LoginStart(
              email: _emailController.text,
              password: _passwordController.text,
            ));
          }

          onRegisterButtonPressed() {}

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
          var loadingIndicator = (state is AuthenticationLoading)
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container();
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        logo,
                        emailField,
                        passwordField,
                        loginButton,
                        registerButton,
                      ],
                    ),
                  ),
                  loadingIndicator,
                ],
              ));
        },
      ),
    );
  }
}
