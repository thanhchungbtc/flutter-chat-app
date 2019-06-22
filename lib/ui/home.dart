import 'package:chat_app_flutter/services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _HomeScreenState extends State<HomeScreen> {
  String _userId;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _userId = prefs.get('uid');
      });
    });
  }

  void handleSignOut(BuildContext context) async {
    await Auth.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) return Container();
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => handleSignOut(context),
            )
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('No one online yet'),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                itemCount: snapshot.data.documents.length,
//                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final userData = snapshot.data.documents[index];
                  if (_userId == userData['uid']) return Container();

                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/chat', arguments: {'toUserId': userData['uid']});
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userData['photoUrl']),
//                      child: Text(userData['displayName'][0]),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userData['displayName'],
                              style: Theme.of(context).textTheme.title,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Hello',
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            }
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
