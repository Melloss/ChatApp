part of 'chat_bloc.dart';

sealed class ChatEvent {}

final class SetChats extends ChatEvent {
  final List<ChatModel> chats;

  SetChats({required this.chats});
}

final class AddChat extends ChatEvent {
  final ChatModel chat;

  AddChat({required this.chat});
}

final class CleanChat extends ChatEvent {}
