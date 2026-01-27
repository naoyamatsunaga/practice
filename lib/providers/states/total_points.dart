import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/providers/states/activity_point_stream.dart';

/// ポイントの合計値を計算するProvider
/// activityPointsStreamProviderから取得したリストの合計を計算します
final totalPointsProvider = Provider<int>((ref) {
  final activityPointsAsync = ref.watch(activityPointsStreamProvider);
  
  // データが読み込み中の場合は0を返す
  if (activityPointsAsync.isLoading) {
    return 0;
  }
  
  // エラーが発生した場合は0を返す
  if (activityPointsAsync.hasError) {
    return 0;
  }
  
  // データが取得できた場合、すべてのポイントを合計
  final activityPoints = activityPointsAsync.value ?? [];
  return activityPoints.fold<int>(
    0,
    (sum, activity) => sum + activity.points,
  );
});
