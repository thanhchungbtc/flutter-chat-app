import 'package:chat_app_flutter/bloc/auth_bloc.dart';
import 'package:chat_app_flutter/bloc/chat_bloc.dart';
import 'package:chat_app_flutter/bloc/home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context)
      ..dispatch(HomeEventFetchUsers());
    ;
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
      child: BlocBuilder(
          bloc: homeBloc,
          builder: (context, snapshot) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Home'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () => BlocProvider.of<AuthBloc>(context).dispatch(AuthEventSignedOut()),

                    )
                  ],
                ),
                body: StreamBuilder<QuerySnapshot>(
                  stream: homeBloc.currentState.userStream,
                  builder: (conext, qs) {
                    if (!qs.hasData) {
                      return Container();
                    }
                    final documents = qs.data.documents;
                    final uid = BlocProvider.of<AuthBloc>(context).currentState.uid;
                    print(uid);
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final item = documents[index];
                        if (item['uid'] == uid) return Container();
                        return ListTile(
                          title: Text(item['email'] ?? ''),
                          onTap: () {
                            Navigator.of(context).pushNamed('/chat');
                            BlocProvider.of<ChatBloc>(context).dispatch(
                                ChatEventFetchMessages(
                                    fromUid: uid, toUid: item['uid']));
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
