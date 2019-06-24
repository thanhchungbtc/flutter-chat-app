import 'package:chat_app_flutter/redux/action.dart';
import 'package:chat_app_flutter/redux/reducer/root_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class _ViewModel {
  bool isLoading;
  String errorMessage;
  Function() onLoginPressed;

  _ViewModel({this.onLoginPressed, this.isLoading, this.errorMessage});
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel(
          errorMessage: store.state.login.error,
          isLoading: store.state.login.isLoading,
          onLoginPressed: () {
            if (formKey.currentState.validate()) {
              store.dispatch(LoginRequestAction(
                navigatorState: Navigator.of(context),
                email: _emailController.text,
                password: _passwordController.text,
              ));
            }
          },
        );
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Stack(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    FlutterLogo(),
                    _EmailField(controller: _emailController),
                    _PasswordField(controller: _passwordController),
                    _LoginButton(onLoginPressed: vm.onLoginPressed),
                    _RegisterButton(),
                    _ErrorMessageField(errorMessage: vm.errorMessage)
                  ],
                ),
              ),
              _LoadingIndicator(
                isLoading: vm.isLoading,
              )
            ],
          ),
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  _EmailField({this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(icon: Icon(Icons.lock, color: Colors.grey)),
      validator: (value) => value.isEmpty ? "Email can't be empty" : null,
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  _PasswordField({this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(icon: Icon(Icons.lock, color: Colors.grey)),
      obscureText: true,
      validator: (value) => value.isEmpty ? "password can't be empty" : null,
    );
  }
}

class _LoginButton extends StatelessWidget {
  final Function() onLoginPressed;

  _LoginButton({@required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Login'),
      onPressed: onLoginPressed,
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Register'),
      onPressed: () {
        Navigator.of(context).pushNamed('/register');
      },
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final bool isLoading;

  _LoadingIndicator({this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Positioned(
            child: Container(
              child: Center(child: CircularProgressIndicator()),
              color: Colors.white.withOpacity(0.8),
            ),
          )
        : Container();
  }
}

class _ErrorMessageField extends StatelessWidget {
  final String errorMessage;

  _ErrorMessageField({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: errorMessage != null
            ? Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              )
            : Container(),
      ),
    );
  }
}
