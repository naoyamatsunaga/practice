class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.points,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int points;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
}
