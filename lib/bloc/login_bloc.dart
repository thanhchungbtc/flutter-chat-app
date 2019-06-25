import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:meta/meta.dart';

import 'auth_bloc.dart';

abstract class LoginEvent {}

class LoginEventSubmitted extends LoginEvent {
  final String email, password;
  LoginEventSubmitted({@required this.email, @required this.password});
}

class LoginState {
  String email, password;
  String error;
  bool isLoading;
  LoginState({
    this.email,
    this.password,
    this.error,
    this.isLoading,
  });
  factory LoginState.init() {
    return LoginState(
      email: '',
      password: '',
      error: '',
      isLoading: false,
    );
  }
  factory LoginState.submitting() {
    return LoginState(
      email: '',
      password: '',
      error: '',
      isLoading: true,
    );
  }
  factory LoginState.success() {
    return LoginState(
      email: '',
      password: '',
      error: '',
      isLoading: false,
    );
  }
  factory LoginState.error(str) {
     return LoginState(
      email: '',
      password: '',
      error: str,
      isLoading: false,
    );
  }

  bool hasError() {
    return !error.isEmpty;
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;
  AuthBloc authBloc;

  LoginBloc({@required this.userRepository, @required this.authBloc});

  @override
  LoginState get initialState => LoginState.init();

  @override
  Stream<LoginState> mapEventToState(event) async* {
    if (event is LoginEventSubmitted) {
      yield* _mapSubmittedToState(event);
    }
  }

  Stream<LoginState> _mapSubmittedToState(LoginEventSubmitted event) async* {
    try {
      yield LoginState.submitting();
      final user = await userRepository.signInWithCredentials(
        email: event.email,
        password: event.password,
      );
      yield LoginState.success();
      authBloc.dispatch(AuthEventSignedIn(uid: user.uid));
    } catch (e) {
      yield LoginState.error(e.toString());
    }
  }
}
