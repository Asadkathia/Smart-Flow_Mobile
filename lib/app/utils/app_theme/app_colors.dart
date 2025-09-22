import 'package:flutter/material.dart';

class AppColors {
  // Existing colors
  static const Color beige = Color(0xFFFAF6E9);
  static const Color lightBeige = Color(0xFFECE8D9);
  static const Color cream = Color(0xFFFFFDF6);
  static const Color darkGrey = Color(0xFF494949);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color greyColor = Colors.grey;

  // Mapped colors for UI elements
  static const Color backgroundColor = cream; // Using cream for background
  static const Color primaryTextColor =
      darkGrey; // Using darkGrey for primary text
  static const Color secondaryTextColor =
      greyColor; // Using greyColor for secondary text
  static const Color primaryColor =
      darkGrey; // Using darkGrey as primary color (can be adjusted if user provides more specific color)
  static const Color mapPinColor =
      darkGrey; // Using darkGrey for map pin (can be adjusted)

  // Added accent and success colors for job card status
  static const Color accentColor = Color(0xFFFFC107); // Amber/Yellow for accent
  static const Color successColor = Color(0xFF28A745); // Green for success
  static const Color errorColor = Color.fromARGB(
    255,
    255,
    1,
    26,
  ); // Red for error

  // Additional colors for text styles and form fields
  static const Color deepNavyBlue = Color(
    0xFF1E3A8A,
  ); // Deep navy blue for headings
  static const Color neutralDarkGray = Color(
    0xFF374151,
  ); // Neutral dark gray for text
  static const Color lightGray = Color(0xFF9CA3AF); // Light gray for hints
  static const Color white = Colors.white; // Pure white
  static const Color skyAqua = Color(0xFF0EA5E9); // Sky blue for links
  static const Color gradientBlueStart = Color(0xFF3B82F6); // Blue for borders
  static const Color errorRed = Color(0xFFDC2626); // Red for errors
  static const Color successGreen = Color(0xFF059669); // Green for success
  static const Color softGold = Color(0xFFF59E0B); // Amber for warnings
  static const Color darkText = Color(0xFF1F2937); // Dark text for dark mode
  static const Color darkHighlight = Color(
    0xFF60A5FA,
  ); // Blue highlight for dark mode
}
