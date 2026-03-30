import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/activity.dart';
import 'package:practice/models/preset.dart';
import 'package:practice/repositories/activity_repository.dart';
import 'package:practice/view_models/settings_view_model.dart';
//import 'package:shared_preferences/shared_preferences.dart';

/// アクティビティ一覧（DBの変更をストリームで監視し、現在の期間のものだけをフィルタ）
final homeActivityListStreamProvider =
    StreamProvider<List<ActivityModel>>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  final resetTime = ref.watch(resetTimeProvider);

  // タイマーを設定して、次回リセット時刻が来たら再取得（UI更新）させる
  final now = DateTime.now();
  final nextReset = getNextResetTime(now, resetTime);
  final durationUntilReset = nextReset.difference(now);

  final timer = Timer(durationUntilReset, () {
    ref.invalidateSelf();
  });

  ref.onDispose(() {
    timer.cancel();
  });

  return repository.watchActivityPoints().map((list) {
    // 現在の期間の開始時刻を取得
    final startOfPeriod = getStartOfCurrentPeriod(DateTime.now(), resetTime);

    // 開始時刻と同等か、それ以降のものだけを抽出
    return list.where((activity) {
      return !activity.createdAt.isBefore(startOfPeriod);
    }).toList();
  });
});

/// 次回のリセット時刻を提供するProvider
final nextResetTimeProvider = Provider<DateTime>((ref) {
  // resetTimeが変更されたら、こちらも再計算される
  final resetTime = ref.watch(resetTimeProvider);
  // 現時点を基準に次回リセット時刻を計算
  return getNextResetTime(DateTime.now(), resetTime);
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

  Future<void> addActivityFromPreset(PresetModel preset) async {
    await addActivity(
      title: preset.title,
      points: preset.points,
    );
  }

  Future<void> addActivitiesFromPresets(List<PresetModel> presets) async {
    for (final preset in presets) {
      await addActivityFromPreset(preset);
    }
  }
}

Future<void> debugSeedIfFirstLaunch(ActivityRepository repository) async {
  //const key = 'debug_seed_inserted';
  //final prefs = await SharedPreferences.getInstance();
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
