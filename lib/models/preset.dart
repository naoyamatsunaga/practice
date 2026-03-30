class PresetModel {
  const PresetModel({
    required this.id,
    required this.title,
    required this.points,
    required this.oneTapEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final int points;
  final bool oneTapEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
}
