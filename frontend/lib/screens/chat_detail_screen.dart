// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/settings/settings.dart';
import 'package:frontend/core/utils/debounce.dart';
import 'package:frontend/core/utils/show_snackbar.dart';
import 'package:frontend/data/model/chat_model.dart';
import 'package:frontend/data/model/user_model.dart';
import 'package:frontend/widgets/chat_bubble_widget.dart';
import 'package:frontend/widgets/text_field_widget.dart';
import 'package:frontend/widgets/text_widget.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../bloc/chat/chat_bloc.dart';

class ChatDetailScreen extends StatefulWidget {
  final UserModel toUser;
  const ChatDetailScreen({super.key, required this.toUser});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final chatController = TextEditingController();
  WebSocket? socket;
  bool isFirstConnection = true;

  final scrollController = ScrollController();
  late StreamSubscription chatSub;

  connectToServer() async {
    try {
      final token = await Settings.getToken();
      socket = WebSocket(
        Uri.parse('ws://localhost:8000/chat/send/${widget.toUser.id}/$token'),
        timeout: const Duration(hours: 1),
      );

      chatSub = socket!.messages.listen((message) {
        final data = json.decode(message);

        if (data.containsKey('chats')) {
          final chatList = data['chats'] as List;
          final chats = chatList.map((c) => ChatModel.fromMap(c)).toList();
          context.read<ChatBloc>().add(SetChats(
                chats: chats,
              ));
        } else {
          final chat = ChatModel.fromMap(data);
          context.read<ChatBloc>().add(AddChat(chat: chat));
        }
        Future.delayed(const Duration(
          milliseconds: 200,
        )).then((c) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });

        log("message: $data");
        log("type: ${data.runtimeType}");
      });
      setState(() {
        socket = socket;
      });
      // connectionSub =
      //     socket.connection.asBroadcastStream().listen((connection) {
      //   log(connection.toString());
      //   if (connection.toString().contains('Connected')) {
      //     if (isFirstConnection) {
      //       socket.send(jsonEncode({'command': "chats"}));
      //       isFirstConnection = false;
      //     }
      //   }
      // });
    } catch (e) {
      showSnackbar(
        context,
        e.toString(),
      );
    }
  }

  @override
  void initState() {
    connectToServer();
    super.initState();
  }

  @override
  void deactivate() {
    socket?.send(jsonEncode({'command': "disconnect"}));
    context.read<ChatBloc>().add(CleanChat());
    super.deactivate();
  }

  @override
  void dispose() {
    socket?.close();
    chatSub.cancel();
    chatController.dispose();
    scrollController.dispose();
    // connectionSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
            text: '${widget.toUser.firstName} ${widget.toUser.lastName}'),
      ),
      body: StreamBuilder(
          stream: socket?.connection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.toString().contains("Connected")) {
                if (isFirstConnection) {
                  socket?.send(jsonEncode({'command': "chats"}));
                  isFirstConnection = false;
                }
              }
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: state.chats.length,
                          itemBuilder: (context, index) {
                            return ChatBubbleWidget(
                              toUserId: widget.toUser.id,
                              chatModel: state.chats[index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  TextFieldWidget(
                    controller: chatController,
                    hintText: 'Message',
                    onFieldSubmitted: (text) {
                      // socket.send(jsonEncode({'command': "chats"}));

                      socket?.send(
                          jsonEncode({'message': chatController.text.trim()}));
                      chatController.clear();
                    },
                    onTab: () {
                      final connectionState = socket?.connection.state;
                      log(connectionState.toString());
                      // socket.send();
                    },
                    suffix: const Icon(
                      Icons.send,
                      color: Colors.brown,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
