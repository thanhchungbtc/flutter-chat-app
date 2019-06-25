import 'package:chat_app_flutter/bloc/auth_bloc.dart';
import 'package:chat_app_flutter/bloc/register_bloc.dart';
import 'package:chat_app_flutter/ui/widget/loading_indication.dart';
import 'package:chat_app_flutter/ui/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthEvent, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (BuildContext context, state) {
        if (state.isAuthenticated()) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/home');
          return;
        }
      },
      child: BlocBuilder<RegisterEvent, RegisterState>(
        bloc: BlocProvider.of<RegisterBloc>(context),
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(title: Text('Register')),
            body: Stack(
              children: <Widget>[
                RegisterForm(),
                Positioned(child: LoadingIndicator(isLoading: state.isLoading)),
              ],
            ),
          );
        }
      ),
    );
  }
}
