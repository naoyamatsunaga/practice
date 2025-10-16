import 'package:flutter/material.dart';

import 'color_palette_page.dart';
import 'colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Practice',
      theme: AppThemeExtension.createLightTheme(),
      darkTheme: AppThemeExtension.createDarkTheme(),
      home: const ColorPalettePage(),
    );
  }
}
