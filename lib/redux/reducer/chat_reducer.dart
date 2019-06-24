import '../action.dart';

class ChatState {
  String threadId, error;
  Stream messageStream;
  bool isLoading;
  ComposeMessageFormState composeMessageForm;

  ChatState({this.threadId, this.messageStream, this.isLoading});

  factory ChatState.init() {
    return ChatState(
      isLoading: false,
      threadId: null,
      messageStream: null,
    );
  }
}

class ComposeMessageFormState {
  bool isSubmitting;
  String content;
}

ChatState chatReducer(ChatState state, action) {
  if (action is FetchMessagesRequestStartAction) {
    return ChatState.init()..isLoading = true;
  }
  if (action is FetchMessagesRequestSuccessAction) {

    return ChatState.init()..messageStream = action.messageStream;
  }
  if (action is FetchMessagesRequestErrorAction) {
    return ChatState();
  }
  return state;
}
