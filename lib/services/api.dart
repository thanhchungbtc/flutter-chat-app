import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {}

class Auth {
  static Future<FirebaseUser> signInWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final docSnapshot = await Firestore.instance.collection('users').document(user.uid).get();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', docSnapshot.data['uid']);
      await prefs.setString('photoUrl', docSnapshot.data['photoUrl']);
      await prefs.setString('displayName', docSnapshot.data['displayName']);

      print(prefs.get('uid'));
      return user;
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  static Future<FirebaseUser> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userData = {
        'uid': user.uid,
        'photoUrl':
        'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
        'displayName': email,
      };
      Firestore.instance.collection('users').document(user.uid).setData(
          userData);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', userData['uid']);
      prefs.setString('photoUrl', userData['photoUrl']);
      prefs.setString('displayName', userData['displayName']);

      return user;
    } catch (e) {
      print("ERROR");
      print(e);
      throw Exception(e.toString());
    }
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('uid');
      prefs.remove('photoUrl');
      prefs.remove('displayName');
    } catch (e) {

    }
  }

  static Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.get('uid');
    return uid != null;
  }
}

class LocalStorage {
}
