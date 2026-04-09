import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/preset.dart';
import 'package:practice/view_models/preset_view_model.dart';
import 'package:practice/views/widgets/task_card.dart';

class AddTaskFromPresetDialog extends ConsumerStatefulWidget {
  const AddTaskFromPresetDialog({
    super.key,
    required this.onAddSelected,
  });

  final Future<void> Function(List<PresetModel> presets) onAddSelected;

  @override
  ConsumerState<AddTaskFromPresetDialog> createState() =>
      _AddTaskFromPresetDialogState();
}

class _AddTaskFromPresetDialogState
    extends ConsumerState<AddTaskFromPresetDialog> {
  final Set<int> _selectedPresetIds = <int>{};

  @override
  Widget build(BuildContext context) {
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
                final isSelected = _selectedPresetIds.contains(preset.id);
                return TaskCard.selectable(
                  title: preset.title,
                  points: preset.points,
                  isSelected: isSelected,
                  onToggleSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPresetIds.add(preset.id);
                      } else {
                        _selectedPresetIds.remove(preset.id);
                      }
                    });
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
          onPressed: () async {
            final presets = presetAsync.value ?? const <PresetModel>[];
            final selectedPresets = presets
                .where((preset) => _selectedPresetIds.contains(preset.id))
                .toList();
            if (selectedPresets.isEmpty) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('追加するプリセットを選択してください')),
                );
              }
              return;
            }
            await widget.onAddSelected(selectedPresets);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('追加'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}
