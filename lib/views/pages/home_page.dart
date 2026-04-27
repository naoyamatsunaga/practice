import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/task.dart';
import 'package:practice/view_models/home_view_model.dart';
import 'package:practice/view_models/preset_view_model.dart';
import 'package:practice/views/dialogs/add_task_from_preset.dart';
import 'package:practice/views/dialogs/show_add_task_dialog.dart';
import 'package:practice/views/widgets/task_card.dart';

/// ホーム画面。現在期間のタスク一覧・合計ポイントの表示と、追加・全削除などの操作をまとめる。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  /// AppBar（全削除メニュー）・本文（合計ポイント＋リスト）・FAB（追加オプション）で画面を構成する。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final totalPoints = ref.watch(homeTotalPointsProvider);
    final taskPointsAsync = ref.watch(homeTaskListStreamProvider);
    final hasHomeTasks = taskPointsAsync.valueOrNull?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) async {
              if (value == 'delete_all') {
                await _showDeleteAllTasksConfirmation(
                  context: context,
                  ref: ref,
                  homeViewModel: homeViewModel,
                );
              }
            },
            itemBuilder: (BuildContext menuContext) => [
              PopupMenuItem<String>(
                value: 'delete_all',
                enabled: hasHomeTasks,
                child: const Text('全削除'),
              ),
            ],
          ),
        ],
      ),
      body: taskPointsAsync.when(
        data: (taskModels) {
          return Column(
            children: [
              _TotalPointsCard(totalPoints: totalPoints),
              const SizedBox(height: 16.0),
              Expanded(
                child: _TaskListSection(
                  taskModels: taskModels,
                  homeViewModel: homeViewModel,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskSettingOptions(
          context: context,
          ref: ref,
          homeViewModel: homeViewModel,
          hasTasks: taskPointsAsync.valueOrNull?.isNotEmpty ?? false,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 表示中のタスクをまとめて削除するか確認し、承認時は [HomeViewModel] 経由で削除する。
  Future<void> _showDeleteAllTasksConfirmation({
    required BuildContext context,
    required WidgetRef ref,
    required HomeViewModel homeViewModel,
  }) async {
    final tasks = ref.read(homeTaskListStreamProvider).valueOrNull ?? [];
    if (tasks.isEmpty) {
      _showSnackBar(context, '削除できるタスクがありません');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('タスクを全削除'),
          content: Text(
            '表示中のタスクを${tasks.length}件すべて削除しますか？\nこの操作は取り消せません。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              child: const Text('削除'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final tasksToDelete =
        ref.read(homeTaskListStreamProvider).valueOrNull ?? [];
    if (tasksToDelete.isEmpty) {
      _showSnackBar(context, '削除できるタスクがありません');
      return;
    }

    await homeViewModel.deleteAllHomeTasks(tasksToDelete);
    if (!context.mounted) return;
    _showSnackBar(context, 'タスクを全て削除しました');
  }

  /// FAB 押下時。新規作成・プリセットからの追加など、タスク追加の手段をボトムシートで選ばせる。
  Future<void> _showTaskSettingOptions({
    required BuildContext context,
    required WidgetRef ref,
    required HomeViewModel homeViewModel,
    required bool hasTasks,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.add_task),
                title: const Text('新規作成で追加'),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AddTaskDialog(
                      onSubmit: ({
                        required String title,
                        required int points,
                        required bool addToPreset,
                        required bool isQuickAdd,
                      }) async {
                        await homeViewModel.addTask(
                          title: title,
                          points: points,
                        );
                        if (!addToPreset) {
                          return;
                        }
                        try {
                          await ref
                              .read(presetViewModelProvider.notifier)
                              .addPreset(
                                title: title,
                                points: points,
                                isQuickAdd: isQuickAdd,
                              );
                        } catch (_) {
                          if (!context.mounted) return;
                          _showSnackBar(
                            context,
                            'ホームへの追加は完了しましたが、プリセットへの追加に失敗しました',
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_list),
                title: const Text('プリセット一覧から追加'),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  _showPresetSelectionDialog(
                    context: context,
                    homeViewModel: homeViewModel,
                  );
                },
              ),
              if (!hasTasks)
                ListTile(
                  leading: const Icon(Icons.touch_app),
                  title: const Text('1タップ追加ONのプリセットを全て追加'),
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();
                    await _addQuickAddPresets(
                      context: context,
                      ref: ref,
                      homeViewModel: homeViewModel,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// プリセット一覧から複数選択し、選択分をホームにタスクとして追加するダイアログを出す。
  Future<void> _showPresetSelectionDialog({
    required BuildContext context,
    required HomeViewModel homeViewModel,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AddTaskFromPresetDialog(
        onAddSelected: (selectedPresets) async {
          await homeViewModel.addTasksFromPresets(selectedPresets);
          if (!context.mounted) return;
          if (selectedPresets.isNotEmpty) {
            _showSnackBar(context, '${selectedPresets.length}件のタスクを追加しました');
          }
        },
      ),
    );
  }

  /// `isQuickAdd` が有効なプリセットだけをまとめてホームに追加する（メニューから呼び出し）。
  Future<void> _addQuickAddPresets({
    required BuildContext context,
    required WidgetRef ref,
    required HomeViewModel homeViewModel,
  }) async {
    try {
      final presets = await ref.read(presetListStreamProvider.future);
      final quickAddPresets =
          presets.where((preset) => preset.isQuickAdd).toList();

      if (quickAddPresets.isEmpty) {
        if (!context.mounted) return;
        _showSnackBar(context, '1タップ追加ONのプリセットがありません');
        return;
      }

      await homeViewModel.addTasksFromPresets(quickAddPresets);
      if (!context.mounted) return;
      _showSnackBar(context, '${quickAddPresets.length}件のタスクを追加しました');
    } catch (_) {
      if (!context.mounted) return;
      _showSnackBar(context, 'プリセットの読み込みに失敗しました');
    }
  }

  /// 画面下部に短いメッセージを表示する（[context] が有効なときのみ）。
  void _showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// ホーム上部の「合計ポイント」表示用カード（完了タスクのポイント合計）。
class _TotalPointsCard extends StatelessWidget {
  const _TotalPointsCard({required this.totalPoints});

  final int totalPoints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '合計ポイント',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              totalPoints.toString(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 現在期間のタスクを [TaskCard] のリストで並べる。空のときはプレースホルダ文言を表示。
class _TaskListSection extends StatelessWidget {
  const _TaskListSection({
    required this.taskModels,
    required this.homeViewModel,
  });

  final List<TaskModel> taskModels;
  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    if (taskModels.isEmpty) {
      return const Center(child: Text('タスクがありません'));
    }

    return ListView.builder(
      itemCount: taskModels.length,
      itemBuilder: (context, index) {
        return TaskCard(
          taskModel: taskModels[index],
          onEdit: homeViewModel.updateTask,
          onDelete: homeViewModel.deleteTask,
          onToggleComplete: homeViewModel.setTaskCompleted,
        );
      },
    );
  }
}
