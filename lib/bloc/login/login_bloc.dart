import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  get initialState => null;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) {
    return null;
  }
}