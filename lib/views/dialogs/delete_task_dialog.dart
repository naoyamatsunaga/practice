import 'package:flutter/material.dart';
import 'package:practice/models/task.dart';

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({
    super.key,
    required this.activityModel,
    required this.onConfirm,
  });

  final TaskModel activityModel;
  final Future<void> Function(TaskModel activityModel) onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ポイント削除'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('この項目を削除しますか？'),
          const SizedBox(height: 12),
          Text(
            activityModel.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('ポイント: ${activityModel.points}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm(activityModel);

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
