import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/model/user_model.dart';
import 'package:frontend/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginUser>(_onLoginUser);
    on<CreateAccount>(_onCreateAccount);
    on<GetUsers>(_onGetUsers);
  }
  _onGetUsers(GetUsers event, Emitter emit) async {
    try {
      emit(GetUserLoading());
      final users = await authRepository.getUsers();
      emit(GetUserSuccess(users: users ?? []));
    } catch (e) {
      emit(GetUserError(reason: e.toString()));
    }
  }

  _onLoginUser(LoginUser event, Emitter emit) async {
    try {
      emit(AuthLoading());
      await authRepository.loginUser(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(reason: e.toString()));
    }
  }

  _onCreateAccount(CreateAccount event, Emitter emit) async {
    try {
      emit(AuthLoading());
      await authRepository.createAccount(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      );
      emit(AuthSuccess(
        isFromSignup: true,
      ));
    } catch (e) {
      emit(AuthError(reason: e.toString()));
    }
  }
}
