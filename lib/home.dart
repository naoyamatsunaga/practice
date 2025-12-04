import 'package:flutter/material.dart';
import 'package:practice/database.dart';
import 'package:practice/dialogs/show_add_activity_point_dialog.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.database});

  final AppDatabase database;

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
                    AddActivityPointDialog(database: database),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<ActivityPoint>>(
        stream: database.watchActivityPoints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].title),
                subtitle: Text(snapshot.data![index].description),
                trailing: Text(snapshot.data![index].points.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
