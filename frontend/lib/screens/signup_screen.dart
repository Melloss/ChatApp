import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth/auth_bloc.dart';
import 'package:frontend/widgets/loading_widget.dart';

import '../widgets/button_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/text_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
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
              controller: firstName,
              hintText: 'First Name',
            ),
            const SizedBox(height: 30),
            TextFieldWidget(
              controller: lastName,
              hintText: 'Last Name',
            ),
            const SizedBox(height: 30),
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
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ButtonWidget(
                    child: state is AuthLoading
                        ? const LoadingWidget()
                        : const TextWidget(
                            text: 'Signup',
                            color: Colors.white,
                          ),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            CreateAccount(
                              firstName: firstName.text,
                              lastName: lastName.text,
                              email: email.text,
                              password: password.text,
                            ),
                          );
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
