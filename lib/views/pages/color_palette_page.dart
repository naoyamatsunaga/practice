import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/view_models/color_palette_view_model.dart';

/// カラーパレットを表示するページ
class ColorPalettePage extends ConsumerWidget {
  const ColorPalettePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(colorPaletteViewModelProvider);
    final theme = Theme.of(context);
    final themeColors = viewModel.buildThemeColors(theme);
    final customThemeColors = viewModel.buildCustomThemeColors(theme);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('カラーパレット'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Colors',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    _buildColorGrid(themeColors),
                    const SizedBox(height: 10),
                    Text(
                      'Custom Theme Colors',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    _buildColorGrid(customThemeColors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGrid(List<ColorPaletteItem> colors) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final colorData = colors[index];
        return _buildColorCard(
          color: colorData.color,
          name: colorData.name,
        );
      },
    );
  }

  Widget _buildColorCard({required Color color, required String name}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
