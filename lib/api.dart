class ApiEndpoints {
  static const String _baseUrl = 'https://api.tribber.live/api/v1';

  static String get tasks => '$_baseUrl/task';
  static String get auth => '$_baseUrl/auth';

  static String taskById(String id) => '$_baseUrl/tasks/$id';
}
