import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kResetTimeHour = 'reset_time_hour';
const _kResetTimeMinute = 'reset_time_minute';

/// アプリ全体で共有するリセット時刻のプロバイダー
final resetTimeProvider = NotifierProvider<ResetTimeNotifier, TimeOfDay>(
  ResetTimeNotifier.new,
);

class ResetTimeNotifier extends Notifier<TimeOfDay> {
  SharedPreferences? _prefs;

  @override
  TimeOfDay build() {
    // build は同期的に呼ばれるため、後非同期で初期化
    _init();
    // デフォルトのリセット時刻は 00:00 とする
    return const TimeOfDay(hour: 0, minute: 0);
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final hour = _prefs?.getInt(_kResetTimeHour);
    final minute = _prefs?.getInt(_kResetTimeMinute);

    if (hour != null && minute != null) {
      state = TimeOfDay(hour: hour, minute: minute);
    }
  }

  Future<void> setResetTime(TimeOfDay newTime) async {
    state = newTime;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt(_kResetTimeHour, newTime.hour);
    await _prefs?.setInt(_kResetTimeMinute, newTime.minute);
  }
}

// --- Time Util Functions ---

/// 現時刻とリセット時刻から、現在の期間の開始時刻を計算する
DateTime getStartOfCurrentPeriod(DateTime now, TimeOfDay resetTime) {
  final currentDayReset = DateTime(
    now.year,
    now.month,
    now.day,
    resetTime.hour,
    resetTime.minute,
  );

  // もし現在時刻が、今日の「リセット時刻」より前（または同時）であれば、
  // 今の期間の開始は昨日のリセット時刻になる
  if (now.isBefore(currentDayReset)) {
    return currentDayReset.subtract(const Duration(days: 1));
  } else {
    // そうでなければ、今の期間の開始は今日のリセット時刻になる
    return currentDayReset;
  }
}

/// アクティビティの作成時刻とリセット時刻から、履歴画面で表示する論理的な「対象日」を計算する
DateTime getLogicalDate(DateTime activityTime, TimeOfDay resetTime) {
  final startOfPeriod = getStartOfCurrentPeriod(activityTime, resetTime);
  // 論理的な日付は、その期間が始まった「日」を基準にする
  // 例: 28日 04:00 が基準なら、論理日付は 28日 の 00:00
  return DateTime(
    startOfPeriod.year,
    startOfPeriod.month,
    startOfPeriod.day,
  );
}

/// 現時刻とリセット時刻から、次回リセットが行われる時刻を計算する
DateTime getNextResetTime(DateTime now, TimeOfDay resetTime) {
  final start = getStartOfCurrentPeriod(now, resetTime);
  return start.add(const Duration(days: 1));
}
