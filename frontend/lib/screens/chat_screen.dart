import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/routing.dart';
import 'package:frontend/widgets/loading_widget.dart';
import 'package:frontend/widgets/text_widget.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth/auth_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(GetUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(text: 'Chat App'),
        leadingWidth: 200,
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(RouteName.login);
            },
            child: const TextWidget(text: "Logout"),
          )
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is GetUserLoading) {
            return const Center(
              child: LoadingWidget(
                color: Colors.brown,
              ),
            );
          } else if (state is GetUserSuccess) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    context.pushNamed(
                      RouteName.chatDetail,
                      extra: state.users[index],
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  trailing: state.users[index].status == 'ONLINE'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TextWidget(text: 'Online'),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 30, left: 20),
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        )
                      : null,
                  minLeadingWidth: 0,
                  leading: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: TextWidget(
                        text:
                            '${state.users[index].firstName[0]}${state.users[index].lastName[0]}',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: TextWidget(
                      text:
                          '${state.users[index].firstName} ${state.users[index].lastName}'),
                  subtitle: TextWidget(
                    text: state.users[index].email,
                    type: TextType.small,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
