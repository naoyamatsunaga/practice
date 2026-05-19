import 'package:flutter/material.dart';

/// 現時刻とリセット時刻から、現在の期間の開始時刻を計算する。
DateTime getStartOfCurrentPeriod(DateTime now, TimeOfDay resetTime) {
  final currentDayReset = DateTime(
    now.year,
    now.month,
    now.day,
    resetTime.hour,
    resetTime.minute,
  );

  if (now.isBefore(currentDayReset)) {
    return currentDayReset.subtract(const Duration(days: 1));
  }
  return currentDayReset;
}

/// タスクの作成時刻とリセット時刻から、履歴画面で表示する論理的な「対象日」を計算する。
DateTime getLogicalDate(DateTime taskTime, TimeOfDay resetTime) {
  final startOfPeriod = getStartOfCurrentPeriod(taskTime, resetTime);
  return DateTime(
    startOfPeriod.year,
    startOfPeriod.month,
    startOfPeriod.day,
  );
}

/// 現時刻とリセット時刻から、次回リセットが行われる時刻を計算する。
DateTime getNextResetTime(DateTime now, TimeOfDay resetTime) {
  final start = getStartOfCurrentPeriod(now, resetTime);
  return start.add(const Duration(days: 1));
}
