import 'package:practice/database.dart';

class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.date,
    required this.time,
    required this.points,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory ActivityModel.fromActivityPoint(ActivityPoint activityPoint) {
    return ActivityModel(
      id: activityPoint.id,
      date: activityPoint.date,
      time: activityPoint.time,
      points: activityPoint.points,
      title: activityPoint.title,
      description: activityPoint.description,
      createdAt: activityPoint.createdAt,
      updatedAt: activityPoint.updatedAt,
      deletedAt: activityPoint.deletedAt,
    );
  }
  final int id;
  final DateTime date;
  final DateTime time;
  final int points;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
}
