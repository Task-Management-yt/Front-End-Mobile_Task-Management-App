class Task {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? deadline;
  final String? status;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    this.title,
    this.description,
    this.deadline,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
