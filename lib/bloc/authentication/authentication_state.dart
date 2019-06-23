import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() {
    return "AuthenticationUnauthenticated";
  }
}

class AuthenticationAuthenticated extends AuthenticationState {
  final String uid;

  AuthenticationAuthenticated({@required this.uid}) : super([uid]);

  @override
  String toString() {
    return "AuthenticationAuthenticated";
  }
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() {
    return "AuthenticationLoading";
  }
}

class AuthenticationError extends AuthenticationState {
  final String error;

  AuthenticationError({@required this.error});

  @override
  String toString() {
    return "AuthenticationError";
  }
}
