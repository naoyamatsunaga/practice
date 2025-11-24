import 'package:flutter/material.dart';
import 'package:practice/database.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home'),
    );
  }
}
