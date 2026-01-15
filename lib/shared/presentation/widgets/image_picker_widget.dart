import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Image Picker Widget
/// 
/// Reusable widget for picking images from camera or gallery.
/// Displays selected image with remove/retake functionality.
class ImagePickerWidget extends StatefulWidget {
  final File? initialImage;
  final ValueChanged<File?> onImageSelected;
  final String? label;
  final bool required;

  const ImagePickerWidget({
    super.key,
    this.initialImage,
    required this.onImageSelected,
    this.label,
    this.required = false,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        widget.onImageSelected(_selectedImage);
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: AppTextStyles.heading3,
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primaryColor),
                title: Text('Camera', style: AppTextStyles.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primaryColor),
                title: Text('Gallery', style: AppTextStyles.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.required)
                  Text(
                    ' *',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: _selectedImage == null
              ? InkWell(
                  onTap: _showImageSourceDialog,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48.sp,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Add Photo',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Tap to select from camera or gallery',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Image preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Action buttons overlay
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Row(
                        children: [
                          // Retake button
                          IconButton(
                            onPressed: _showImageSourceDialog,
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Remove button
                          IconButton(
                            onPressed: _removeImage,
                            icon: Icon(Icons.close, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
