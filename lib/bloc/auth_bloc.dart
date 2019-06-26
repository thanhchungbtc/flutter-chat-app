import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthEvent extends Equatable {}

class AuthEventAppStarted extends AuthEvent {}

class AuthEventSignIn extends AuthEvent {
  final String email, password;

  AuthEventSignIn({@required this.email, @required this.password});
}

class AuthEventSignUp extends AuthEvent {
  final String email, password;

  AuthEventSignUp({@required this.email, @required this.password});
}

class AuthEventSignOut extends AuthEvent {
  final Function() completeCallback;

  AuthEventSignOut({this.completeCallback});
}

class AuthState {
  String uid;
  String errorMsg;
  String email;
  String password;
  bool isLoading;

  AuthState({
    this.uid = '',
    this.errorMsg = '',
    this.email = '',
    this.password = '',
    this.isLoading = false,
  });

  bool isAuthenticated() => uid.isNotEmpty;

  bool hasError() => errorMsg.isNotEmpty;

  AuthState _setProps(
          {String uid,
          String errorMsg,
          String email,
          String password,
          bool isLoading}) =>
      AuthState(
        uid: uid ?? this.uid,
        errorMsg: errorMsg ?? '',
        email: email ?? this.email,
        password: password ?? this.password,
        isLoading: isLoading ?? this.isLoading,
      );

  factory AuthState.init() => AuthState();

  AuthState success({@required String uid}) =>
      _setProps(uid: uid, isLoading: false);

  AuthState unauthenticated(String errorMsg) =>
      AuthState.init()..errorMsg = errorMsg;

  AuthState submitting() => _setProps(isLoading: true);
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
    if (event is AuthEventSignIn) {
      yield* _mapSignInToState(event);
    }
    if (event is AuthEventSignUp) {
      yield* _mapSignUpToState(event);
    }
    if (event is AuthEventSignOut) {
      yield* _mapSignedOutToState(event);
    }
  }

  Stream<AuthState> _mapAppStartedToState(AuthEventAppStarted event) async* {
    try {
      bool isSignedIn = await userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await userRepository.getUser();
        yield (currentState.success(uid: user.uid));
      } else {
        yield (currentState.unauthenticated(''));
      }
    } catch (e) {
      yield currentState.unauthenticated(e.toString());
    }
  }

  Stream<AuthState> _mapSignInToState(AuthEventSignIn event) async* {
    try {
      yield currentState.submitting();
      final user = await userRepository.signInWithCredentials(
        email: event.email,
        password: event.password,
      );
      yield currentState.success(uid: user.uid);
    } catch (e) {
      yield currentState.unauthenticated(e.toString());
    }
  }

  Stream<AuthState> _mapSignUpToState(AuthEventSignUp event) async* {
    try {
      yield currentState.submitting();
      final user = await userRepository.signUp(
        email: event.email,
        password: event.password,
      );
      yield currentState.success(uid: user.uid);
    } catch (e) {
      yield currentState.unauthenticated(e.toString());
    }
  }

  Stream<AuthState> _mapSignedOutToState(AuthEventSignOut event) async* {
    try {
      await userRepository.signOut();
      yield currentState.unauthenticated('');
      if (event.completeCallback != null) {
        event.completeCallback();
      }
    } catch (e) {
      yield currentState.unauthenticated(e.toString());
    }
  }
}
