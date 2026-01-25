import 'package:flutter/material.dart';
import 'package:practice/database.dart';

class DeleteActivityPointDialog extends StatelessWidget {
  const DeleteActivityPointDialog({
    super.key,
    required this.activityPoint,
    required this.database,
  });

  final ActivityPoint activityPoint;
  final AppDatabase database;

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
            activityPoint.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('ポイント: ${activityPoint.points}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            // 削除処理を実行
            await database.deleteActivityPoint(activityPoint);

            // ダイアログを閉じる
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

  // Future<void> _deleteActivityPoint() async {
  //   await database.deleteActivityPoint(activityPoint);
  // }
}
