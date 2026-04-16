import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/database.dart';
import 'package:practice/models/task.dart';

class TaskRepository {
  TaskRepository(this._database);

  final AppDatabase _database;

  Stream<List<TaskModel>> watchTasks() {
    return _database.watchTasks().map(
          (tasks) => tasks.map(_toModel).toList(),
        );
  }

  Future<List<TaskModel>> getAllTasks() async {
    final tasks = await _database.getAllTasks();
    return tasks.map(_toModel).toList();
  }

  Future<void> insertTask(TaskModel task) {
    return _database.insertTask(_toTask(task));
  }

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

  Future<void> updateTask(TaskModel task) {
    return _database.updateTask(_toTask(task));
  }

  Future<void> deleteTask(TaskModel task) {
    return _database.deleteTask(_toTask(task));
  }

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

/// Home 画面等用の [TaskRepository]（DI）
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TaskRepository(database);
});
