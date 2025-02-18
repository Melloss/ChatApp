import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/chat/chat_bloc.dart';
import 'package:frontend/config/routing.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/service/dio_client.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'bloc/auth/auth_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final dio = DioClient().dio;
  late AuthRepository authRepository;

  @override
  void initState() {
    authRepository = AuthRepository(dio: dio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: authRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
        //
      ],
      child: ResponsiveApp(builder: (context) {
        return MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
