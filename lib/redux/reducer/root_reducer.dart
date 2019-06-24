import 'chat_reducer.dart';
import 'home_reducer.dart';
import 'login_reducer.dart';

class AppState {
  LoginState login;
  HomeState home;
  ChatState chat;

  AppState({this.login, this.home, this.chat});

  factory AppState.init() {
    return AppState(
      login: LoginState.init(),
      home: HomeState.init(),
      chat: ChatState.init(),
    );
  }
}

AppState appReducer(AppState state, action) {
  return AppState(
      login: loginReducer(state.login, action),
      home: homeReducer(state.home, action),
      chat: chatReducer(state.chat, action));
}
