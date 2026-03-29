import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/database.dart';
import 'package:practice/models/activity.dart';

class ActivityRepository {
  ActivityRepository(this._database);

  final AppDatabase _database;

  Stream<List<ActivityModel>> watchActivityPoints() {
    return _database.watchActivityPoints().map(
          (activityPoints) => activityPoints.map(_toModel).toList(),
        );
  }

  Future<List<ActivityModel>> getAllActivityPoints() async {
    final points = await _database.getAllActivityPoints();
    return points.map(_toModel).toList();
  }

  Future<int> getNextId() async {
    return (await _database.getMaxId()) + 1;
  }

  Future<void> insertActivityPoint(ActivityModel activity) {
    return _database.insertActivityPoint(_toPoint(activity));
  }

  Future<void> updateActivityPoint(ActivityModel activity) {
    return _database.updateActivityPoint(_toPoint(activity));
  }

  Future<void> deleteActivityPoint(ActivityModel activity) {
    return _database.deleteActivityPoint(_toPoint(activity));
  }

  ActivityModel _toModel(ActivityPoint activityPoint) {
    return ActivityModel(
      id: activityPoint.id,
      points: activityPoint.points,
      title: activityPoint.title,
      description: activityPoint.description,
      createdAt: activityPoint.createdAt,
      updatedAt: activityPoint.updatedAt,
    );
  }

  ActivityPoint _toPoint(ActivityModel activity) {
    return ActivityPoint(
      id: activity.id,
      points: activity.points,
      title: activity.title,
      description: activity.description,
      createdAt: activity.createdAt,
      updatedAt: activity.updatedAt,
    );
  }
}

/// Home 画面等用の [ActivityRepository]（DI）
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ActivityRepository(database);
});
