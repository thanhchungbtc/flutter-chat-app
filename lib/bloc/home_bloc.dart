import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent {}

class HomeEventFetchUsers extends HomeEvent {}

@immutable
class HomeState {
  final Stream<QuerySnapshot> userStream;
  final String error;
  HomeState({this.userStream, this.error});

  factory HomeState.init() {
    return HomeState(
      userStream: null,
      error: null,
    );
  }

  factory HomeState.success(Stream stream) {
    return HomeState(
      userStream: stream,
      error: null,
    );
  }

  factory HomeState.error(String str) {
    return HomeState(
      error: str,
      userStream: null,
    );
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserRepository userRepository;

  HomeBloc({this.userRepository});

  @override
  HomeState get initialState => HomeState.init();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeEventFetchUsers) {
      try {
        final stream = userRepository.getUserStream();
        yield HomeState.success(stream);
      } catch (e) {
        yield HomeState.error(e.toString());
      }
    }
  }
}
