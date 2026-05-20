import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/models/data/database.dart';
import 'package:practice/models/preset.dart';

/// プリセット（ホームへの素早い追加用定型）の CRUD を担当し、[PresetModel] と DB 行の変換を隠蔽する。
class PresetRepository {
  PresetRepository(this._database);

  final AppDatabase _database;

  /// プリセット一覧をストリームで購読する。
  Stream<List<PresetModel>> watchPresets() {
    return _database.watchPresets().map((list) => list.map(_toModel).toList());
  }

  /// ID を DB に任せて新規プリセットを追加する。
  Future<void> insertPresetAutoId({
    required String title,
    required int points,
    required bool isQuickAdd,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return _database.insertPresetAutoId(
      title: title,
      points: points,
      isQuickAdd: isQuickAdd,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 既存プリセットの更新。
  Future<void> updatePreset(PresetModel preset) {
    return _database.updatePreset(_toPreset(preset));
  }

  /// プリセットの削除。
  Future<void> deletePreset(PresetModel preset) {
    return _database.deletePreset(_toPreset(preset));
  }

  /// Drift の [Preset] 行を [PresetModel] に変換する。
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

  /// [PresetModel] を Drift 書き込み用の [Preset] に変換する。
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

/// [databaseProvider] から DB を受け取り、[PresetRepository] を組み立てる（Riverpod DI）。
final presetRepositoryProvider = Provider<PresetRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return PresetRepository(database);
});
