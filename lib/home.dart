import 'package:flutter/material.dart';
import 'package:practice/activity_point_card.dart';
import 'package:practice/database.dart';
import 'package:practice/dialogs/show_add_activity_point_dialog.dart';
import 'package:practice/models/activity.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Points'),
      ),
      body: StreamBuilder<List<ActivityPoint>>(
        stream: database.watchActivityPoints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final activityModels = snapshot.data!
              .map((point) => ActivityModel.fromActivityPoint(point))
              .toList();
          return ListView.builder(
            itemCount: activityModels.length,
            itemBuilder: (context, index) {
              return ActivityPointCard(
                activityModel: activityModels[index],
                database: database,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                AddActivityPointDialog(database: database),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
