import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/shared/presentation/widgets/image_picker_widget.dart';
import 'package:smartflowpro/shared/presentation/widgets/primary_button.dart';
import '../../data/models/inventory_item_model.dart';
import '../providers/inventory_provider.dart';
import 'package:smartflowpro/features/auth/presentation/providers/auth_provider.dart';

/// Add Inventory Item Screen
/// 
/// Manual entry screen for adding inventory items with optional AI price suggestion.
class AddInventoryItemScreen extends ConsumerStatefulWidget {
  const AddInventoryItemScreen({super.key});

  @override
  ConsumerState<AddInventoryItemScreen> createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends ConsumerState<AddInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedUnit = 'each';
  String? _selectedCategory;
  File? _selectedImage;
  bool _isLoadingAiPrice = false;
  bool _isSaving = false;
  AiPriceSuggestion? _aiPriceSuggestion;

  final List<String> _units = [
    'each',
    'ft',
    'lb',
    'sq ft',
    'gal',
    'box',
    'roll',
    'pair',
  ];

  final List<String> _categories = [
    'HVAC Parts',
    'Plumbing',
    'Electrical',
    'Hardware',
    'Tools',
    'Safety Equipment',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getAiPriceSuggestion() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a photo first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoadingAiPrice = true;
    });

    try {
      final suggestion = await ref.read(inventoryNotifierProvider.notifier).getAiPriceSuggestion(
        image: _selectedImage!,
        itemName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      );

      setState(() {
        _aiPriceSuggestion = suggestion;
        if (suggestion != null) {
          _priceController.text = suggestion.suggestedPrice.toStringAsFixed(2);
        }
      });

      if (mounted && suggestion != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI suggested price: \$${suggestion.suggestedPrice.toStringAsFixed(2)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get AI price suggestion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingAiPrice = false;
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
        unit: _selectedUnit,
        price: double.parse(_priceController.text.trim()),
        sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        category: _selectedCategory,
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
          'Add Inventory Item',
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
            // Image Picker
            ImagePickerWidget(
              initialImage: _selectedImage,
              onImageSelected: (image) {
                setState(() {
                  _selectedImage = image;
                  _aiPriceSuggestion = null; // Reset AI suggestion when image changes
                });
              },
              label: 'Item Photo',
            ),
            SizedBox(height: 16.h),

            // AI Price Suggestion Button
            if (_selectedImage != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoadingAiPrice ? null : _getAiPriceSuggestion,
                  icon: _isLoadingAiPrice
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                          ),
                        )
                      : Icon(Icons.auto_awesome, color: AppColors.primaryColor),
                  label: Text(
                    _isLoadingAiPrice ? 'Getting AI Suggestion...' : 'Get AI Price Suggestion',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            if (_selectedImage != null) SizedBox(height: 16.h),

            // AI Price Suggestion Info
            if (_aiPriceSuggestion != null)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: AppColors.primaryColor, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'AI Suggestion',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    if (_aiPriceSuggestion!.reasoning != null)
                      Text(
                        _aiPriceSuggestion!.reasoning!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                  ],
                ),
              ),
            if (_aiPriceSuggestion != null) SizedBox(height: 16.h),

            // Item Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name *',
                hintText: 'e.g., HVAC Filter 16x25x1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Item name is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Unit Dropdown
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: InputDecoration(
                labelText: 'Unit *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              items: _units.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value!;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Price
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price *',
                hintText: '0.00',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
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
                labelText: 'SKU (Optional)',
                hintText: 'e.g., ABC-123',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Additional details about the item',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
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
        ),
      ),
    );
  }
}
