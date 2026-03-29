import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/activity.dart';
import 'package:practice/repositories/activity_repository.dart';
import 'package:practice/view_models/settings_view_model.dart';

/// 全てのアクティビティを取得する（履歴用）
final allActivityListStreamProvider =
    StreamProvider<List<ActivityModel>>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.watchActivityPoints();
});

class DailyActivitySummary {
  const DailyActivitySummary({
    required this.date,
    required this.totalPoints,
    required this.activities,
  });

  final DateTime date;
  final int totalPoints;
  final List<ActivityModel> activities;
}

/// 日付ごとに Activity ポイントをグループ化し、合計値とともに提供するProvider
final dailyActivitySummaryProvider =
    Provider<List<DailyActivitySummary>>((ref) {
  final activityPointsAsync = ref.watch(allActivityListStreamProvider);
  final resetTime = ref.watch(resetTimeProvider);

  if (!activityPointsAsync.hasValue) {
    return [];
  }

  final activities = activityPointsAsync.value ?? [];

  // 日付（年・月・日）をキーにしてグループ化するためのMap
  final Map<DateTime, List<ActivityModel>> grouped = {};

  for (final activity in activities) {
    // 時間情報を設定時刻に基づいて論理的な「日付」にまとめる
    final date = getLogicalDate(activity.createdAt, resetTime);

    if (!grouped.containsKey(date)) {
      grouped[date] = [];
    }
    grouped[date]!.add(activity);
  }

  // グループ化されたMapを元に、DailyActivitySummaryのリストを作成
  final summaryList = grouped.entries.map((entry) {
    final date = entry.key;
    final dayActivities = entry.value;

    // その日の合計ポイントを計算
    final total = dayActivities.fold<int>(
      0,
      (sum, act) => sum + act.points,
    );

    // その日の中での新しい順（降順）にアクティビティを並び替え
    dayActivities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DailyActivitySummary(
      date: date,
      totalPoints: total,
      activities: dayActivities,
    );
  }).toList();

  // 日付の降順（新しい日付が一番上）で並び替え
  summaryList.sort((a, b) => b.date.compareTo(a.date));

  return summaryList;
});
