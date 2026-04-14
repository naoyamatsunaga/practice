import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onSubmit});

  final Future<void> Function({
    required String title,
    required int points,
    required bool addToPreset,
  }) onSubmit;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  bool _addToPreset = false;

  @override
  void dispose() {
    _titleController.dispose();
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
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('プリセットに追加'),
                subtitle: const Text(
                  'ONの場合、ホームに追加すると同時にプリセットにも保存されます。OFFの場合はホームのみの一時的なタスクです。',
                ),
                value: _addToPreset,
                onChanged: (value) {
                  setState(() {
                    _addToPreset = value ?? false;
                  });
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
            _addTask();
          },
          child: const Text('登録'),
        ),
      ],
    );
  }

  Future<void> _addTask() async {
    await widget.onSubmit(
      title: _titleController.text,
      points: int.parse(_pointsController.text),
      addToPreset: _addToPreset,
    );
    _titleController.clear();
    _pointsController.clear();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
