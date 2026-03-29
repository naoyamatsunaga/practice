import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice/models/activity.dart';

class EditActivityPointDialog extends StatefulWidget {
  const EditActivityPointDialog({
    super.key,
    required this.activityModel,
    required this.onSubmit,
  });

  final ActivityModel activityModel;
  final Future<void> Function({
    required ActivityModel original,
    required String title,
    required int points,
  }) onSubmit;

  @override
  State<EditActivityPointDialog> createState() =>
      _EditActivityPointDialogState();
}

class _EditActivityPointDialogState extends State<EditActivityPointDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _pointsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activityModel.title);
    _pointsController =
        TextEditingController(text: widget.activityModel.points.toString());
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
      title: const Text('ポイント編集'),
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
            _updateActivityPoint();
          },
          child: const Text('更新'),
        ),
      ],
    );
  }

  Future<void> _updateActivityPoint() async {
    await widget.onSubmit(
      original: widget.activityModel,
      title: _titleController.text,
      points: int.parse(_pointsController.text),
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
