import 'dart:math';

import 'package:chat_app_flutter/bloc/authentication/authentication.dart';
import 'package:chat_app_flutter/bloc/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final AuthenticationBloc bloc = BlocProvider.of(context);
    bloc.state.listen((state) {
      if (state is AuthenticationUnauthenticated) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc bloc = BlocProvider.of(context);
    final ChatBloc chatBloc = BlocProvider.of(context);
    final loginUid = (bloc.currentState as AuthenticationAuthenticated).uid;
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                bloc.dispatch(LogoutSuccess());
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: bloc.userRepository.userStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Noone online yet'),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data.documents[index];
                  if (doc['uid'] == loginUid) {
                    return Container();
                  }
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Text('a'),
                          backgroundImage: NetworkImage(
                            doc['photoUrl'],
                          ),
                        ),
                        title: Text(
                          doc['displayName'],
                          style: Theme.of(context).textTheme.title,
                        ),
                        onTap: () {
                          chatBloc.dispatch(SelectPerson(
                            fromUid: loginUid,
                            toUid: doc['uid'],
                          ));
                          Navigator.of(context).pushNamed('/chat');
                        },
                      ),
                      Divider(),
                    ],
                  );
                });
          },
        ));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}
