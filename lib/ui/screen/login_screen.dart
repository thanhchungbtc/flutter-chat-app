import 'package:chat_app_flutter/bloc/auth_bloc.dart';
import 'package:chat_app_flutter/bloc/login_bloc.dart';
import 'package:chat_app_flutter/ui/widget/loading_indication.dart';
import 'package:chat_app_flutter/ui/widget/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthEvent, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (BuildContext context, state) {
        if (state.isAuthenticated()) {
          Navigator.of(context).pushReplacementNamed('/home');
          return;
        }
      },
      child: BlocBuilder<LoginEvent, LoginState>(
          bloc: BlocProvider.of<LoginBloc>(context),
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(title: Text('Login')),
              body: Stack(
                children: [
                  LoginForm(),
                  Positioned(
                      child: LoadingIndicator(isLoading: state.isLoading)),
                ],
              ),
            );
          }),
    );
  }
}
