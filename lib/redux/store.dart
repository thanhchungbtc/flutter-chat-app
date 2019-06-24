
import 'package:chat_app_flutter/repository/message_repository.dart';
import 'package:chat_app_flutter/repository/user_repository.dart';
import 'package:redux/redux.dart';

import 'middleware.dart';
import 'reducer/root_reducer.dart';

createStore() => Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: [
        AppMiddleware(
          messageRepository: MessageRepository(),
          userRepository: UserRepository(),
        ),
      ],
    );
