import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/database.dart';
import 'package:practice/models/preset.dart';

class PresetRepository {
  PresetRepository(this._database);

  final AppDatabase _database;

  Stream<List<PresetModel>> watchPresets() {
    return _database.watchPresets().map((list) => list.map(_toModel).toList());
  }

  Future<int> getNextId() async {
    return (await _database.getPresetMaxId()) + 1;
  }

  Future<void> insertPreset(PresetModel preset) {
    return _database.insertPreset(_toPreset(preset));
  }

  Future<void> updatePreset(PresetModel preset) {
    return _database.updatePreset(_toPreset(preset));
  }

  Future<void> deletePreset(PresetModel preset) {
    return _database.deletePreset(_toPreset(preset));
  }

  PresetModel _toModel(Preset preset) {
    return PresetModel(
      id: preset.id,
      title: preset.title,
      points: preset.points,
      isQuickAdd: preset.isQuickAdd,
      createdAt: preset.createdAt,
      updatedAt: preset.updatedAt,
    );
  }

  Preset _toPreset(PresetModel model) {
    return Preset(
      id: model.id,
      title: model.title,
      points: model.points,
      isQuickAdd: model.isQuickAdd,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}

final presetRepositoryProvider = Provider<PresetRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return PresetRepository(database);
});
