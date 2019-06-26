import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/model.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent {}

class HomeEventFetchUserStream extends HomeEvent {}

@immutable
class HomeState {
  Stream<QuerySnapshot> userStream;
  String errorMsg;

  HomeState({
    this.userStream = const Stream.empty(),
    this.errorMsg = '',
  });

  HomeState _setProps({
    Stream userStream,
    String errorMSg,
  }) =>
      HomeState(
        userStream: userStream ?? this.userStream,
        errorMsg: errorMSg ?? '',
      );

  factory HomeState.init() => HomeState();

  HomeState stream(Stream stream) => _setProps(userStream: stream);

  HomeState error(String errorMsg) => _setProps(errorMSg: errorMsg);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserRepository userRepository;

  HomeBloc({@required this.userRepository});

  @override
  HomeState get initialState => HomeState.init();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeEventFetchUserStream) {
      try {
        final stream = userRepository.getUserStream();
        yield currentState.stream(stream);
      } catch (e) {
        yield currentState.error(e.toString());
      }
    }
  }
}
