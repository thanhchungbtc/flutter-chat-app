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
      if (uid != null) {
        yield AuthenticationAuthenticated(uid: uid);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoginStart) {
      yield AuthenticationLoading();
      try {
        final String uid = await userRepository.loginWithEmailAndPassword(
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

    if (event is LogoutStart) {
      yield AuthenticationLoading();
      await userRepository.logout();
      dispatch(LogoutSuccess());
    }

    if (event is LogoutSuccess) {
      await userRepository.deleteUid();
      yield AuthenticationUnauthenticated();
    }

    if (event is RegisterStart) {
      try {
        yield AuthenticationLoading();
        String uid = await userRepository.createUserWithEmailAndPassword(
            event.email, event.password);
        dispatch(RegisterSuccess(uid: uid));
      } catch (e) {
        dispatch(RegisterError(error: e.toString()));
      }
    }
    
    if (event is RegisterSuccess) {
      await userRepository.persistUid(event.uid);
      yield AuthenticationAuthenticated(uid: event.uid);
    }

    if (event is RegisterError) {
      yield AuthenticationError(error: event.error);
    }
  }
}
