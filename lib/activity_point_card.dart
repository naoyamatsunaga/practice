import 'package:flutter/material.dart';
import 'package:practice/dialogs/delete_activity_point_dialog.dart';

class ActivityPointCard extends StatelessWidget {
  const ActivityPointCard(
      {super.key,
      required this.points,
      required this.title,
      required this.description});

  final int points;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Row(
          children: [
            Text(
              points.toString(),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 25),
                ),
                //Text(description),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const DeleteActivityPointDialog(
                          //database: database
                          ),
                );
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
