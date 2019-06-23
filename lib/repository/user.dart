import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  Future<String> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
//    await Future.delayed(Duration(seconds: 1));
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
    @required String email,
    @required String password,
  ) async {
    var user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userData = {
      'uid': user.uid,
      'photoUrl':
          'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
      'displayName': email,
    };
    _firestore.collection('users').document(user.uid).setData(userData);

    return user.uid;
  }
  Future logout() async {
    await _auth.signOut();
  }

  Stream<QuerySnapshot> userStream() {
    return _firestore.collection('users').snapshots();
  }

  Future<String> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get('uid');
  }

  Future<bool> persistUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('uid', uid);
  }
  Future<bool> deleteUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('uid');
  }
}
