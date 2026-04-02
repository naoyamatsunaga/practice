import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/view_models/history_view_model.dart';
import 'package:practice/views/widgets/history_task_card.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // プロバイダーからグループ化された履歴リストを取得する
    final summaryList = ref.watch(dailyActivitySummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
      ),
      body: summaryList.isEmpty
          ? const Center(child: Text('履歴がありません'))
          : ListView.builder(
              itemCount: summaryList.length,
              itemBuilder: (context, index) {
                final summary = summaryList[index];
                return HistoryTaskCard(summary: summary);
              },
            ),
    );
  }
}
