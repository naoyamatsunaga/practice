import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class ActivityPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get points => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [ActivityPoints])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  /// 旧スキーマでは `date` など Drift 定義にない NOT NULL 列が残ることがあり、
  /// INSERT が失敗する。v2 でテーブルを作り直して現行定義と一致させる。
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.deleteTable('activity_points');
            await m.createTable(activityPoints);
          }
        },
      );

  Stream<List<ActivityPoint>> watchActivityPoints() {
    return (select(activityPoints)).watch();
  }

  Future<List<ActivityPoint>> getAllActivityPoints() =>
      select(activityPoints).get();

  Future<void> insertActivityPoint(ActivityPoint activityPoint) =>
      into(activityPoints).insert(activityPoint);

  Future<int> getMaxId() async {
    final query = selectOnly(activityPoints)
      ..addColumns([activityPoints.id.max()]);
    final result = await query.getSingleOrNull();
    return result?.read(activityPoints.id.max()) ?? 0;
  }

  Future<void> updateActivityPoint(ActivityPoint activityPoint) =>
      update(activityPoints).replace(activityPoint);

  Future<void> deleteActivityPoint(ActivityPoint activityPoint) =>
      delete(activityPoints).delete(activityPoint);
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
