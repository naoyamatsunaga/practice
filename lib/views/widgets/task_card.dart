import 'package:flutter/material.dart';
import 'package:practice/models/task.dart';
import 'package:practice/views/dialogs/delete_task_dialog.dart';
import 'package:practice/views/dialogs/edit_task_dialog.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.activityModel,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskModel activityModel;
  final Future<void> Function({
    required TaskModel original,
    required String title,
    required int points,
  }) onEdit;
  final Future<void> Function(TaskModel activityModel) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Row(
          children: [
            Text(
              activityModel.points.toString(),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 30),
            Text(
              activityModel.title,
              style: const TextStyle(fontSize: 25),
            ),
            const Spacer(),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {
                if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => EditTaskDialog(
                      activityModel: activityModel,
                      onSubmit: onEdit,
                    ),
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        DeleteTaskDialog(
                      activityModel: activityModel,
                      onConfirm: onDelete,
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('編集'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('削除', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
