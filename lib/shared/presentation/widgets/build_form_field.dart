import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// ignore: must_be_immutable, camel_case_types
class buildFormField extends StatelessWidget {
  String? hint;
  Widget? suffixIcon;
  Widget? prefixIcon;
  String? Function(String?)? validator;
  void Function(String?)? onSaved;
  bool obscureText;
  Color? fillColor;
  Widget? helper;
  Color inputColor;
  void Function()? onTap;
  bool readOnly;
  bool isRequired;
  TextEditingController? controller;
  TextInputType? keyboardType;
  int? length;
  int? minLines;
  int? maxLines;
  double? inputSize;
  EdgeInsetsGeometry? contentPadding;
  bool enableBorder;
  List<TextInputFormatter>? inputFormatter;
  bool? enabled;
  double? radius;
  TextStyle? hintstyle;
  void Function(String)? onChanged;

String? labelText;
  buildFormField({
    super.key,
    this.helper,
    this.hint,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onSaved,
    this.onTap,
    this.obscureText = false,
    this.fillColor = AppColors.whiteColor,
    this.inputColor = AppColors.whiteColor,
    this.controller,
    this.readOnly = false,
    this.isRequired = true,
    this.keyboardType,
    this.length,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputSize,
    this.contentPadding,
    this.enableBorder = false,
    this.inputFormatter,
    this.enabled,
    this.radius,
    this.hintstyle,
    this.onChanged,
    this.labelText
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          if(labelText != null) ...[
            Text(
              labelText!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        
        TextFormField(
          onChanged: onChanged,
          inputFormatters: inputFormatter,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus(); // Keyboard hide karega
          },
          minLines: minLines,
          maxLines: maxLines,
          maxLength: length,
          keyboardType: keyboardType,
          onTap: onTap,
          controller: controller,
          readOnly: readOnly,
          enabled: enabled ?? true,
          style: TextStyle(color: Colors.black, fontSize: inputSize ?? 14.sp),
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: prefixIcon,
            fillColor: fillColor,
            filled: true,
            hintText: hint,
            hintStyle:
                hintstyle ??
                TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.lightGray,
                  fontWeight: FontWeight.w400,
                ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 30),
              borderSide: BorderSide(
                color: AppColors.lightGray,
                //const Color.fromARGB(255, 219, 240, 219)
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 30),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 30),
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
            errorStyle: TextStyle(height: 0.5.h),
          ),
          obscureText: obscureText,
          validator: validator,
          onSaved: onSaved,
        ),
        helper ?? SizedBox(),
      ],
    );
  }
}
