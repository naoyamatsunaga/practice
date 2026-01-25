import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice/database.dart';

class AddActivityPointDialog extends StatefulWidget {
  const AddActivityPointDialog({super.key, required this.database});

  final AppDatabase database;

  @override
  State<AddActivityPointDialog> createState() => _AddActivityPointDialogState();
}

class _AddActivityPointDialogState extends State<AddActivityPointDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ポイント追加'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'タイトル'),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '説明'),
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '説明を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ポイント'),
                controller: _pointsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ポイントを入力してください';
                  }
                  final parsed = int.tryParse(value);
                  if (parsed == null) {
                    return '数字のみで入力してください';
                  }
                  if (parsed < 0) {
                    return '0以上で入力してください';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            final bool isValid = _formKey.currentState?.validate() ?? false;
            if (!isValid) {
              return;
            }
            _addActivityPoint();
          },
          child: const Text('登録'),
        ),
      ],
    );
  }

  Future<void> _addActivityPoint() async {
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
}
