import 'package:flutter/material.dart';
import 'package:task_management_app/providers/auth_provider.dart';
import 'package:task_management_app/services/task_service.dart';
import '../constant/task.dart';
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

  void addTask(
    String title,
    String description,
    DateTime deadline,
    String status,
  ) {
    final task = Task(
      title: title,
      description: description,
      deadline: deadline,
      status: TaskStatus.belumSelesai,
    );
    _tasks.add(task);
    notifyListeners();
  }
}
