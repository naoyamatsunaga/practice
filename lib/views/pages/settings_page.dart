import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/view_models/settings_view_model.dart';
import 'package:practice/views/dialogs/custom_time_picker_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resetTime = ref.watch(resetTimeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('更新時刻（リセット）'),
            subtitle: Text(
              '${resetTime.hour.toString().padLeft(2, '0')}:${resetTime.minute.toString().padLeft(2, '0')}',
            ),
            onTap: () async {
              final newTime = await showDialog<TimeOfDay>(
                context: context,
                builder: (context) =>
                    CustomTimePickerDialog(initialTime: resetTime),
              );

              if (newTime != null && context.mounted) {
                // 説明ダイアログを出す
                final accept = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('更新時刻の設定'),
                    content: Text(
                        '更新時刻を ${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')} に設定しますか？\n\n'
                        'この時刻を境にホーム画面のポイントはリセットされ、それ以前の記録は履歴へと移動します。'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('設定'),
                      ),
                    ],
                  ),
                );

                if (accept == true) {
                  ref.read(resetTimeProvider.notifier).setResetTime(newTime);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
