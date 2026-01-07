import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App Text Styles for SmartFlowPro
/// 
/// Centralized text style definitions for consistent typography.
class AppTextStyles {
  AppTextStyles._();

  // ============ Heading Styles ============
  static TextStyle heading1 = GoogleFonts.robotoSlab(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.deepNavyBlue,
  );

  static TextStyle heading2 = GoogleFonts.robotoSlab(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.deepNavyBlue,
  );

  static TextStyle heading3 = GoogleFonts.robotoSlab(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.deepNavyBlue,
  );

  static TextStyle heading4 = GoogleFonts.robotoSlab(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.deepNavyBlue,
  );

  static TextStyle heading5 = GoogleFonts.robotoSlab(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.deepNavyBlue,
  );

  static TextStyle heading6 = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.deepNavyBlue,
  );

  // ============ Body Text Styles ============
  static TextStyle bodyLarge = GoogleFonts.robotoSlab(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralDarkGray,
  );

  static TextStyle bodyMedium = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralDarkGray,
  );

  static TextStyle bodySmall = GoogleFonts.robotoSlab(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralDarkGray,
  );

  // ============ Button Styles ============
  static TextStyle buttonLarge = GoogleFonts.robotoSlab(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle buttonMedium = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle buttonSmall = GoogleFonts.robotoSlab(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // ============ Caption Styles ============
  static TextStyle caption = GoogleFonts.robotoSlab(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralDarkGray,
  );

  static TextStyle captionBold = GoogleFonts.robotoSlab(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.neutralDarkGray,
  );

  // ============ Special Styles ============
  static TextStyle error = GoogleFonts.robotoSlab(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.errorRed,
  );

  static TextStyle success = GoogleFonts.robotoSlab(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.successGreen,
  );

  static TextStyle warning = GoogleFonts.robotoSlab(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.softGold,
  );

  // ============ AppBar Styles ============
  static TextStyle appBarTitle = GoogleFonts.robotoSlab(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
  );

  // ============ TextField Styles ============
  static TextStyle textFieldLabel = GoogleFonts.robotoSlab(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralDarkGray,
  );

  static TextStyle textFieldInput = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralDarkGray,
  );

  static TextStyle textFieldHint = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.lightGray,
  );

  // ============ Link Styles ============
  static TextStyle link = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.skyAqua,
    decoration: TextDecoration.underline,
  );

  static TextStyle linkSmall = GoogleFonts.robotoSlab(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.gradientBlueStart,
    decoration: TextDecoration.underline,
  );

  // ============ Dark Mode Styles ============
  static TextStyle darkHeading = GoogleFonts.robotoSlab(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static TextStyle darkBody = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.darkText,
  );

  static TextStyle darkHighlight = GoogleFonts.robotoSlab(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.darkHighlight,
  );

  // ============ Helper Methods ============
  
  /// Get heading style with custom color
  static TextStyle headingWithColor(int level, Color color) {
    switch (level) {
      case 1:
        return heading1.copyWith(color: color);
      case 2:
        return heading2.copyWith(color: color);
      case 3:
        return heading3.copyWith(color: color);
      case 4:
        return heading4.copyWith(color: color);
      case 5:
        return heading5.copyWith(color: color);
      default:
        return heading6.copyWith(color: color);
    }
  }

  /// Get body style with custom color
  static TextStyle bodyWithColor(String size, Color color) {
    switch (size) {
      case 'large':
        return bodyLarge.copyWith(color: color);
      case 'small':
        return bodySmall.copyWith(color: color);
      default:
        return bodyMedium.copyWith(color: color);
    }
  }
}



