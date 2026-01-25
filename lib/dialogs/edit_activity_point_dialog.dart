import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice/database.dart';

class EditActivityPointDialog extends StatefulWidget {
  const EditActivityPointDialog({
    super.key,
    required this.activityPoint,
    required this.database,
  });

  final ActivityPoint activityPoint;
  final AppDatabase database;

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
    _titleController = TextEditingController(text: widget.activityPoint.title);
    _pointsController =
        TextEditingController(text: widget.activityPoint.points.toString());
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
    final updatedPoint = widget.activityPoint.copyWith(
      title: _titleController.text,
      points: int.parse(_pointsController.text),
      updatedAt: DateTime.now(), // 更新日時を現在時刻に
    );

    await widget.database.updateActivityPoint(updatedPoint);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
