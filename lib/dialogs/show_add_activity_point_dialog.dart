import 'package:flutter/material.dart';
import 'package:practice/database.dart';

class AddActivityPointDialog extends StatefulWidget {
  const AddActivityPointDialog({super.key, required this.database});

  final AppDatabase database;

  @override
  State<AddActivityPointDialog> createState() => _AddActivityPointDialogState();
}

class _AddActivityPointDialogState extends State<AddActivityPointDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final int nextId = (await widget.database.getMaxId()) + 1;
    await widget.database.insertActivityPoint(
      ActivityPoint(
        id: nextId,
        date: DateTime.now(),
        time: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: DateTime.now(),
        title: _titleController.text,
        description: _descriptionController.text,
        points: int.parse(_pointsController.text),
      ),
    );
    _titleController.clear();
    _descriptionController.clear();
    _pointsController.clear();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ポイント追加'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'タイトル'),
            controller: _titleController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: '説明'),
            controller: _descriptionController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'ポイント'),
            controller: _pointsController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('追加'),
        ),
      ],
    );
  }
}
