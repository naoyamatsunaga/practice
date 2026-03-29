import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => context.push('/colors'),
        icon: const Icon(Icons.palette),
        label: const Text('カラーパレットへ'),
      ),
    );
  }
}
