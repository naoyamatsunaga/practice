import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class ActivityPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get time => dateTime()();
  IntColumn get points => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime()();
}

@DriftDatabase(tables: [ActivityPoints])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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

  // Future<void> updateActivityPoint(ActivityPoint activityPoint) =>
  //     update(activityPoints).replace(activityPoint);

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
