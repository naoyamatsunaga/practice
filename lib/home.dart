import 'package:flutter/material.dart';
import 'package:practice/database.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.database});

  final AppDatabase database;

  final TextEditingController addPointsController = TextEditingController();
  final TextEditingController addTitleController = TextEditingController();
  final TextEditingController addDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Points'),
        actions: [
          IconButton(
            onPressed: () {
              _showAddActivityPointDialog(context);
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

  Future<void> _showAddActivityPointDialog(BuildContext context) async {
    final maxId = (await database.getMaxId()) + 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ポイント追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'タイトル'),
                controller: addTitleController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '説明'),
                controller: addDescriptionController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'ポイント'),
                controller: addPointsController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                database.insertActivityPoint(
                  ActivityPoint(
                    id: maxId,
                    date: DateTime.now(),
                    time: DateTime.now(),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    deletedAt: DateTime.now(),
                    title: addTitleController.text,
                    description: addDescriptionController.text,
                    points: int.parse(addPointsController.text),
                  ),
                );
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }
}
