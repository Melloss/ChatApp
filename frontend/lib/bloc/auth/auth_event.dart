part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  LoginUser({required this.email, required this.password});
}

class CreateAccount extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  CreateAccount(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});
}

class GetUsers extends AuthEvent {}
