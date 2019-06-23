import 'package:equatable/equatable.dart';
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

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() {
    return "LoggedOut";
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
