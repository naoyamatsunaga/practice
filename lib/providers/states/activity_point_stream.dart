import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/activity.dart';
import 'package:practice/providers/states/database_provider.dart';

/// ActivityPointsのリストを監視するStreamProvider
/// データベースの変更をリアルタイムで監視し、リストを提供します
final activityPointsStreamProvider = StreamProvider<List<ActivityModel>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchActivityPoints().map(
        (activityPoints) => activityPoints
            .map((point) => ActivityModel.fromActivityPoint(point))
            .toList(),
      );
});
