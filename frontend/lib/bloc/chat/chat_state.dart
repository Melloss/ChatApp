// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

class ChatState {
  final List<ChatModel> chats;

  ChatState({required this.chats});

  ChatState copyWith({
    List<ChatModel>? chats,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
    );
  }
}
