import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/activity_point_card.dart';
import 'package:practice/database.dart';
import 'package:practice/dialogs/show_add_activity_point_dialog.dart';
import 'package:practice/providers/states/activity_point_stream.dart';
import 'package:practice/providers/states/total_points.dart';

class Home extends ConsumerWidget {
  const Home({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ポイントの合計値を監視
    final totalPoints = ref.watch(totalPointsProvider);

    // ActivityPointsのリストを監視
    final activityPointsAsync = ref.watch(activityPointsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Points'),
      ),
      body: activityPointsAsync.when(
        data: (activityModels) {
          return Column(
            children: [
              // 合計値を表示するカード
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '合計ポイント',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      totalPoints.toString(),
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                  ],
                ),
              ),
              // ActivityPointsのリスト
              Expanded(
                child: ListView.builder(
                  itemCount: activityModels.length,
                  itemBuilder: (context, index) {
                    return ActivityPointCard(
                      activityModel: activityModels[index],
                      database: database,
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
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
