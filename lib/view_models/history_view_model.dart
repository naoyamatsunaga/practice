import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/task.dart';
import 'package:practice/models/repositories/task_repository.dart';
import 'package:practice/core/utils/reset_time.dart';
import 'package:practice/view_models/settings_view_model.dart';

/// 全てのタスクを取得する（履歴用）
final allTaskListStreamProvider =
    StreamProvider<List<TaskModel>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasks();
});

class DailyTaskSummary {
  const DailyTaskSummary({
    required this.date,
    required this.totalPoints,
    required this.tasks,
  });

  final DateTime date;
  final int totalPoints;
  final List<TaskModel> tasks;
}

/// 日付ごとに Task ポイントをグループ化し、合計値とともに提供するProvider
final dailyTaskSummaryProvider =
    Provider<List<DailyTaskSummary>>((ref) {
  final taskPointsAsync = ref.watch(allTaskListStreamProvider);
  final resetTime = ref.watch(resetTimeProvider);

  if (!taskPointsAsync.hasValue) {
    return [];
  }

  final tasks = taskPointsAsync.value ?? [];

  // 日付（年・月・日）をキーにしてグループ化するためのMap
  final Map<DateTime, List<TaskModel>> grouped = {};

  for (final task in tasks) {
    // 時間情報を設定時刻に基づいて論理的な「日付」にまとめる
    final date = getLogicalDate(task.createdAt, resetTime);

    if (!grouped.containsKey(date)) {
      grouped[date] = [];
    }
    grouped[date]!.add(task);
  }

  // グループ化されたMapを元に、DailyTaskSummaryのリストを作成
  final summaryList = grouped.entries.map((entry) {
    final date = entry.key;
    final dayTasks = entry.value;

    // その日の合計ポイントを計算
    final total = dayTasks.fold<int>(
      0,
      (sum, task) => sum + task.points,
    );

    // その日の中での新しい順（降順）にタスクを並び替え
    dayTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DailyTaskSummary(
      date: date,
      totalPoints: total,
      tasks: dayTasks,
    );
  }).toList();

  // 日付の降順（新しい日付が一番上）で並び替え
  summaryList.sort((a, b) => b.date.compareTo(a.date));

  return summaryList;
});
