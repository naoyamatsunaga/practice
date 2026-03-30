import 'package:flutter/material.dart';
import 'package:practice/models/preset.dart';

class DeletePresetDialog extends StatelessWidget {
  const DeletePresetDialog({
    super.key,
    required this.preset,
    required this.onConfirm,
  });

  final PresetModel preset;
  final Future<void> Function(PresetModel preset) onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('プリセット削除'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('このプリセットを削除しますか？'),
          const SizedBox(height: 12),
          Text(
            preset.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('ポイント: ${preset.points}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm(preset);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('削除'),
        ),
      ],
    );
  }
}
