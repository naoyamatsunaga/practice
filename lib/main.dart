import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice/database.dart';
import 'package:practice/repositories/activity_repository.dart';
import 'package:practice/colors.dart';
import 'package:practice/view_models/home_view_model.dart';
import 'package:practice/views/pages/color_palette_page.dart';
import 'package:practice/views/pages/home_page.dart';
import 'package:practice/views/pages/history_page.dart';
import 'package:practice/views/pages/preset_page.dart';
import 'package:practice/views/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await debugSeedIfFirstLaunch(ActivityRepository(database));
  runApp(
    ProviderScope(
      overrides: [
        // databaseProviderを実際のデータベースインスタンスで上書き
        databaseProvider.overrideWithValue(database),
      ],
      child: MyApp(database: database),
    ),
  );
}

GoRouter _router(AppDatabase database) => GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) {
                  navigationShell.goBranch(index);
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.bookmark_outline),
                    selectedIcon: Icon(Icons.bookmark),
                    label: 'プリセット',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history_outlined),
                    selectedIcon: Icon(Icons.history),
                    label: '履歴',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: '設定',
                  ),
                ],
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/presets',
                  name: 'presets',
                  builder: (context, state) => const PresetPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/history',
                  name: 'history',
                  builder: (context, state) => const HistoryPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  name: 'settings',
                  builder: (context, state) => const SettingsPage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/colors',
          name: 'colors',
          builder: (context, state) => const ColorPalettePage(),
        ),
      ],
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Practice',
      theme: AppThemeExtension.createLightTheme(),
      darkTheme: AppThemeExtension.createDarkTheme(),
      routerConfig: _router(database),
    );
  }
}
