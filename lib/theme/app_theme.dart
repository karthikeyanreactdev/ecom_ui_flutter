import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/color_constants.dart';
import '../core/constants/dimension_constants.dart';

class AppTheme {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: ColorConstants.primary,
      secondary: ColorConstants.accent,
      background: ColorConstants.backgroundLight,
      surface: ColorConstants.surfaceLight,
      error: ColorConstants.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: ColorConstants.textPrimary,
      onSurface: ColorConstants.textPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: ColorConstants.backgroundLight,
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorConstants.surfaceLight,
      foregroundColor: ColorConstants.textPrimary,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontSize: DimensionConstants.textXL,
        fontWeight: FontWeight.w600,
        color: ColorConstants.textPrimary,
      ),
      iconTheme: IconThemeData(color: ColorConstants.textPrimary),
    ),
    // Card Theme
    cardTheme: CardTheme(
      color: ColorConstants.surfaceLight,
      elevation: DimensionConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.cardBorderRadius),
      ),
    ),
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primary,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, DimensionConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        ),
        padding: const EdgeInsets.symmetric(vertical: DimensionConstants.paddingM),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: DimensionConstants.textL,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConstants.primary,
        minimumSize: Size(double.infinity, DimensionConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        ),
        side: const BorderSide(color: ColorConstants.primary),
        padding: const EdgeInsets.symmetric(vertical: DimensionConstants.paddingM),
        textStyle: const TextStyle(
          fontSize: DimensionConstants.textL,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConstants.primary,
        textStyle: const TextStyle(
          fontSize: DimensionConstants.textM,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // InputDecoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorConstants.surfaceLight,
      contentPadding: const EdgeInsets.all(DimensionConstants.paddingL),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.error),
      ),
      labelStyle: const TextStyle(
        color: ColorConstants.textSecondary,
        fontSize: DimensionConstants.textM,
      ),
      hintStyle: const TextStyle(
        color: ColorConstants.textSecondary,
        fontSize: DimensionConstants.textM,
      ),
    ),
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: DimensionConstants.heading1,
        fontWeight: FontWeight.bold,
        color: ColorConstants.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: DimensionConstants.heading2,
        fontWeight: FontWeight.bold,
        color: ColorConstants.textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: DimensionConstants.heading3,
        fontWeight: FontWeight.bold,
        color: ColorConstants.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: DimensionConstants.textXXL,
        fontWeight: FontWeight.w700,
        color: ColorConstants.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: DimensionConstants.textXL,
        fontWeight: FontWeight.w600,
        color: ColorConstants.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: DimensionConstants.textL,
        fontWeight: FontWeight.w600,
        color: ColorConstants.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: DimensionConstants.textL,
        color: ColorConstants.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: DimensionConstants.textM,
        color: ColorConstants.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: DimensionConstants.textS,
        color: ColorConstants.textSecondary,
      ),
    ),
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: ColorConstants.dividerLight,
      thickness: DimensionConstants.dividerThickness,
      space: DimensionConstants.marginM,
    ),
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorConstants.surfaceLight,
      selectedItemColor: ColorConstants.primary,
      unselectedItemColor: ColorConstants.textSecondary,
      selectedLabelStyle: TextStyle(
        fontSize: DimensionConstants.textXS,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: DimensionConstants.textXS,
        fontWeight: FontWeight.w500,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: DimensionConstants.cardElevation,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return ColorConstants.textSecondary.withOpacity(.32);
          }
          return ColorConstants.primary;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusXS),
      ),
    ),
    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusL),
      ),
      titleTextStyle: const TextStyle(
        fontSize: DimensionConstants.textXL,
        fontWeight: FontWeight.w600,
        color: ColorConstants.textPrimary,
      ),
      contentTextStyle: const TextStyle(
        fontSize: DimensionConstants.textM,
        color: ColorConstants.textPrimary,
      ),
    ),
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: ColorConstants.primary.withOpacity(0.1),
      disabledColor: ColorConstants.dividerLight,
      selectedColor: ColorConstants.primary,
      secondarySelectedColor: ColorConstants.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: DimensionConstants.paddingM,
        vertical: DimensionConstants.paddingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
      ),
      labelStyle: const TextStyle(
        fontSize: DimensionConstants.textS,
        color: ColorConstants.primary,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: DimensionConstants.textS,
        color: Colors.white,
      ),
      brightness: Brightness.light,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: ColorConstants.primaryLight,
      secondary: ColorConstants.accentLight,
      background: ColorConstants.backgroundDark,
      surface: ColorConstants.surfaceDark,
      error: ColorConstants.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: ColorConstants.backgroundDark,
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorConstants.surfaceDark,
      foregroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: DimensionConstants.textXL,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    // Card Theme
    cardTheme: CardTheme(
      color: ColorConstants.surfaceDark,
      elevation: DimensionConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.cardBorderRadius),
      ),
    ),
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primaryLight,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, DimensionConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        ),
        padding: const EdgeInsets.symmetric(vertical: DimensionConstants.paddingM),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: DimensionConstants.textL,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConstants.primaryLight,
        minimumSize: Size(double.infinity, DimensionConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        ),
        side: const BorderSide(color: ColorConstants.primaryLight),
        padding: const EdgeInsets.symmetric(vertical: DimensionConstants.paddingM),
        textStyle: const TextStyle(
          fontSize: DimensionConstants.textL,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConstants.primaryLight,
        textStyle: const TextStyle(
          fontSize: DimensionConstants.textM,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // InputDecoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorConstants.surfaceDark,
      contentPadding: const EdgeInsets.all(DimensionConstants.paddingL),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.primaryLight),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        borderSide: const BorderSide(color: ColorConstants.error),
      ),
      labelStyle: const TextStyle(
        color: Colors.white70,
        fontSize: DimensionConstants.textM,
      ),
      hintStyle: const TextStyle(
        color: Colors.white70,
        fontSize: DimensionConstants.textM,
      ),
    ),
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: DimensionConstants.heading1,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: DimensionConstants.heading2,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: DimensionConstants.heading3,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: DimensionConstants.textXXL,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: DimensionConstants.textXL,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: DimensionConstants.textL,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: DimensionConstants.textL,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: DimensionConstants.textM,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: DimensionConstants.textS,
        color: Colors.white70,
      ),
    ),
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: ColorConstants.dividerDark,
      thickness: DimensionConstants.dividerThickness,
      space: DimensionConstants.marginM,
    ),
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorConstants.surfaceDark,
      selectedItemColor: ColorConstants.primaryLight,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: TextStyle(
        fontSize: DimensionConstants.textXS,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: DimensionConstants.textXS,
        fontWeight: FontWeight.w500,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: DimensionConstants.cardElevation,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.white70.withOpacity(.32);
          }
          return ColorConstants.primaryLight;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusXS),
      ),
    ),
    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusL),
      ),
      titleTextStyle: const TextStyle(
        fontSize: DimensionConstants.textXL,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      contentTextStyle: const TextStyle(
        fontSize: DimensionConstants.textM,
        color: Colors.white,
      ),
    ),
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: ColorConstants.primaryLight.withOpacity(0.2),
      disabledColor: ColorConstants.dividerDark,
      selectedColor: ColorConstants.primaryLight,
      secondarySelectedColor: ColorConstants.primaryLight,
      padding: const EdgeInsets.symmetric(
        horizontal: DimensionConstants.paddingM,
        vertical: DimensionConstants.paddingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
      ),
      labelStyle: const TextStyle(
        fontSize: DimensionConstants.textS,
        color: ColorConstants.primaryLight,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: DimensionConstants.textS,
        color: Colors.white,
      ),
      brightness: Brightness.dark,
    ),
  );
}