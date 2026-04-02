import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/preset.dart';
import 'package:practice/repositories/preset_repository.dart';

final presetListStreamProvider = StreamProvider<List<PresetModel>>((ref) {
  final repository = ref.watch(presetRepositoryProvider);
  return repository.watchPresets();
});

final presetViewModelProvider = NotifierProvider<PresetViewModel, void>(
  PresetViewModel.new,
);

class PresetViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<void> addPreset({
    required String title,
    required int points,
    required bool isQuickAdd,
  }) async {
    final repository = ref.read(presetRepositoryProvider);
    final now = DateTime.now();
    final nextId = await repository.getNextId();

    await repository.insertPreset(
      PresetModel(
        id: nextId,
        title: title,
        points: points,
        isQuickAdd: isQuickAdd,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> updatePreset({
    required PresetModel original,
    required String title,
    required int points,
    required bool isQuickAdd,
  }) async {
    final repository = ref.read(presetRepositoryProvider);
    await repository.updatePreset(
      PresetModel(
        id: original.id,
        title: title,
        points: points,
        isQuickAdd: isQuickAdd,
        createdAt: original.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> deletePreset(PresetModel preset) async {
    final repository = ref.read(presetRepositoryProvider);
    await repository.deletePreset(preset);
  }
}
