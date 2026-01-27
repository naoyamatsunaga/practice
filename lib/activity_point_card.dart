import 'package:flutter/material.dart';
import 'package:practice/database.dart';
import 'package:practice/dialogs/delete_activity_point_dialog.dart';
import 'package:practice/dialogs/edit_activity_point_dialog.dart';
import 'package:practice/models/activity.dart';

class ActivityPointCard extends StatelessWidget {
  const ActivityPointCard(
      {super.key, required this.activityModel, required this.database});

  final ActivityModel activityModel;
  final AppDatabase database;

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
                    builder: (BuildContext context) => EditActivityPointDialog(
                      activityModel: activityModel,
                      database: database,
                    ),
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        DeleteActivityPointDialog(
                      activityModel: activityModel,
                      database: database,
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
