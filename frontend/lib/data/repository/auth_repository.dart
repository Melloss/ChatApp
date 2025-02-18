import 'package:dio/dio.dart';
import 'package:frontend/core/constants/url_constant.dart';
import 'package:frontend/core/settings/settings.dart';
import 'package:frontend/core/utils/error_handler.dart';
import 'package:frontend/data/model/user_model.dart';

class AuthRepository {
  final Dio dio;
  AuthRepository({required this.dio});

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/auth/login',
        data: {
          "email": email,
          "password": password,
        },
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final token = res.data['token'];
        await Settings.saveToken(token);
      }
    } catch (e) {
      handleApiError(e);
    }
  }

  Future<List<UserModel>?> getUsers() async {
    try {
      final res = await dio.get(
        '$baseUrl/auth/users',
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final users =
            (res.data as List).map((u) => UserModel.fromMap(u)).toList();
        return users;
      }
      return null;
    } catch (e) {
      handleApiError(e);
      return null;
    }
  }

  Future<UserModel?> createAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/auth/signup',
        data: {
          "first_name": firstName.trim(),
          "last_name": lastName.trim(),
          "email": email.trim(),
          "password": password,
        },
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      handleApiError(e);
      return null;
    }
  }
}
