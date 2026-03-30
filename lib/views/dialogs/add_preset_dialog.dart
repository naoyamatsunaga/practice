import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPresetDialog extends StatefulWidget {
  const AddPresetDialog({super.key, required this.onSubmit});

  final Future<void> Function({
    required String title,
    required int points,
    required bool oneTapEnabled,
  }) onSubmit;

  @override
  State<AddPresetDialog> createState() => _AddPresetDialogState();
}

class _AddPresetDialogState extends State<AddPresetDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  bool _oneTapEnabled = false;

  @override
  void dispose() {
    _titleController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('プリセット作成'),
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
                value: _oneTapEnabled,
                onChanged: (value) {
                  setState(() {
                    _oneTapEnabled = value;
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
          child: const Text('作成'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    await widget.onSubmit(
      title: _titleController.text,
      points: int.parse(_pointsController.text),
      oneTapEnabled: _oneTapEnabled,
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
