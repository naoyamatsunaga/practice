import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/view_models/home_view_model.dart';
import 'package:practice/view_models/preset_view_model.dart';
import 'package:practice/views/dialogs/add_task_from_preset.dart';
import 'package:practice/views/dialogs/show_add_task_dialog.dart';
import 'package:practice/views/widgets/task_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final totalPoints = ref.watch(homeTotalPointsProvider);
    final activityPointsAsync = ref.watch(homeActivityListStreamProvider);
    final hasHomeTasks = activityPointsAsync.valueOrNull?.isNotEmpty ?? false;
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
      body: activityPointsAsync.when(
        data: (activityModels) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //合計ポイント
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        totalPoints.toString(),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              //タスク一覧
              Expanded(
                child: activityModels.isEmpty
                    ? const Center(child: Text('タスクがありません'))
                    : ListView.builder(
                        itemCount: activityModels.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            activityModel: activityModels[index],
                            onEdit: homeViewModel.updateActivity,
                            onDelete: homeViewModel.deleteActivity,
                            onToggleComplete:
                                homeViewModel.setActivityCompleted,
                          );
                        },
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
          hasTasks: activityPointsAsync.valueOrNull?.isNotEmpty ?? false,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteAllTasksConfirmation({
    required BuildContext context,
    required WidgetRef ref,
    required HomeViewModel homeViewModel,
  }) async {
    final tasks = ref.read(homeActivityListStreamProvider).valueOrNull ?? [];
    if (tasks.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('削除できるタスクがありません')),
        );
      }
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
        ref.read(homeActivityListStreamProvider).valueOrNull ?? [];
    if (tasksToDelete.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('削除できるタスクがありません')),
        );
      }
      return;
    }

    await homeViewModel.deleteAllHomeActivities(tasksToDelete);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タスクを全て削除しました')),
      );
    }
  }

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
                        await homeViewModel.addActivity(
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
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'ホームへの追加は完了しましたが、プリセットへの追加に失敗しました',
                                ),
                              ),
                            );
                          }
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

  Future<void> _showPresetSelectionDialog({
    required BuildContext context,
    required HomeViewModel homeViewModel,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AddTaskFromPresetDialog(
        onAddSelected: (selectedPresets) async {
          await homeViewModel.addActivitiesFromPresets(selectedPresets);
          if (context.mounted && selectedPresets.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${selectedPresets.length}件のタスクを追加しました')),
            );
          }
        },
      ),
    );
  }

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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('1タップ追加ONのプリセットがありません')),
          );
        }
        return;
      }

      await homeViewModel.addActivitiesFromPresets(quickAddPresets);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${quickAddPresets.length}件のタスクを追加しました')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('プリセットの読み込みに失敗しました')),
        );
      }
    }
  }
}
