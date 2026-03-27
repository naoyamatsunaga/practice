import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/colors.dart';

class ColorPaletteItem {
  const ColorPaletteItem({
    required this.color,
    required this.name,
  });

  final Color color;
  final String name;
}

class ColorPaletteViewModel {
  const ColorPaletteViewModel();

  List<ColorPaletteItem> buildThemeColors(ThemeData theme) {
    return <ColorPaletteItem>[
      ColorPaletteItem(color: theme.colorScheme.primary, name: 'Theme.primary'),
      ColorPaletteItem(
        color: theme.colorScheme.secondary,
        name: 'Theme.secondary',
      ),
      ColorPaletteItem(color: theme.colorScheme.tertiary, name: 'Theme.tertiary'),
      ColorPaletteItem(color: theme.colorScheme.surface, name: 'Theme.surface'),
      ColorPaletteItem(color: theme.colorScheme.error, name: 'Theme.error'),
      ColorPaletteItem(color: theme.colorScheme.onPrimary, name: 'Theme.onPrimary'),
      ColorPaletteItem(
        color: theme.colorScheme.onSecondary,
        name: 'Theme.onSecondary',
      ),
      ColorPaletteItem(
        color: theme.colorScheme.onTertiary,
        name: 'Theme.onTertiary',
      ),
      ColorPaletteItem(color: theme.colorScheme.onSurface, name: 'Theme.onSurface'),
      ColorPaletteItem(color: theme.colorScheme.onError, name: 'Theme.onError'),
    ];
  }

  List<ColorPaletteItem> buildCustomThemeColors(ThemeData theme) {
    return <ColorPaletteItem>[
      ColorPaletteItem(color: theme.warning, name: 'Theme.warning'),
      ColorPaletteItem(color: theme.onWarning, name: 'Theme.onWarning'),
      ColorPaletteItem(color: theme.information, name: 'Theme.information'),
      ColorPaletteItem(color: theme.onInformation, name: 'Theme.onInformation'),
    ];
  }
}

final colorPaletteViewModelProvider = Provider<ColorPaletteViewModel>((ref) {
  return const ColorPaletteViewModel();
});
