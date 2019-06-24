import 'package:chat_app_flutter/redux/reducer/root_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'container/chat_screen.dart';
import 'container/home_screen.dart';
import 'container/login_screen.dart';
import 'container/register_screen.dart';
import 'redux/store.dart';

void main() {
  final store = createStore();

  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Demo',
        home: LoginScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/chat': (context) => ChatScreen(),
        },
      ),
    );
  }
}
