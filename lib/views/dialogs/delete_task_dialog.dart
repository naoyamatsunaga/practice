import 'package:flutter/material.dart';
import 'package:practice/models/task.dart';

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({
    super.key,
    required this.taskModel,
    required this.onConfirm,
  });

  final TaskModel taskModel;
  final Future<void> Function(TaskModel taskModel) onConfirm;

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
            taskModel.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('ポイント: ${taskModel.points}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm(taskModel);

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
