import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model.dart';

abstract class ActionBase extends Equatable {}

abstract class AsyncActionBase extends Equatable {
  AsyncActionBase([List props = const []]) : super(props);
}

class LoginRequestAction extends AsyncActionBase {
  final NavigatorState navigatorState;
  final String email, password;
  LoginRequestAction({this.navigatorState, this.email, this.password})
      : super([navigatorState]);
}

class RegisterRequestAction extends AsyncActionBase {
  final NavigatorState navigatorState;
  final String email, password;
  RegisterRequestAction({this.navigatorState, this.email, this.password})
      : super([navigatorState]);
}

class LoginRequestStartAction extends ActionBase {}

class LoginRequestSuccessAction extends ActionBase {
  User user;
  LoginRequestSuccessAction({this.user});
}

class LoginRequestErrorAction extends ActionBase {
  String error;
  LoginRequestErrorAction({this.error});
}

class FetchUsersRequestAction extends AsyncActionBase {
}

class FetchUsersRequestStartAction extends ActionBase {}

class FetchUsersRequestSuccessAction extends ActionBase {
  Stream userStream;
  FetchUsersRequestSuccessAction({this.userStream});
}

class FetchUsersRequestErrorAction extends ActionBase {
  String error;
  FetchUsersRequestErrorAction({this.error});
}

class FetchMessagesRequestAction extends AsyncActionBase {
  final NavigatorState navigatorState;
  final String fromUid, toUid;
  FetchMessagesRequestAction({this.navigatorState, this.fromUid, this.toUid})
      : super([navigatorState]);
}

class FetchMessagesRequestStartAction extends ActionBase {}

class FetchMessagesRequestSuccessAction extends ActionBase {
  final String threadId;
  Stream messageStream;
  FetchMessagesRequestSuccessAction({this.threadId, this.messageStream});
}

class FetchMessagesRequestErrorAction extends ActionBase {
  String error;
  FetchMessagesRequestErrorAction({this.error});
}

class SendMessageRequestAction extends AsyncActionBase{
  final String threadId;
  final Message message;
  SendMessageRequestAction({this.threadId, this.message});
}