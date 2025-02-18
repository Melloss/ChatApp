import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/model/chat_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState(chats: [])) {
    on<SetChats>((event, emit) {
      emit(state.copyWith(
        chats: event.chats,
      ));
    });
    on<AddChat>((event, emit) {
      final prevChats = state.chats;
      prevChats.add(event.chat);
      emit(state.copyWith(
        chats: prevChats,
      ));
    });
    on<CleanChat>((event, emit) {
      emit(state.copyWith(chats: []));
    });
  }
}
