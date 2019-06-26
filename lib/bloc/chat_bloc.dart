import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/bloc/home_bloc.dart';
import 'package:chat_app_flutter/model.dart';
import 'package:chat_app_flutter/repository/message_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class ChatEvent {}

class ChatEventFetchMessageStream extends ChatEvent {
  final String threadId;

  ChatEventFetchMessageStream({@required this.threadId});
}

class ChatEventSendMessage extends ChatEvent {
  final String threadId;
  final Message message;

  ChatEventSendMessage({@required this.threadId, @required this.message});
}

class ChatState {
  bool isSending;
  String threadId;
  Stream<QuerySnapshot> messageStream;
  String errorMsg;

  ChatState({
    this.errorMsg = '',
    this.messageStream = const Stream.empty(),
    this.threadId = '',
    this.isSending = false,
  });

  ChatState _setProps({
    String errorMsg,
    Stream messageStream,
    String threadId,
    bool isSending,
  }) =>
      ChatState(
        errorMsg: errorMsg ?? '',
        messageStream: messageStream ?? this.messageStream,
        threadId: threadId ?? this.threadId,
        isSending: isSending ?? this.isSending,
      );

  factory ChatState.init() => ChatState();

  ChatState sending() => _setProps(isSending: true);

  ChatState sent() => _setProps(isSending: false);

  ChatState error(String errorMsg) => _setProps(errorMsg: errorMsg);

  ChatState stream(String threadId, Stream stream) =>
      _setProps(messageStream: stream, threadId: threadId);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  MessageRepository messageRepository;

  ChatBloc({this.messageRepository});

  @override
  ChatState get initialState => ChatState.init();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatEventFetchMessageStream) {
      try {
        final stream = messageRepository.getMessageStream(event.threadId);
        yield currentState.stream(event.threadId, stream);
      } catch (e) {
        yield currentState.error(e.toString());
      }
    }
    if (event is ChatEventSendMessage) {
      yield currentState.sending();
      await messageRepository.sendMessage(event.threadId, event.message);
      yield currentState.sent();
    }
  }
}
