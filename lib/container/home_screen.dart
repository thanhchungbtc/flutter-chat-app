import 'package:chat_app_flutter/redux/action.dart';
import 'package:chat_app_flutter/redux/reducer/root_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class _ViewModel {
  String uid;
  Stream<QuerySnapshot> userStream;
  Function(String) onRowTap;

  _ViewModel({this.uid, this.userStream, this.onRowTap});
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            uid: store.state.login.user.uid,
            userStream: store.state.home.userStream,
            onRowTap: (toUid) => store.dispatch(FetchMessagesRequestAction(
              navigatorState: Navigator.of(context),
                  fromUid: store.state.login.user.uid,
                  toUid: toUid,
                )),
          ),
      builder: (context, vm) {
        return _HomeScreen(viewModel: vm);
      },
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final _ViewModel viewModel;

  _HomeScreen({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: viewModel.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Empty'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final user = snapshot.data.documents[index];
              if (user['uid'] == viewModel.uid) {
                return Container();
              }
              return ListTile(
                title: Text(user['displayName']),
                onTap: () => viewModel.onRowTap(user['uid']),
              );
            },
          );
        },
      ),
    );
  }
}
