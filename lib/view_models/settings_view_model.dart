import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsViewModel {
  const SettingsViewModel();

  String get colorPaletteRoute => '/colors';
}

final settingsViewModelProvider = Provider<SettingsViewModel>((ref) {
  return const SettingsViewModel();
});
