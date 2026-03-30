import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/view_models/preset_view_model.dart';
import 'package:practice/views/dialogs/add_preset_dialog.dart';
import 'package:practice/views/widgets/preset_card.dart';

class PresetPage extends ConsumerWidget {
  const PresetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(presetViewModelProvider.notifier);
    final presetAsync = ref.watch(presetListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プリセット'),
      ),
      body: presetAsync.when(
        data: (presets) {
          if (presets.isEmpty) {
            return const Center(
              child: Text('プリセットはまだありません'),
            );
          }

          return ListView.builder(
            itemCount: presets.length,
            itemBuilder: (context, index) {
              return PresetCard(
                preset: presets[index],
                onEdit: viewModel.updatePreset,
                onDelete: viewModel.deletePreset,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddPresetDialog(
              onSubmit: viewModel.addPreset,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
