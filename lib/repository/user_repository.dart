import 'dart:async';
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

  Future<FirebaseUser> signInWithCredentials(
      {String email, String password}) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<FirebaseUser> signUp({String email, String password}) async {
    final fbUser = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').document(fbUser.uid).setData({
      'uid': fbUser.uid,
      'email': fbUser.email,
      'displayName': fbUser.displayName,
      'photoUrl': fbUser.photoUrl,
    });
    return fbUser;
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

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser();
  }

  Stream<QuerySnapshot> getUserStream() {
    return _firestore.collection('users').snapshots();
  }
}
