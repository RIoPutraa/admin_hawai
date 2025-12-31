import 'package:dio/dio.dart';

class AdminAuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api', // ganti sesuai environment
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/admin/login',
        data: {'username': username, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Login gagal',
      };
    }
  }
}
