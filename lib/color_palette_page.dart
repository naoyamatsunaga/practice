import 'package:flutter/material.dart';
import 'package:practice/colors.dart';

/// カラーパレットを表示するページ
class ColorPalettePage extends StatelessWidget {
  const ColorPalettePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                    // Theme Colors (from ColorScheme)
                    Text(
                      'Theme Colors',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    _buildColorGrid([
                      {
                        'color': Theme.of(context).colorScheme.primary,
                        'name': 'Theme.primary'
                      },
                      {
                        'color': Theme.of(context).colorScheme.secondary,
                        'name': 'Theme.secondary'
                      },
                      {
                        'color': Theme.of(context).colorScheme.tertiary,
                        'name': 'Theme.tertiary'
                      },
                      {
                        'color': Theme.of(context).colorScheme.surface,
                        'name': 'Theme.surface'
                      },
                      {
                        'color': Theme.of(context).colorScheme.error,
                        'name': 'Theme.error'
                      },
                      {
                        'color': Theme.of(context).colorScheme.onPrimary,
                        'name': 'Theme.onPrimary'
                      },
                      {
                        'color': Theme.of(context).colorScheme.onSecondary,
                        'name': 'Theme.onSecondary'
                      },
                      {
                        'color': Theme.of(context).colorScheme.onTertiary,
                        'name': 'Theme.onTertiary'
                      },
                      {
                        'color': Theme.of(context).colorScheme.onSurface,
                        'name': 'Theme.onSurface'
                      },
                      {
                        'color': Theme.of(context).colorScheme.onError,
                        'name': 'Theme.onError'
                      },
                    ]),
                    const SizedBox(height: 10),
                    Text(
                      'Custom Theme Colors',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    _buildColorGrid([
                      {
                        'color': Theme.of(context).warning,
                        'name': 'Theme.warning'
                      },
                      {
                        'color': Theme.of(context).onWarning,
                        'name': 'Theme.onWarning'
                      },
                      {
                        'color': Theme.of(context).information,
                        'name': 'Theme.information'
                      },
                      {
                        'color': Theme.of(context).onInformation,
                        'name': 'Theme.onInformation'
                      },
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 色のグリッドを構築する
  Widget _buildColorGrid(List<Map<String, dynamic>> colors) {
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
          color: colorData['color'] as Color,
          name: colorData['name'] as String,
        );
      },
    );
  }

  /// 個別の色カードを構築する
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
              color: Colors.black.withOpacity(0.7),
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
