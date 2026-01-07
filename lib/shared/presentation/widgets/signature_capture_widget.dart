import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature/signature.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Signature Capture Widget
/// 
/// Allows users to capture a signature using touch input.
/// Used in visit completion flow.
class SignatureCaptureWidget extends StatefulWidget {
  final Function(String signaturePath)? onSignatureSaved;
  final String? initialSignaturePath;

  const SignatureCaptureWidget({
    super.key,
    this.onSignatureSaved,
    this.initialSignaturePath,
  });

  @override
  State<SignatureCaptureWidget> createState() => _SignatureCaptureWidgetState();
}

class _SignatureCaptureWidgetState extends State<SignatureCaptureWidget> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );

  bool _hasSignature = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.isEmpty != _hasSignature) {
        setState(() {
          _hasSignature = !_controller.isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveSignature() async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide a signature'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    try {
      final signatureData = await _controller.toPngBytes();
      if (signatureData == null) {
        throw Exception('Failed to export signature');
      }

      // Save to temporary directory
      final tempDir = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/signature_$timestamp.png');
      await file.writeAsBytes(signatureData);

      if (widget.onSignatureSaved != null) {
        widget.onSignatureSaved!(file.path);
      }

      if (mounted) {
        Navigator.of(context).pop(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save signature: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  void _clearSignature() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Signature',
                  style: AppTextStyles.heading4,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Instructions
            Text(
              'Please sign below',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Signature pad
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.greyColor.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Signature(
                  controller: _controller,
                  backgroundColor: Colors.white,
                  height: 200.h,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearSignature,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.greyColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Clear',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _hasSignature ? _saveSignature : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasSignature
                          ? AppColors.successGreen
                          : AppColors.greyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Save Signature',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

