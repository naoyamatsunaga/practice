import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice/models/preset.dart';

class EditPresetDialog extends StatefulWidget {
  const EditPresetDialog({
    super.key,
    required this.preset,
    required this.onSubmit,
  });

  final PresetModel preset;
  final Future<void> Function({
    required PresetModel original,
    required String title,
    required int points,
    required bool isQuickAdd,
  }) onSubmit;

  @override
  State<EditPresetDialog> createState() => _EditPresetDialogState();
}

class _EditPresetDialogState extends State<EditPresetDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _pointsController;
  late bool _isQuickAdd;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.preset.title);
    _pointsController =
        TextEditingController(text: widget.preset.points.toString());
    _isQuickAdd = widget.preset.isQuickAdd;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('プリセット編集'),
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
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('1タップ追加'),
                subtitle: const Text('ONにするとホーム画面で一括追加できます'),
                value: _isQuickAdd,
                onChanged: (value) {
                  setState(() {
                    _isQuickAdd = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            final isValid = _formKey.currentState?.validate() ?? false;
            if (!isValid) {
              return;
            }
            _submit();
          },
          child: const Text('更新'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    await widget.onSubmit(
      original: widget.preset,
      title: _titleController.text,
      points: int.parse(_pointsController.text),
      isQuickAdd: _isQuickAdd,
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
