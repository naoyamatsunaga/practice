import 'package:flutter/material.dart';
import 'package:practice/models/preset.dart';
import 'package:practice/views/dialogs/delete_preset_dialog.dart';
import 'package:practice/views/dialogs/edit_preset_dialog.dart';

class PresetCard extends StatelessWidget {
  const PresetCard({
    super.key,
    required this.preset,
    required this.onEdit,
    required this.onDelete,
  });

  final PresetModel preset;
  final Future<void> Function({
    required PresetModel original,
    required String title,
    required int points,
    required bool isQuickAdd,
  }) onEdit;
  final Future<void> Function(PresetModel preset) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  preset.points.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Text(
                    preset.title,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      showDialog(
                        context: context,
                        builder: (context) => EditPresetDialog(
                          preset: preset,
                          onSubmit: onEdit,
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) => DeletePresetDialog(
                        preset: preset,
                        onConfirm: onDelete,
                      ),
                    );
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('編集'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('削除', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    preset.isQuickAdd ? '1タップ追加: ON' : '1タップ追加: OFF',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
