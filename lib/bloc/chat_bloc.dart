import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/bloc/home_bloc.dart';
import 'package:chat_app_flutter/model.dart';
import 'package:chat_app_flutter/repository/message_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class ChatEvent {}

class ChatEventFetchMessages extends ChatEvent {
  final String fromUid, toUid;

  ChatEventFetchMessages({this.fromUid, this.toUid});
}

class ChatEventSendMessage extends ChatEvent {
  final String content, fromUid, threadId;

  ChatEventSendMessage({@required this.content, @required this.fromUid, @required this.threadId});
}

class ChatState {
  bool isLoading, isSending;
  String threadId, fromUid, toUid;
  String composeMessageContent;
  Stream<QuerySnapshot> messageStream;
  String error;

  ChatState({
    this.error,
    this.messageStream,
    this.threadId,
    this.fromUid,
    this.toUid,
    this.isLoading,
    this.isSending,
  });

  factory ChatState.init() {
    return ChatState(
      isLoading: false,
      isSending: false,
      fromUid: '',
      toUid: '',
      error: '',
      messageStream: null,
      threadId: '',
    );
  }

  factory ChatState.loading() {
    return ChatState(
      isLoading: true,
      isSending: false,
      fromUid: '',
      toUid: '',
      error: '',
      messageStream: null,
      threadId: '',
    );
  }

  factory ChatState.success(String fromUid, String toUid, String threadId,
      Stream stream) {
    return ChatState(
      isLoading: false,
      isSending: false,
      fromUid: fromUid,
      toUid: toUid,
      threadId: threadId,
      messageStream: stream,
      error: '',
    );
  }

  factory ChatState.error(String str) {
    return ChatState(
      isLoading: false,
      isSending: false,
      fromUid: '',
      toUid: '',
      error: str,
      threadId: '',
      messageStream: null,
    );
  }
  factory ChatState.from(ChatState state) {
    return ChatState(
      isLoading: state.isLoading,
      isSending: state.isSending,
      fromUid: state.fromUid,
      toUid: state.toUid,
      error: state.error,
      threadId: state.threadId,
      messageStream: state.messageStream,
    );
  }
  factory ChatState.sending(ChatState state) {
    return ChatState.from(state)..isSending=true;
  }
  factory ChatState.sent(ChatState state) {
    return ChatState.from(state)..isSending=false;
  }
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  MessageRepository messageRepository;

  ChatBloc({this.messageRepository});

  @override
  ChatState get initialState => ChatState.init();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatEventFetchMessages) {
      try {
        yield ChatState.loading();
        final threadId = await messageRepository.getOrCreateThreadId(
            fromUid: event.fromUid, toUid: event.toUid);
        print(threadId);

        final stream = messageRepository.getMessageStream(threadId);
        yield ChatState.success(event.fromUid, event.toUid, threadId, stream);
      } catch (e) {
        yield ChatState.error(e.toString());
      }
    }
    if (event is ChatEventSendMessage) {
      yield ChatState.sending(currentState);
      await messageRepository.sendMessage(
        event.threadId,
        Message(
          content: event.content,
          sentTimestamp: Timestamp.now(),
          sentFromId: event.fromUid,
        ),
      );
      yield ChatState.sent(currentState);
    }
  }
}
