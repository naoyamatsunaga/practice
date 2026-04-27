import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/view_models/history_view_model.dart';
import 'package:practice/views/widgets/history_task_card.dart';

/// 過去のタスクを「日付ごとの合計」と一覧で確認する画面。
///
/// [dailyTaskSummaryProvider] が返す一覧を、そのままリスト表示する。
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  /// AppBar と本文（履歴カードのリスト／空状態）のみを組み立てる。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryList = ref.watch(dailyTaskSummaryProvider);

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
