class TaskModel {
  const TaskModel({
    required this.id,
    required this.points,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int points;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
}
