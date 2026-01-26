import 'package:practice/database.dart';

class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.points,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityModel.fromActivityPoint(ActivityPoint activityPoint) {
    return ActivityModel(
      id: activityPoint.id,
      points: activityPoint.points,
      title: activityPoint.title,
      description: activityPoint.description,
      createdAt: activityPoint.createdAt,
      updatedAt: activityPoint.updatedAt,
    );
  }

  ActivityPoint toActivityPoint() {
    return ActivityPoint(
      id: id,
      points: points,
      title: title,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  final int id;
  final int points;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
}
