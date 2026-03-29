import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;

  const CustomTimePickerDialog({super.key, required this.initialTime});

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late TimeOfDay _selectedTime;
  bool _isInputMode = false;

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _hourController.text = _selectedTime.hour.toString().padLeft(2, '0');
    _minuteController.text = _selectedTime.minute.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isInputMode) {
      if (_formKey.currentState?.validate() ?? false) {
        final h = int.parse(_hourController.text);
        final m = int.parse(_minuteController.text);
        Navigator.pop(context, TimeOfDay(hour: h, minute: m));
      }
    } else {
      Navigator.pop(context, _selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('更新時刻の選択'),
          IconButton(
            icon: Icon(_isInputMode ? Icons.access_time_filled : Icons.keyboard),
            tooltip: _isInputMode ? 'スクロール選択に切り替え' : '文字入力に切り替え',
            onPressed: () {
              setState(() {
                if (!_isInputMode) {
                  // スクロールで選ばれている値をテキストフィールドに同期
                  _hourController.text =
                      _selectedTime.hour.toString().padLeft(2, '0');
                  _minuteController.text =
                      _selectedTime.minute.toString().padLeft(2, '0');
                }
                _isInputMode = !_isInputMode;
              });
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 300,
        height: 200,
        child: _isInputMode ? _buildInputMode() : _buildScrollMode(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildScrollMode() {
    return DefaultTextStyle(
      // iOSスタイルのドラムロール表示向け
      style: Theme.of(context).textTheme.titleLarge ?? const TextStyle(),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        use24hFormat: true,
        initialDateTime: DateTime(
          2000,
          1,
          1,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        onDateTimeChanged: (DateTime newDateTime) {
          setState(() {
            _selectedTime = TimeOfDay.fromDateTime(newDateTime);
          });
        },
      ),
    );
  }

  Widget _buildInputMode() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: TextFormField(
              controller: _hourController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 2,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
                labelText: '時',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return '必須';
                final h = int.tryParse(value);
                if (h == null || h < 0 || h > 23) return '無効';
                return null;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              ':',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              controller: _minuteController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 2,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
                labelText: '分',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return '必須';
                final m = int.tryParse(value);
                if (m == null || m < 0 || m > 59) return '無効';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
