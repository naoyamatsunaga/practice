import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/data/database.dart';
import 'package:practice/models/task.dart';

/// タスクの永続化を [AppDatabase] に任せつつ、ViewModel には [TaskModel] だけを渡す窓口。
///
/// Drift の行型とアプリ内モデルの変換はこのクラス内に閉じる。
class TaskRepository {
  TaskRepository(this._database);

  final AppDatabase _database;

  /// DB の変更をストリームで購読し、常に [TaskModel] のリストとして返す。
  Stream<List<TaskModel>> watchTasks() {
    return _database.watchTasks().map(
          (tasks) => tasks.map(_toModel).toList(),
        );
  }

  /// 全タスクを一度だけ読み込む（シード確認など単発取得向け）。
  Future<List<TaskModel>> getAllTasks() async {
    final tasks = await _database.getAllTasks();
    return tasks.map(_toModel).toList();
  }

  /// 既存 ID を含むタスクをそのまま挿入する。
  Future<void> insertTask(TaskModel task) {
    return _database.insertTask(_toTask(task));
  }

  /// ID を DB に任せて新規タスクを追加する（ホームからの追加で主に利用）。
  Future<void> insertTaskAutoId({
    required int points,
    required String title,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return _database.insertTaskAutoId(
      points: points,
      title: title,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 既存行の更新（完了切り替え・編集など）。
  Future<void> updateTask(TaskModel task) {
    return _database.updateTask(_toTask(task));
  }

  /// 行の削除。
  Future<void> deleteTask(TaskModel task) {
    return _database.deleteTask(_toTask(task));
  }

  /// Drift の [Task] 行を [TaskModel] に変換する。
  TaskModel _toModel(Task task) {
    return TaskModel(
      id: task.id,
      points: task.points,
      title: task.title,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  /// [TaskModel] を Drift 書き込み用の [Task] に変換する。
  Task _toTask(TaskModel task) {
    return Task(
      id: task.id,
      points: task.points,
      title: task.title,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
}

/// [databaseProvider] から DB を受け取り、[TaskRepository] を組み立てる（Riverpod DI）。
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TaskRepository(database);
});
