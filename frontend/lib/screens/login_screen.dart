import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/routing.dart';
import 'package:frontend/core/utils/show_snackbar.dart';
import 'package:frontend/widgets/button_widget.dart';
import 'package:frontend/widgets/loading_widget.dart';
import 'package:frontend/widgets/text_field_widget.dart';
import 'package:frontend/widgets/text_widget.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldWidget(
              controller: email,
              hintText: 'Email',
            ),
            const SizedBox(height: 30),
            TextFieldWidget(
              controller: password,
              hintText: 'Password',
            ),
            const SizedBox(height: 30),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  showSnackbar(
                    context,
                    state.reason,
                  );
                } else if (state is AuthSuccess) {
                  if (state.isFromSignup) {
                    context.goNamed(RouteName.login);
                  } else {
                    context.goNamed(RouteName.chat);
                  }
                }
              },
              builder: (context, state) {
                return ButtonWidget(
                  child: state is AuthLoading
                      ? const LoadingWidget()
                      : const TextWidget(
                          text: 'Login',
                          color: Colors.white,
                        ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          LoginUser(
                            email: email.text,
                            password: password.text,
                          ),
                        );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                context.pushNamed(RouteName.signup);
              },
              child: const TextWidget(
                text: 'Create an Account',
                type: TextType.small,
                color: Colors.brown,
              ),
            )
          ],
        ),
      ),
    );
  }
}
