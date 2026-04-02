import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/preset.dart';
import 'package:practice/view_models/home_view_model.dart';
import 'package:practice/view_models/preset_view_model.dart';
import 'package:practice/views/dialogs/show_add_task_dialog.dart';
import 'package:practice/views/widgets/task_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    final totalPoints = ref.watch(homeTotalPointsProvider);
    final activityPointsAsync = ref.watch(homeActivityListStreamProvider);
    final nextResetTime = ref.watch(nextResetTimeProvider);
    final hasTasks = activityPointsAsync.valueOrNull?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Points'),
      ),
      body: activityPointsAsync.when(
        data: (activityModels) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(20.0),
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
                    const SizedBox(height: 12.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '次回リセット: ${nextResetTime.month}/${nextResetTime.day} ${nextResetTime.hour.toString().padLeft(2, '0')}:${nextResetTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                                  .withAlpha(200),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: activityModels.isEmpty
                    ? Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _showTaskSettingOptions(
                            context: context,
                            ref: ref,
                            homeViewModel: homeViewModel,
                          ),
                          icon: const Icon(Icons.playlist_add),
                          label: const Text('タスクを設定'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: activityModels.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            activityModel: activityModels[index],
                            onEdit: homeViewModel.updateActivity,
                            onDelete: homeViewModel.deleteActivity,
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
      floatingActionButton: hasTasks
          ? FloatingActionButton(
              onPressed: () => _showTaskSettingOptions(
                context: context,
                ref: ref,
                homeViewModel: homeViewModel,
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _showTaskSettingOptions({
    required BuildContext context,
    required WidgetRef ref,
    required HomeViewModel homeViewModel,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.view_list),
                title: const Text('プリセット一覧から追加'),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  _showPresetSelectionDialog(
                    context: context,
                    ref: ref,
                    homeViewModel: homeViewModel,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_task),
                title: const Text('新規作成で追加'),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AddTaskDialog(
                      onSubmit: homeViewModel.addActivity,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.touch_app),
                title: const Text('1タップ追加ONの項目をすべて追加'),
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
    required WidgetRef ref,
    required HomeViewModel homeViewModel,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _PresetSelectionDialog(
        onSelect: (preset) async {
          await homeViewModel.addActivityFromPreset(preset);
          if (context.mounted) {
            Navigator.of(context).pop();
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

class _PresetSelectionDialog extends ConsumerWidget {
  const _PresetSelectionDialog({
    required this.onSelect,
  });

  final Future<void> Function(PresetModel preset) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetAsync = ref.watch(presetListStreamProvider);

    return AlertDialog(
      title: const Text('プリセット一覧'),
      content: SizedBox(
        width: double.maxFinite,
        child: presetAsync.when(
          data: (presets) {
            if (presets.isEmpty) {
              return const Center(child: Text('プリセットはまだありません'));
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: presets.length,
              itemBuilder: (context, index) {
                final preset = presets[index];
                return ListTile(
                  title: Text(preset.title),
                  subtitle: Text('ポイント: ${preset.points}'),
                  trailing: preset.isQuickAdd
                      ? const Icon(Icons.touch_app, size: 18)
                      : null,
                  onTap: () async {
                    await onSelect(preset);
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('エラーが発生しました: $error'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}
