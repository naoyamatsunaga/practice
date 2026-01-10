import 'package:flutter/material.dart';

/// アプリで使用する色の定数を定義するクラス
class AppColors {
  // ===== Primary Colors =====
  static const Color primary = Color(0xFF999100);
  static const Color onPrimary = Color(0xFFf9f9f9);

  // ===== Secondary Colors =====
  static const Color secondary = Color(0xFFc07e12);
  static const Color onSecondary = Color(0xFFf9f9f9);

  // ===== Tertiary Colors =====
  static const Color tertiary = Color(0xFFb34f00);
  static const Color onTertiary = Color(0xFFf9f9f9);

  // ===== Error Colors =====
  static const Color error = Color(0xFFcc1d1d);
  static const Color onError = Color(0xFFf9f9f9);

  // ===== Warning Colors =====
  static const Color warning = Color(0xFFbf390c);
  static const Color onWarning = Color(0xFFf9f9f9);

  // ===== Information Colors =====
  static const Color information = Color(0xFF1764ff);
  static const Color onInformation = Color(0xFFf9f9f9);
}

/// アプリのテーマとカスタム色を統合管理するextension
extension AppThemeExtension on ColorScheme {
  // ===== テーマ作成メソッド =====
  /// ライトテーマを作成
  static ThemeData createLightTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onTertiary: AppColors.onTertiary,
        onError: AppColors.onError,
      ),
      useMaterial3: true,
    );
  }

  /// ダークテーマを作成
  static ThemeData createDarkTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onTertiary: AppColors.onTertiary,
        onError: AppColors.onError,
      ),
      useMaterial3: true,
    );
  }
}

/// ThemeDataの拡張でカスタム色にアクセス
extension CustomThemeData on ThemeData {
  Color get warning => AppColors.warning;
  Color get onWarning => AppColors.onWarning;
  Color get information => AppColors.information;
  Color get onInformation => AppColors.onInformation;
}
