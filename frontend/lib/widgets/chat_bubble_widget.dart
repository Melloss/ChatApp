import 'package:flutter/material.dart';
import 'package:frontend/data/model/chat_model.dart';
import 'package:frontend/widgets/text_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatModel chatModel;
  final int toUserId;
  const ChatBubbleWidget(
      {super.key, required this.chatModel, required this.toUserId});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: toUserId == chatModel.toUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        width: 50.sh,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: toUserId != chatModel.toUser
                ? Radius.zero
                : const Radius.circular(10),
            bottomRight: toUserId == chatModel.toUser
                ? Radius.zero
                : const Radius.circular(10),
          ),
        ),
        child: TextWidget(
          text: chatModel.text,
          color: Colors.white,
        ),
      ),
    );
  }
}
