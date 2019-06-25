import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:meta/meta.dart';

import 'auth_bloc.dart';

abstract class RegisterEvent {}

class RegisterEventSubmitted extends RegisterEvent {
  final String email, password;
  RegisterEventSubmitted({@required this.email, @required this.password});
}

class RegisterState {
  String email, password;
  String error;
  bool isLoading;
  RegisterState({
    this.email,
    this.password,
    this.error,
    this.isLoading,
  });

  factory RegisterState.init() {
    return RegisterState(
      isLoading: false,
      email: '',
      password: '',
      error: '',
    );
  }
  factory RegisterState.submitting() {
    return RegisterState(
      isLoading: true,
      email: '',
      password: '',
      error: '',
    );
  }
  factory RegisterState.error(String str) {
    return RegisterState(
      email: '',
      password: '',
      error: str,
      isLoading: false,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      email: '',
      password: '',
      error: '',
      isLoading: false,
    );
  }

  bool hasError() {
    return !error.isEmpty;
  }
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository userRepository;
  AuthBloc authBloc;

  RegisterBloc({@required this.userRepository, @required this.authBloc});

  @override
  RegisterState get initialState => RegisterState.init();
  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEventSubmitted) {
      yield* _mapSubmittedToState(event);
    }
  }

  Stream<RegisterState> _mapSubmittedToState(
      RegisterEventSubmitted event) async* {
    try {
      yield RegisterState.submitting();
      final user = await userRepository.signUp(
        email: event.email,
        password: event.password,
      );
      yield RegisterState.success();
      authBloc.dispatch(AuthEventSignedIn(uid: user.uid));
    } catch (e) {
      yield RegisterState.error(e.toString());
    }
  }
}
