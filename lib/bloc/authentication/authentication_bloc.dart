import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/repository/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

// appstarted, loading, authenticated, unauthenticated
// loginstart, loginsuccess, loginfailure

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  get initialState => AuthenticationUnauthenticated();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final String uid = await userRepository.getUid();
      print(uid);
      if (uid != null) {
        yield AuthenticationAuthenticated(uid: uid);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoginStart) {
      yield AuthenticationLoading();
      try {
        final String uid = await userRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        dispatch(LoginSuccess(uid: uid));
      } catch (e) {
        dispatch(LoginError(error: e.toString()));
      }
    }

    if (event is LoginSuccess) {
      await userRepository.persistUid(event.uid);
      yield AuthenticationAuthenticated(uid: event.uid);
    }

    if (event is LoginError) {
      yield AuthenticationError(error: event.error);
    }

    if (event is LoggedOut) {
      await userRepository.deleteUid();
      yield AuthenticationUnauthenticated();
    }
  }
}
