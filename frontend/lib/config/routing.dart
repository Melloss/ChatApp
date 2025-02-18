import 'package:frontend/data/model/user_model.dart';
import 'package:frontend/screens/chat_detail_screen.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:go_router/go_router.dart';

class RouteName {
  static const login = 'login_screen';
  static const signup = 'signup_screen';
  static const chat = 'chat_screen';
  static const chatDetail = 'chat_detail_screen';
}

final goRouter = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
    name: RouteName.login,
  ),
  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupScreen(),
    name: RouteName.signup,
  ),
  GoRoute(
    path: '/chat',
    builder: (context, state) => const ChatScreen(),
    name: RouteName.chat,
  ),
  GoRoute(
    path: '/chatDetail',
    builder: (context, state) => ChatDetailScreen(
      toUser: state.extra as UserModel,
    ),
    name: RouteName.chatDetail,
  )
]);
