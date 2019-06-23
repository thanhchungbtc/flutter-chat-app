import 'package:chat_app_flutter/bloc/chat/chat.dart';
import 'package:chat_app_flutter/bloc/navigation/navigation_bloc.dart';
import 'package:chat_app_flutter/repository/message.dart';
import 'package:chat_app_flutter/repository/user.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/bloc/authentication/authentication.dart';
import 'package:chat_app_flutter/ui/chat.dart';
import 'package:chat_app_flutter/ui/home.dart';
import 'package:chat_app_flutter/ui/login.dart';
import 'package:chat_app_flutter/ui/register.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  UserRepository userRepository = UserRepository();
  MessageRepository messageRepository = MessageRepository();
  runApp(BlocProviderTree(
    blocProviders: [
      BlocProvider<AuthenticationBloc>(
        builder: (context) => AuthenticationBloc(userRepository: userRepository)
          ..dispatch(AppStarted()),
      ),
      BlocProvider<NavigationBloc>(
        builder: (context) => NavigationBloc(),
      ),
      BlocProvider<ChatBloc>(
        builder: (context) => ChatBloc(messageRepository: messageRepository),
      )
    ],
    child: MyApp(),
  ));
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

//  @override
//  void onEvent(Bloc bloc, Object event) {
//    super.onEvent(bloc, event);
//    print(event);
//  }
//
//  @override
//  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
//    super.onError(bloc, error, stacktrace);
//    print(error);
//  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/chat': (context) => ChatScreen(),
        });
  }
}
