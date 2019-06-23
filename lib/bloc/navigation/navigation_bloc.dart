import 'package:bloc/bloc.dart';

import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  @override
  get initialState => NavigationTarget(target: 'home');

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is ChangeScreen) {
      if (event.target != (currentState as ChangeScreen).target) {
        yield NavigationTarget(target: event.target);
      }
    }
  }
}
