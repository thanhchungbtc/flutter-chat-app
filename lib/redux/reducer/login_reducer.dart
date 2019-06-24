
import 'package:chat_app_flutter/model.dart';
import 'package:chat_app_flutter/redux/action.dart';

class LoginState {
  bool isLoading;
  bool isAuthenticated;
  String error;
  User user;

  LoginState({this.isLoading, this.isAuthenticated, this.user});
  factory LoginState.init() {
    return LoginState(
      isLoading: false,
      isAuthenticated: false,
      user: null,
    );
  }
}

LoginState loginReducer(LoginState state, action) {
  if (action is LoginRequestStartAction) {
    print("Login start");
    return LoginState.init()..isLoading = true;
  }
  if (action is LoginRequestSuccessAction) {
    print("Login Success");
    return LoginState.init()
      ..user = action.user
      ..isAuthenticated = true;
  }
  if (action is LoginRequestErrorAction) {
    return LoginState.init()..error = action.error;
  }
  return state;
}
