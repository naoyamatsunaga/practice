import 'package:flutter/material.dart';
import 'package:practice/database.dart';

class DeleteActivityPointDialog extends StatelessWidget {
  const DeleteActivityPointDialog({
    super.key,
    //required this.database,
  });

  //final AppDatabase database;
  //final ActivityPoint activityPoint

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ポイント削除'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('この項目を削除しますか？'),
          SizedBox(height: 12),
          Text(
            // activityPoint.title,
            'test_title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Text('ポイント: ${activityPoint.points}'),
          Text('ポイント: 100'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            // await database
            //     .delete(database.activityPoints)
            //     .delete(activityPoint);
            // if (context.mounted) {
            //   Navigator.of(context).pop();
            // }
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
