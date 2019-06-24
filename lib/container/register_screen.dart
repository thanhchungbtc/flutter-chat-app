import 'package:chat_app_flutter/redux/action.dart';
import 'package:chat_app_flutter/redux/reducer/root_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class _ViewModel {
  Function() onRegisterPressed;
  _ViewModel({this.onRegisterPressed});
}

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            // TODO: pass navigator state here
            onRegisterPressed: () => store.dispatch(RegisterRequestAction(
                  navigatorState: null,
                  email: _emailController.text,
                  password: _passwordController.text,
                )),
          ),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Form(
            child: Column(
              children: <Widget>[
                FlutterLogo(),
                _EmailField(controller: _emailController),
                _PasswordField(controller: _passwordController),
                _PasswordConfirmationField(
                  controller: _passwordConfirmationController,
                  passwordToMatch: _passwordController.text,
                ),
                _RegisterButton(onRegisterPressed: vm.onRegisterPressed),
              ],
            ),
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
      validator: (value) => value.isEmpty ? "password can't be empty" : null,
    );
  }
}

class _PasswordConfirmationField extends StatelessWidget {
  final TextEditingController controller;
  final String passwordToMatch;
  _PasswordConfirmationField({this.controller, this.passwordToMatch});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(icon: Icon(Icons.lock, color: Colors.grey)),
      validator: (value) => value.isEmpty
          ? "password confirmation can't be empty"
          : value != passwordToMatch ? 'password did not match' : null,
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final Function() onRegisterPressed;
  _RegisterButton({@required this.onRegisterPressed});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Login'),
      onPressed: onRegisterPressed,
    );
  }
}
