import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App Theme for SmartFlowPro
/// 
/// Defines the light and dark themes for the application.
class AppTheme {
  AppTheme._();

  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.robotoSlab().fontFamily,
    primaryColor: AppColors.darkGrey,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.darkGrey,
      secondary: AppColors.beige,
      surface: AppColors.cream,
      error: AppColors.errorRed,
      onPrimary: AppColors.whiteColor,
      onSecondary: AppColors.blackColor,
      onSurface: AppColors.darkGrey,
      onError: AppColors.whiteColor,
    ),

    // Text Theme
    textTheme: GoogleFonts.robotoSlabTextTheme(ThemeData.light().textTheme)
        .copyWith(
          displayLarge: GoogleFonts.robotoSlab(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
          displayMedium: GoogleFonts.robotoSlab(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
          displaySmall: GoogleFonts.robotoSlab(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
          headlineLarge: GoogleFonts.robotoSlab(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
          headlineMedium: GoogleFonts.robotoSlab(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
          headlineSmall: GoogleFonts.robotoSlab(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
          titleLarge: GoogleFonts.robotoSlab(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
          titleMedium: GoogleFonts.robotoSlab(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
          titleSmall: GoogleFonts.robotoSlab(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
          bodyLarge: GoogleFonts.robotoSlab(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.darkGrey,
          ),
          bodyMedium: GoogleFonts.robotoSlab(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.darkGrey,
          ),
          bodySmall: GoogleFonts.robotoSlab(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.greyColor,
          ),
          labelLarge: GoogleFonts.robotoSlab(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
          labelMedium: GoogleFonts.robotoSlab(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
          labelSmall: GoogleFonts.robotoSlab(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.greyColor,
          ),
        ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: AppColors.darkGrey,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.robotoSlab(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.darkGrey,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkGrey,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGrey,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.robotoSlab(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkGrey,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.robotoSlab(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: AppColors.darkGrey, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkGrey,
        textStyle: GoogleFonts.robotoSlab(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.whiteColor,
      labelStyle: GoogleFonts.robotoSlab(
        color: AppColors.greyColor,
        fontSize: 16,
      ),
      hintStyle: GoogleFonts.robotoSlab(
        color: AppColors.lightGray,
        fontSize: 15,
      ),
      errorStyle: GoogleFonts.robotoSlab(
        color: AppColors.errorRed,
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkGrey, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.whiteColor,
      elevation: 2,
      shadowColor: AppColors.shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerColor,
      thickness: 1,
      space: 1,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.whiteColor,
      selectedItemColor: AppColors.darkGrey,
      unselectedItemColor: AppColors.greyColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkGrey,
      foregroundColor: AppColors.whiteColor,
      elevation: 4,
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkGrey;
        }
        return AppColors.whiteColor;
      }),
      checkColor: WidgetStateProperty.all(AppColors.whiteColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkGrey;
        }
        return AppColors.greyColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkGrey.withOpacity(0.3);
        }
        return AppColors.greyColor.withOpacity(0.3);
      }),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkGrey,
      contentTextStyle: GoogleFonts.robotoSlab(
        color: AppColors.whiteColor,
        fontSize: 14,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.robotoSlab(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.darkGrey,
      ),
      contentTextStyle: GoogleFonts.robotoSlab(
        fontSize: 14,
        color: AppColors.neutralDarkGray,
      ),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.darkGrey,
      unselectedLabelColor: AppColors.greyColor,
      labelStyle: GoogleFonts.robotoSlab(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.robotoSlab(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.darkGrey, width: 2),
      ),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.darkGrey,
      linearTrackColor: AppColors.lightGray,
    ),
  );

  /// Dark Theme (for future use)
  static ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkText,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkHighlight,
      secondary: AppColors.skyAqua,
      surface: Color(0xFF1F2937),
      error: AppColors.errorRed,
      onPrimary: AppColors.whiteColor,
      onSecondary: AppColors.whiteColor,
      onSurface: AppColors.whiteColor,
      onError: AppColors.whiteColor,
    ),
  );
}

