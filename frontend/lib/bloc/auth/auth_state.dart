part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String reason;

  AuthError({required this.reason});
}

final class AuthSuccess extends AuthState {
  final bool isFromSignup;

  AuthSuccess({this.isFromSignup = false});
}

final class GetUserLoading extends AuthState {}

final class GetUserError extends AuthState {
  final String reason;

  GetUserError({required this.reason});
}

final class GetUserSuccess extends AuthState {
  final List<UserModel> users;

  GetUserSuccess({required this.users});
}
