import 'package:dio/dio.dart';
import 'package:task_management_app/models/task.dart';
import '../constant/api.dart';

final taskEndpoint = ApiEndpoints.tasks;

class TaskService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: taskEndpoint, // Sesuaikan dengan URL backend-mu
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Task> createTask(String token, Task task) async {
    try {
      final response = await _dio.post(
        '/create',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: task.toJson(),
      );

      return Task.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Gagal menambahkan tugas');
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

  /// 🔹 Update tugas ke backend
  Future<Task> updateTask(String token, Task task) async {
    try {
      final response = await _dio.put(
        '/update/${task.id}',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: task.toJson(),
      );

      return Task.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Gagal memperbarui tugas');
    }
  }

  Future<void> deleteTask(String token, Task task) async {
    try {
      await _dio.delete(
        '/delete/${task.id}',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Gagal memperbarui tugas');
    }
  }
}
