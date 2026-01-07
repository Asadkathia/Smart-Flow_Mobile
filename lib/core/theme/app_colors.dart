import 'package:flutter/material.dart';

/// App Colors for SmartFlowPro
/// 
/// Centralized color definitions for consistent theming.
class AppColors {
  AppColors._();

  // ============ Brand Colors ============
  static const Color beige = Color(0xFFFAF6E9);
  static const Color lightBeige = Color(0xFFECE8D9);
  static const Color cream = Color(0xFFFFFDF6);
  static const Color darkGrey = Color(0xFF494949);

  // ============ Basic Colors ============
  static const Color whiteColor = Colors.white;
  static const Color white = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color greyColor = Colors.grey;

  // ============ Semantic Colors ============
  static const Color backgroundColor = cream;
  static const Color primaryTextColor = darkGrey;
  static const Color secondaryTextColor = greyColor;
  static const Color primaryColor = darkGrey;
  static const Color mapPinColor = darkGrey;

  // ============ Status Colors ============
  static const Color accentColor = Color(0xFFFFC107);
  static const Color successColor = Color(0xFF28A745);
  static const Color successGreen = Color(0xFF059669);
  static const Color errorColor = Color(0xFFFF011A);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color softGold = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF0EA5E9);

  // ============ Text Colors ============
  static const Color deepNavyBlue = Color(0xFF1E3A8A);
  static const Color neutralDarkGray = Color(0xFF374151);
  static const Color lightGray = Color(0xFF9CA3AF);
  static const Color darkText = Color(0xFF1F2937);

  // ============ UI Element Colors ============
  static const Color skyAqua = Color(0xFF0EA5E9);
  static const Color gradientBlueStart = Color(0xFF3B82F6);
  static const Color darkHighlight = Color(0xFF60A5FA);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color cardBackground = white;
  static const Color shadowColor = Color(0x1A000000);

  // ============ Visit Status Colors ============
  static const Color scheduledColor = Color(0xFF6B7280);
  static const Color inProgressColor = Color(0xFF3B82F6);
  static const Color pausedColor = Color(0xFFF59E0B);
  static const Color completedColor = Color(0xFF10B981);
  static const Color cancelledColor = Color(0xFFEF4444);

  // ============ Gradients ============
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientBlueStart, skyAqua],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fadeTopGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundColor, Color(0x00FFFDF6)],
  );

  static const LinearGradient fadeBottomGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [backgroundColor, Color(0x00FFFDF6)],
  );
}



