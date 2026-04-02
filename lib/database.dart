import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Tasks extends Table {
  @override
  String get tableName => 'Task';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get points => integer()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Presets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get points => integer()();
  BoolColumn get isQuickAdd =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [Tasks, Presets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  /// 旧スキーマでは `date` など Drift 定義にない NOT NULL 列が残ることがあり、
  /// INSERT が失敗する。v2 でテーブルを作り直して現行定義と一致させる。
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 5) {
            await customStatement('DROP TABLE IF EXISTS activity_points');
            await customStatement('DROP TABLE IF EXISTS Task');
            await m.createTable(tasks);
            await customStatement('DROP TABLE IF EXISTS presets');
            await m.createTable(presets);
          }
        },
      );

  Stream<List<Task>> watchTasks() {
    return (select(tasks)).watch();
  }

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Future<void> insertTask(Task task) => into(tasks).insert(task);

  Future<int> getTaskMaxId() async {
    final query = selectOnly(tasks)..addColumns([tasks.id.max()]);
    final result = await query.getSingleOrNull();
    return result?.read(tasks.id.max()) ?? 0;
  }

  Future<void> updateTask(Task task) => update(tasks).replace(task);

  Future<void> deleteTask(Task task) => delete(tasks).delete(task);

  Stream<List<Preset>> watchPresets() {
    return (select(presets)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<int> getPresetMaxId() async {
    final query = selectOnly(presets)..addColumns([presets.id.max()]);
    final result = await query.getSingleOrNull();
    return result?.read(presets.id.max()) ?? 0;
  }

  Future<void> insertPreset(Preset preset) => into(presets).insert(preset);

  Future<void> updatePreset(Preset preset) => update(presets).replace(preset);

  Future<void> deletePreset(Preset preset) => delete(presets).delete(preset);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

/// データベースインスタンスを提供するProvider
/// アプリ全体で同じデータベースインスタンスを使用するために使用します
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProviderはmain.dartで上書きする必要があります');
});
