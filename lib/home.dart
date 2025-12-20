import 'package:flutter/material.dart';
import 'package:practice/activity_point_card.dart';
import 'package:practice/database.dart';
import 'package:practice/dialogs/add_activity_point_dialog.dart';
import 'package:practice/model/activity.dart';

enum SortOrder {
  time,
  points,
}

class Home extends StatefulWidget {
  const Home({super.key, required this.database});

  final AppDatabase database;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SortOrder _sortOrder = SortOrder.time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Points'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AddActivityPointDialog(database: widget.database),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<ActivityPoint>>(
        stream: widget.database.watchActivityPoints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('データがありません'));
          }

          final activities = snapshot.data!
              .map((activityPoint) =>
                  ActivityModel.fromActivityPoint(activityPoint))
              .toList();

          // 並び替え処理
          final sortedActivities = List<ActivityModel>.from(activities);
          if (_sortOrder == SortOrder.time) {
            sortedActivities.sort((a, b) => a.time.compareTo(b.time));
          } else if (_sortOrder == SortOrder.points) {
            sortedActivities.sort((a, b) => a.points.compareTo(b.points));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<SortOrder>(
                  value: _sortOrder,
                  isExpanded: false,
                  items: const [
                    DropdownMenuItem(
                      value: SortOrder.time,
                      child: Text('時間順'),
                    ),
                    DropdownMenuItem(
                      value: SortOrder.points,
                      child: Text('ポイント順'),
                    ),
                  ],
                  onChanged: (SortOrder? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sortOrder = newValue;
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedActivities.length,
                  itemBuilder: (context, index) {
                    return ActivityPointCard(
                      points: sortedActivities[index].points,
                      title: sortedActivities[index].title,
                      description: sortedActivities[index].description,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
