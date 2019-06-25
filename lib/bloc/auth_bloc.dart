import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthEvent extends Equatable {}

class AuthEventAppStarted extends AuthEvent {}

class AuthEventSignedIn extends AuthEvent {
  final String uid;

  AuthEventSignedIn({@required this.uid});
}

class AuthEventSignedOut extends AuthEvent {}

class AuthState {
  String uid, error;

  AuthState({this.uid, this.error});

  bool isAuthenticated() {
    return !uid.isEmpty;
  }

  factory AuthState.init() {
    return AuthState(
      uid: "",
      error: "",
    );
  }

  factory AuthState.authenticated({@required String uid}) {
    return AuthState(
      uid: uid,
      error: "",
    );
  }

  factory AuthState.unauthenticated({String error}) {
    return AuthState(
      uid: "",
      error: error,
    );
  }
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserRepository userRepository;

  AuthBloc({@required this.userRepository});

  @override
  AuthState get initialState => AuthState.init();

  @override
  Stream<AuthState> mapEventToState(event) async* {
    if (event is AuthEventAppStarted) {
      yield* _mapAppStartedToState(event);
    }
    if (event is AuthEventSignedIn) {
      yield* _mapSignedInToState(event);
    }
    if (event is AuthEventSignedOut) {
      yield* _mapSignedOutToState(event);
    }
  }

  Stream<AuthState> _mapAppStartedToState(AuthEventAppStarted event) async* {
    try {
      bool isSignedIn = await userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await userRepository.getUser();
        yield (AuthState.authenticated(uid: user.uid));
      } else {
        yield (AuthState.unauthenticated());
      }
    } catch (e) {
      yield AuthState.unauthenticated(error: e.toString());
    }
  }

  Stream<AuthState> _mapSignedInToState(AuthEventSignedIn event) async* {
    try {
      yield AuthState.authenticated(uid: event.uid);
    } catch (e) {
      yield AuthState.unauthenticated(error: e.toString());
    }
  }

  Stream<AuthState> _mapSignedOutToState(AuthEventSignedOut event) async* {
    try {
      await userRepository.signOut();
      yield AuthState.unauthenticated();
    } catch (e) {
      yield AuthState.unauthenticated(error: e.toString());
    }
  }
}
