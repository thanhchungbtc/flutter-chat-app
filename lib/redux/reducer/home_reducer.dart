
import 'package:chat_app_flutter/model.dart';
import 'package:chat_app_flutter/redux/action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeState {
  bool isLoading;
  String error;
  Stream<QuerySnapshot> userStream;
  HomeState({this.userStream, this.error, this.isLoading});
  factory HomeState.init() {
    return HomeState(
      isLoading: false,
      userStream: null,
      error: null,
    );
  }
}

HomeState homeReducer(HomeState state, action) {
  if (action is FetchUsersRequestStartAction) {
    print("userStart");
    return HomeState.init()..isLoading = true;
  }
  if (action is FetchUsersRequestSuccessAction) {
    print("userSuccess");
    return HomeState.init()..userStream = action.userStream;
  }
  if (action is FetchUsersRequestErrorAction) {
    return HomeState(
      error: action.error,
      userStream:
          state.userStream, // keep old state to display when error occurred.
    );
  }
  return state;
}
