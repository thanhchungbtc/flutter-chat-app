import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/repository/message.dart';
import 'package:flutter/cupertino.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository messageRepository;

  ChatBloc({@required this.messageRepository});

  @override
  get initialState => FetchOnlineUserStart();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SelectPerson) {
      yield MessagesLoaded(snapshots: null);

      final String threadId = await messageRepository.retrieveThreadId(
        event.fromUid,
        event.toUid,
      );
      dispatch(FetchMessageStart(threadId: threadId));
    }
    if (event is FetchMessageStart) {
      final snapshots = await messageRepository.messageStream(
        threadId: event.threadId,
      );
      dispatch(
          FetchMessageSuccess(snapshots: snapshots, threadId: event.threadId));
    }

    if (event is FetchMessageSuccess) {
      yield MessagesLoaded(
          snapshots: event.snapshots, threadId: event.threadId);
    }

    if (event is SendMessageStart) {
      await messageRepository.sendMessage(threadId: event.threadId, sendFromUid: event.fromUid, content: event.content);
      dispatch(SendMessageSuccess());
    }
    if (event is SendMessageSuccess) {

    }
  }
}
