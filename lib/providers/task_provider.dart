import 'package:flutter/material.dart';
import 'package:task_management_app/providers/auth_provider.dart';
import 'package:task_management_app/services/task_service.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  final AuthProvider authProvider;
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TaskProvider(this.authProvider) {
    fetchUserTasks();
  }

  Future<void> fetchUserTasks() async {
    final token = authProvider.token;
    if (token == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Map<String, dynamic>> fetchedTasksData = await _taskService
          .getUserTasks(token);

      _tasks =
          fetchedTasksData.map((taskData) => Task.fromJson(taskData)).toList();
    } catch (e) {
      _errorMessage = "Gagal mengambil tugas. Coba lagi nanti.";
      debugPrint("Error fetching tasks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Tambah tugas baru ke daftar lokal & backend
  Future<void> addTask(Task newTask) async {
    final token = authProvider.token;
    if (token == null) return;

    try {
      Task savedTask = await _taskService.createTask(token, newTask);
      _tasks.add(savedTask);
      notifyListeners();
    } catch (e) {
      debugPrint("Error menambah tugas: $e");
    }
  }

  /// 🔹 Update tugas berdasarkan ID
  Future<void> updateTask(Task updatedTask) async {
    final token = authProvider.token;
    if (token == null) return;

    int index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index == -1) return;

    try {
      Task savedTask = await _taskService.updateTask(token, updatedTask);
      _tasks[index] = savedTask;
      notifyListeners();
    } catch (e) {
      debugPrint("Error memperbarui tugas: $e");
    }
  }

  Future<void> deleteTask(Task task) async {
    final token = authProvider.token;
    if (token == null) return;

    try {
      await _taskService.deleteTask(token, task);
      _tasks.removeWhere((t) => t.id == task.id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error menghapus tugas: $e");
    }
  }
}
