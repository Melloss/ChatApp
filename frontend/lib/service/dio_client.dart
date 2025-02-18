import 'package:dio/dio.dart';
import 'package:frontend/core/settings/settings.dart';

class DioClient {
  final _dio = Dio();
  DioClient() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 25),
    );

    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Settings.getToken();
        if (token != null) {
          options.headers.addAll({
            'Authorization': 'Bearer $token',
          });
        }
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;
}
