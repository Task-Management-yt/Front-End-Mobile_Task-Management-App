import 'package:dio/dio.dart';
import '../constant/api.dart';

final taskEndpoint = ApiEndpoints.tasks;

class TaskService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: taskEndpoint, // Sesuaikan dengan URL backend-mu
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>> addTask({
    required String title,
    required DateTime deadline,
    String? description,
    String? status,
  }) async {
    try {
      final response = await _dio.post(
        '/create',
        data: {
          "title": title,
          "description": description,
          "deadline": deadline.toIso8601String(),
          "status": status,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Terjadi kesalahan');
    }
  }

  Future<List<Map<String, dynamic>>> getUserTasks(String token) async {
    try {
      final response = await _dio.get(
        '/get',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Format data tidak valid');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['detail'] ?? 'Gagal mengambil data tugas',
      );
    }
  }
}
