import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/shared/presentation/widgets/image_picker_widget.dart';
import 'package:smartflowpro/shared/presentation/widgets/primary_button.dart';
import '../providers/inventory_provider.dart';
import 'package:smartflowpro/features/auth/presentation/providers/auth_provider.dart';

/// AI Detect Inventory Screen
/// 
/// AI-powered auto-detection screen for adding inventory items via image.
class AiDetectInventoryScreen extends ConsumerStatefulWidget {
  const AiDetectInventoryScreen({super.key});

  @override
  ConsumerState<AiDetectInventoryScreen> createState() => _AiDetectInventoryScreenState();
}

class _AiDetectInventoryScreenState extends ConsumerState<AiDetectInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _unitController = TextEditingController();

  File? _selectedImage;
  bool _isDetecting = false;
  bool _isSaving = false;
  bool _hasDetected = false;
  double? _confidence;

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _detectItem() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isDetecting = true;
    });

    try {
      final authState = ref.read(authProvider);
      final orgId = authState.user?.orgId ?? '';

      if (orgId.isEmpty) {
        throw Exception('Organization ID not found');
      }

      // Call AI detection - this returns a complete InventoryItemModel
      final detectedItem = await ref.read(inventoryNotifierProvider.notifier).createItemWithAI(
        image: _selectedImage!,
      );

      if (detectedItem == null) {
        throw Exception('Failed to detect item details');
      }

      // Populate form fields with detected values
      setState(() {
        _nameController.text = detectedItem.name;
        _unitController.text = detectedItem.unit;
        _priceController.text = detectedItem.price.toStringAsFixed(2);
        _skuController.text = detectedItem.sku ?? '';
        _categoryController.text = detectedItem.category ?? '';
        _descriptionController.text = detectedItem.description ?? '';
        _confidence = detectedItem.aiSuggestedPrice != null ? 0.8 : null; // Mock confidence
        _hasDetected = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item detected successfully! Review and save.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI detection failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isDetecting = false;
      });
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final authState = ref.read(authProvider);
      final orgId = authState.user?.orgId ?? '';

      if (orgId.isEmpty) {
        throw Exception('Organization ID not found');
      }

      await ref.read(inventoryNotifierProvider.notifier).createItem(
        name: _nameController.text.trim(),
        unit: _unitController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        image: _selectedImage,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Detect Item',
          style: AppTextStyles.heading3.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryTextColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 22.sp,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Info Banner
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.primaryColor, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Take a photo and let AI detect the item details automatically',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Image Picker
            ImagePickerWidget(
              initialImage: _selectedImage,
              onImageSelected: (image) {
                setState(() {
                  _selectedImage = image;
                  _hasDetected = false; // Reset detection when image changes
                });
              },
              label: 'Item Photo',
              required: true,
            ),
            SizedBox(height: 16.h),

            // Detect Button
            if (_selectedImage != null && !_hasDetected)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isDetecting ? null : _detectItem,
                  icon: _isDetecting
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.search, color: Colors.white),
                  label: Text(
                    _isDetecting ? 'Detecting...' : 'Detect Item with AI',
                    style: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
              ),
            if (_selectedImage != null && !_hasDetected) SizedBox(height: 24.h),

            // Detected Fields (shown after detection)
            if (_hasDetected) ...[
              // Confidence Indicator
              if (_confidence != null)
                Container(
                  padding: EdgeInsets.all(12.w),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: _confidence! > 0.7
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: _confidence! > 0.7
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _confidence! > 0.7 ? Icons.check_circle : Icons.info,
                        color: _confidence! > 0.7 ? Colors.green : Colors.orange,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Detection Confidence: ${(_confidence! * 100).toInt()}%',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _confidence! > 0.7 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

              Text(
                'Review & Edit Detected Details',
                style: AppTextStyles.heading3,
              ),
              SizedBox(height: 16.h),

              // Item Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  suffixIcon: Icon(Icons.edit, color: AppColors.greyColor),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Item name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Unit
              TextFormField(
                controller: _unitController,
                decoration: InputDecoration(
                  labelText: 'Unit *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  suffixIcon: Icon(Icons.edit, color: AppColors.greyColor),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Unit is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price *',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  suffixIcon: Icon(Icons.edit, color: AppColors.greyColor),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null || price < 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // SKU
              TextFormField(
                controller: _skuController,
                decoration: InputDecoration(
                  labelText: 'SKU',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  suffixIcon: Icon(Icons.edit, color: AppColors.greyColor),
                ),
              ),
              SizedBox(height: 16.h),

              // Category
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  suffixIcon: Icon(Icons.edit, color: AppColors.greyColor),
                ),
              ),
              SizedBox(height: 16.h),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  suffixIcon: Icon(Icons.edit, color: AppColors.greyColor),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24.h),

              // Save Button
              PrimaryButton(
                text: 'Save Item',
                onPressed: _isSaving ? null : _saveItem,
                isLoading: _isSaving,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
