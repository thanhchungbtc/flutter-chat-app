import 'dart:async';
import 'package:chat_app_flutter/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;

  UserRepository({
    FirebaseAuth firebaseAuth,
    Firestore firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? Firestore.instance;

  Future<User> signInWithCredentials(String email, String password) async {
    return _getUserFromFirebaseUser(
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<User> signUp({String email, String password}) async {
    final fbUser = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = _getUserFromFirebaseUser(fbUser);
    await _firestore.collection('users').document(user.uid).setData({
      'uid': fbUser.uid,
      'displayName': fbUser.displayName,
      'photoUrl': '',
    });
    return user;
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<User> getUser() async {
    return _getUserFromFirebaseUser(
      await _firebaseAuth.currentUser(),
    );
  }

  Stream<QuerySnapshot> getUserStream() {
    return _firestore.collection('users').snapshots();
  }

  User _getUserFromFirebaseUser(FirebaseUser user) {
    return User(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
    );
  }
}
