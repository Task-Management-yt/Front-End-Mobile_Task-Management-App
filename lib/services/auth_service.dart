import 'package:dio/dio.dart';
import '../api.dart';

final authEndpoint = ApiEndpoints.auth;

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: authEndpoint, // Sesuaikan dengan URL backend-mu
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        '/signup',
        data: {
          "email": email,
          "password": password,
          "username": username,
          "name": name,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Terjadi kesalahan');
    }
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/signin',
        data: {"email": email, "password": password},
      );

      if (response.data.containsKey('access_token')) {
        return response.data['access_token']; // Pastikan key benar
      } else {
        throw Exception("Token tidak ditemukan dalam response");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Login gagal');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser(String token) async {
    try {
      final response = await _dio.get(
        '/me',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['detail'] ?? 'Gagal mengambil data user',
      );
    }
  }

  Future<void> logout() async {
    try {
      await _dio.get('/logout');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Logout gagal');
    }
  }
}
