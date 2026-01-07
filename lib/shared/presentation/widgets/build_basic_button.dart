import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_text_styles.dart';

// ignore: must_be_immutable
class BuildBasicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? buttonColor;
  final TextStyle? textStyle;
  final bool enableShadow;
  final Widget? icon; // Optional icon
  double? radius;

  BuildBasicButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.buttonColor,
    this.textStyle,
    this.enableShadow = true,
    this.icon,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: enableShadow ? 1 : 0,
        minimumSize: Size.fromHeight(height ?? 46.h),
        backgroundColor: buttonColor,
        textStyle: textStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 14.r),
        ),
      ),
      onPressed: onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
        child: Text(
          title,
          style:
              textStyle ??
              AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
