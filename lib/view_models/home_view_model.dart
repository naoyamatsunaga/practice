import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/activity.dart';
import 'package:practice/providers/states/database_provider.dart';
import 'package:practice/repositories/activity_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home 画面用の [ActivityRepository]（DI）
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ActivityRepository(database);
});

/// アクティビティ一覧（DBの変更をストリームで監視）
final homeActivityListStreamProvider =
    StreamProvider<List<ActivityModel>>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.watchActivityPoints();
});

/// 一覧のポイント合計（読み込み中・エラー時は 0）
final homeTotalPointsProvider = Provider<int>((ref) {
  final async = ref.watch(homeActivityListStreamProvider);
  if (async.isLoading) {
    return 0;
  }
  if (async.hasError) {
    return 0;
  }
  final list = async.value ?? [];
  return list.fold<int>(0, (sum, activity) => sum + activity.points);
});

final homeViewModelProvider = NotifierProvider<HomeViewModel, void>(
  HomeViewModel.new,
);

class HomeViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<void> addActivity({
    required String title,
    required int points,
  }) async {
    final repository = ref.read(activityRepositoryProvider);
    final now = DateTime.now();
    final nextId = await repository.getNextId();

    await repository.insertActivityPoint(
      ActivityModel(
        id: nextId,
        points: points,
        title: title,
        description: '',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> updateActivity({
    required ActivityModel original,
    required String title,
    required int points,
  }) async {
    final repository = ref.read(activityRepositoryProvider);
    await repository.updateActivityPoint(
      ActivityModel(
        id: original.id,
        points: points,
        title: title,
        description: original.description,
        createdAt: original.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> deleteActivity(ActivityModel activity) async {
    final repository = ref.read(activityRepositoryProvider);
    await repository.deleteActivityPoint(activity);
  }
}

Future<void> debugSeedIfFirstLaunch(ActivityRepository repository) async {
  //const key = 'debug_seed_inserted';
  final prefs = await SharedPreferences.getInstance();
  //if (prefs.getBool(key) == true) return;

  final now = DateTime.now();
  final seeds = <ActivityModel>[
    ActivityModel(
      id: 2,
      createdAt: now,
      updatedAt: now,
      title: '読書',
      description: '',
      points: 3,
    ),
    ActivityModel(
      id: 1,
      createdAt: now,
      updatedAt: now,
      title: 'ウォーキング',
      description: '',
      points: 4,
    ),
    ActivityModel(
      id: 3,
      createdAt: now,
      updatedAt: now,
      title: '筋トレ',
      description: '',
      points: 5,
    ),
  ];

  for (final point in seeds) {
    await repository.insertActivityPoint(point);
  }
  //await prefs.setBool(key, true);
}
