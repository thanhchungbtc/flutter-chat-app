import 'package:chat_app_flutter/bloc/chat_bloc.dart';
import 'package:chat_app_flutter/bloc/home_bloc.dart';
import 'package:chat_app_flutter/repository/message_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'repository/user_repository.dart';
import 'ui/screen/chat_screen.dart';
import 'ui/screen/home_screen.dart';
import 'ui/screen/login_screen.dart';
import 'ui/screen/register_screen.dart';

void main() {
  UserRepository userRepository = UserRepository();
  MessageRepository messageRepository = MessageRepository();
  runApp(
    BlocProvider<AuthBloc>(
      builder: (context) => AuthBloc(userRepository: userRepository)
        ..dispatch(AuthEventAppStarted()),
      child: BlocProviderTree(
        blocProviders: [
          BlocProvider<HomeBloc>(
            builder: (context) => HomeBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ChatBloc>(
            builder: (context) => ChatBloc(
              messageRepository: messageRepository,
            ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
