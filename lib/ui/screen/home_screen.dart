import 'dart:math';

import 'package:chat_app_flutter/bloc/auth_bloc.dart';
import 'package:chat_app_flutter/bloc/chat_bloc.dart';
import 'package:chat_app_flutter/bloc/home_bloc.dart';
import 'package:chat_app_flutter/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc;
  String loginUid;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context)
      ..dispatch(HomeEventFetchUserStream());
    final authBloc = BlocProvider.of<AuthBloc>(context);
    if (authBloc.currentState.isAuthenticated()) {
      loginUid = authBloc.currentState.uid;
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthEvent, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (context, state) {
        if (!state.isAuthenticated()) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: BlocBuilder<HomeEvent, HomeState>(
          bloc: homeBloc,
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Home'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).dispatch(
                          AuthEventSignOut(
                            completeCallback: () => Navigator.of(context)
                                .pushReplacementNamed('/login'),
                          ),
                        );
                      },
                    )
                  ],
                ),
                body: StreamBuilder<QuerySnapshot>(
                  stream: state.userStream,
                  builder: (context, qs) {
                    if (!qs.hasData) {
                      return Container();
                    }
                    final users = qs.data.documents;
                    final loginUid =
                        BlocProvider.of<AuthBloc>(context).currentState.uid;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = User.fromMap(users[index].data);
                        final toUid = user.uid;
                        if (toUid == loginUid) return Container();
                        return ListTile(
                          title: Text(user.email),
                          onTap: () {
                            Navigator.of(context).pushNamed('/chat');
                            String threadId = loginUid.compareTo(toUid) < 0
                                ? "$loginUid-$toUid"
                                : "$toUid-$loginUid";
                            BlocProvider.of<ChatBloc>(context).dispatch(
                                ChatEventFetchMessageStream(
                                    threadId: threadId));
                          },
                        );
                      },
                    );
                  },
                ));
          }),
    );
  }
}
