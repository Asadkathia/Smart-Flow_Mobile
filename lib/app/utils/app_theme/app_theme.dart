import '../../export/exports.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.robotoSlab().fontFamily, // Global font family
    primaryColor: AppColors.darkGrey, // Using darkGrey as primary
    scaffoldBackgroundColor:
        AppColors.backgroundColor, // Using backgroundColor as background
    colorScheme: ColorScheme.light(
      primary: AppColors.darkGrey,
      secondary: AppColors.beige, // Using beige as secondary
      surface: AppColors.cream, // Using cream for surfaces
      onPrimary: AppColors.whiteColor, // Text on primary color
      onSecondary: AppColors.blackColor, // Text on secondary color
      onSurface: AppColors.darkGrey, // Text on surface color
    ),

    // Global text theme with Google Fonts
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

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkGrey,
      foregroundColor: AppColors.whiteColor, // Text color for AppBar
      titleTextStyle: GoogleFonts.robotoSlab(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGrey, // Button background color
        foregroundColor: AppColors.whiteColor, // Text color on button
        textStyle: GoogleFonts.robotoSlab(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
        ),
      ),
    ),

    // Input decoration theme for consistent form fields
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.robotoSlab(
        color: AppColors.greyColor,
        fontSize: 16,
      ),
      hintStyle: GoogleFonts.robotoSlab(
        color: AppColors.greyColor,
        fontSize: 15,
      ),
      errorStyle: GoogleFonts.robotoSlab(color: Colors.red, fontSize: 12),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: GoogleFonts.robotoSlab(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
