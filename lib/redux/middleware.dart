import 'package:chat_app_flutter/repository/message_repository.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:redux/redux.dart';

import 'action.dart';

class AppMiddleware extends MiddlewareClass {
  UserRepository userRepository;
  MessageRepository messageRepository;

  AppMiddleware({this.userRepository, this.messageRepository});

  @override
  void call(Store store, action, NextDispatcher next) async {
    if (action is LoginRequestAction) {
      try {
        next(LoginRequestStartAction());
        final user = await userRepository.signInWithCredentials(
          action.email,
          action.password,
        );
        next(LoginRequestSuccessAction(user: user));

        // fetch data and navigate to home screen
        store.dispatch(FetchUsersRequestAction());
        action.navigatorState.pushNamed('/home');
      } catch (e) {
        print(e);
        next(LoginRequestErrorAction(error: e.toString()));
      }
    }
    if (action is RegisterRequestAction) {
      try {
        final user = await userRepository.signUp(
            email: action.email, password: action.password);
        next(LoginRequestSuccessAction(user: user));

        // fetch data and navigate to home screen
        store.dispatch(FetchUsersRequestAction());
        action.navigatorState.pushNamed('/home');
      } catch (e) {
        next(LoginRequestErrorAction(error: e.toString()));
      }
    }

    if (action is FetchUsersRequestAction) {
      try {
        print("Fetch");
        final userStream = userRepository.getUserStream();
        next(FetchUsersRequestSuccessAction(
          userStream: userStream,
        ));
      } catch (e) {
        next(FetchUsersRequestErrorAction(error: e.toString()));
      }
    }

    if (action is FetchMessagesRequestAction) {
      try {
        next(FetchMessagesRequestStartAction());
        action.navigatorState.pushNamed('/chat');

        final threadId = await messageRepository.getOrCreateThreadId(
          fromUid: action.fromUid,
          toUid: action.toUid,
        );
        final messageStream =  messageRepository.getMessageStream(threadId);
        next(FetchMessagesRequestSuccessAction(
          threadId: threadId,
          messageStream: messageStream,
        ));
      } catch (e) {
        next(FetchMessagesRequestErrorAction(error: e.toString()));
      }
    }
    
    if (action is SendMessageRequestAction) {
      await messageRepository.sendMessage(action.threadId, action.message);
    }
  }
}
