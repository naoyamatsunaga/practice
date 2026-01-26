import 'package:flutter/material.dart';
import 'package:practice/database.dart';
import 'package:practice/dialogs/delete_activity_point_dialog.dart';
import 'package:practice/dialogs/edit_activity_point_dialog.dart';

class ActivityPointCard extends StatelessWidget {
  const ActivityPointCard(
      {super.key, required this.activityPoint, required this.database});

  final ActivityPoint activityPoint;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Row(
          children: [
            Text(
              activityPoint.points.toString(),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityPoint.title,
                  style: const TextStyle(fontSize: 25),
                ),
                //Text(description),
              ],
            ),
            const Spacer(),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {
                if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => EditActivityPointDialog(
                      activityPoint: activityPoint,
                      database: database,
                    ),
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        DeleteActivityPointDialog(
                      activityPoint: activityPoint,
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
                    child: Row(children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('削除', style: TextStyle(color: Colors.red)),
                    ]))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
