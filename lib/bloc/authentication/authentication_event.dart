import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() {
    return "AppStarted";
  }
}

class LoginSuccess extends AuthenticationEvent {
  final String uid;

  LoginSuccess({@required this.uid}) : super([uid]);

  @override
  String toString() {
    return "LoginSuccess";
  }
}

class LogoutStart extends AuthenticationEvent {
  @override
  String toString() {
    return "LogoutStart";
  }
}

class LogoutSuccess extends AuthenticationEvent {
  @override
  String toString() {
    return "LogoutSuccess";
  }
}

class LoginError extends AuthenticationEvent {
  final String error;

  LoginError({@required this.error}) : super([error]);

  @override
  String toString() {
    return "LoginError";
  }
}

class LoginStart extends AuthenticationEvent {
  final String email;
  final String password;

  LoginStart({@required this.email, this.password}) : super([email, password]);

  @override
  String toString() {
    return "LoginStart";
  }
}

class RegisterStart extends AuthenticationEvent {
  final String email, password;

  RegisterStart({@required this.email, @required this.password})
      : super([email, password]);
}

class RegisterSuccess extends AuthenticationEvent {
  final String uid;

  RegisterSuccess({@required this.uid}) : super([uid]);

  @override
  String toString() {
    return "RegisterSuccess";
  }
}

class RegisterError extends AuthenticationEvent {
  final String error;

  RegisterError({@required this.error}) : super([error]);

  @override
  String toString() {
    return "RegisterError";
  }
}
