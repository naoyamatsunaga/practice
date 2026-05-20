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
