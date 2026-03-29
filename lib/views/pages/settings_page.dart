import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice/view_models/settings_view_model.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingsViewModelProvider);

    return Center(
      child: ElevatedButton.icon(
        onPressed: () => context.push(viewModel.colorPaletteRoute),
        icon: const Icon(Icons.palette),
        label: const Text('カラーパレットへ'),
      ),
    );
  }
}
