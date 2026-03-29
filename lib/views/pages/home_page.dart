import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/view_models/home_view_model.dart';
import 'package:practice/views/dialogs/show_add_activity_point_dialog.dart';
import 'package:practice/views/widgets/activity_point_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    final totalPoints = ref.watch(homeTotalPointsProvider);
    final activityPointsAsync = ref.watch(homeActivityListStreamProvider);
    final nextResetTime = ref.watch(nextResetTimeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Points'),
      ),
      body: activityPointsAsync.when(
        data: (activityModels) {
          return Column(
            children: [
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
                    const SizedBox(height: 12.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '次回リセット: ${nextResetTime.month}/${nextResetTime.day} ${nextResetTime.hour.toString().padLeft(2, '0')}:${nextResetTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                                  .withAlpha(200),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: activityModels.length,
                  itemBuilder: (context, index) {
                    return ActivityPointCard(
                      activityModel: activityModels[index],
                      onEdit: homeViewModel.updateActivity,
                      onDelete: homeViewModel.deleteActivity,
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
                AddActivityPointDialog(onSubmit: homeViewModel.addActivity),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
