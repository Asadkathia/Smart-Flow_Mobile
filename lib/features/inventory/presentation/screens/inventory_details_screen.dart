import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import '../../data/models/inventory_item_model.dart';
import '../providers/inventory_provider.dart';
import '../widgets/inventory_item_card.dart';
import 'package:smartflowpro/shared/presentation/widgets/standard_states.dart';
import 'package:smartflowpro/shared/presentation/widgets/media_gallery_widget.dart';

/// Inventory Details Screen
/// 
/// Displays inventory item details with edit and delete functionality.
class InventoryDetailsScreen extends ConsumerStatefulWidget {
  final String itemId;

  const InventoryDetailsScreen({
    super.key,
    required this.itemId,
  });

  @override
  ConsumerState<InventoryDetailsScreen> createState() => _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState extends ConsumerState<InventoryDetailsScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late TextEditingController _priceController;
  late TextEditingController _skuController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _unitController = TextEditingController();
    _priceController = TextEditingController();
    _skuController = TextEditingController();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeFields(InventoryItemModel item) {
    _nameController.text = item.name;
    _unitController.text = item.unit;
    _priceController.text = item.price.toStringAsFixed(2);
    _skuController.text = item.sku ?? '';
    _categoryController.text = item.category ?? '';
    _descriptionController.text = item.description ?? '';
    _isActive = item.isActive;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(inventoryNotifierProvider.notifier).updateItem(
      id: widget.itemId,
      name: _nameController.text.trim(),
      unit: _unitController.text.trim(),
      price: double.tryParse(_priceController.text.trim()),
      sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      isActive: _isActive,
    );

    if (success && mounted) {
      setState(() => _isEditing = false);
      context.showSuccessSnackBar('Item updated successfully');
    } else if (mounted) {
      context.showErrorSnackBar('Failed to update item');
    }
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: AppColors.whiteColor,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref.read(inventoryNotifierProvider.notifier).deleteItem(widget.itemId);
      if (success && mounted) {
        context.showSuccessSnackBar('Item deleted successfully');
        context.pop();
      } else if (mounted) {
        context.showErrorSnackBar('Failed to delete item');
      }
    }
  }

  /// Convert storage path to full Supabase Storage URL
  String _getFullImageUrl(String imagePath) {
    // If already a full URL, return as-is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    
    // Fix for existing data: strip duplicate /inventory/ from old paths
    // Old format: orgId/inventory/itemId/filename
    // New format: orgId/itemId/filename  
    String cleanPath = imagePath;
    
    // Handle cases where path starts with inventory/ (e.g. migration artifact)
    if (cleanPath.startsWith('inventory/')) {
      cleanPath = cleanPath.substring('inventory/'.length);
    }
    
    final regex = RegExp(r'^([^/]+)/inventory/(.+)$');
    final match = regex.firstMatch(imagePath);
    if (match != null) {
      // Convert old format to new: strip the /inventory/ part
      cleanPath = '${match.group(1)}/${match.group(2)}';
    }
    
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://pbqbsdmwbjpsvxuuwjiv.supabase.co');
    return '$supabaseUrl/storage/v1/object/public/inventory/$cleanPath';
  }

  /// Validate that the image URL/path is valid before loading
  bool _isValidImageUrl(String imagePath) {
    // Don't load if path is empty or whitespace only
    if (imagePath.trim().isEmpty) return false;
    
    // Don't load if path is the string "null" (database artifact)
    if (imagePath.trim().toLowerCase() == 'null') return false;
    
    // Don't load if path looks like a placeholder or invalid UUID
    if (imagePath.contains('00000000-0000-0000-0000-000000000000')) return false;
    
    // Basic validation - must have at least one slash (path structure)
    if (!imagePath.contains('/')) return false;
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(inventoryItemProvider(widget.itemId));
    final actionsState = ref.watch(inventoryNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Item' : 'Item Details',
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
          iconSize: 22.sp,
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.whiteColor),
              onPressed: () {
                itemAsync.whenData((item) {
                  _initializeFields(item);
                  setState(() => _isEditing = true);
                });
              },
            ),
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.delete, color: AppColors.errorRed),
              onPressed: _deleteItem,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.check, color: AppColors.whiteColor),
              onPressed: actionsState.isLoading ? null : _saveChanges,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.close, color: AppColors.whiteColor),
              onPressed: () {
                setState(() => _isEditing = false);
              },
            ),
        ],
      ),
      body: itemAsync.when(
        data: (item) {
          if (_isEditing && _nameController.text.isEmpty) {
            _initializeFields(item);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Image
                  if (item.imageUrl != null && _isValidImageUrl(item.imageUrl!))
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      margin: EdgeInsets.only(bottom: 24.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.lightGray,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: _getFullImageUrl(item.imageUrl!),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.inventory_2_outlined,
                            size: 60.sp,
                            color: AppColors.greyColor,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),

                  // Item Name
                  TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.label),
                    ),
                    style: AppTextStyles.bodyLarge,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Price and Unit Row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Price is required';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Invalid price';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextFormField(
                          controller: _unitController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            prefixIcon: Icon(Icons.straighten),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Unit is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // SKU
                  TextFormField(
                    controller: _skuController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'SKU (Optional)',
                      prefixIcon: Icon(Icons.qr_code),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Category
                  TextFormField(
                    controller: _categoryController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Category (Optional)',
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    enabled: _isEditing,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                      prefixIcon: Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Status Toggle
                  if (_isEditing)
                    SwitchListTile(
                      title: Text('Active'),
                      subtitle: Text('Inactive items won\'t appear in quotes'),
                      value: _isActive,
                      onChanged: (value) => setState(() => _isActive = value),
                    ),

                  // Info Section (when not editing)
                  if (!_isEditing) ...[
                    Divider(),
                    SizedBox(height: 16.h),
                    _buildInfoRow('Status', item.isActive ? 'Active' : 'Inactive',
                        item.isActive ? AppColors.successGreen : AppColors.greyColor),
                    if (item.isAiDetected)
                      _buildInfoRow('Detection', 'AI Detected', AppColors.primaryColor),
                    if (item.createdAt != null)
                      _buildInfoRow('Created', _formatDate(item.createdAt!), null),
                    if (item.updatedAt != null)
                      _buildInfoRow('Updated', _formatDate(item.updatedAt!), null),
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => StandardLoadingState(message: 'Loading item details...'),
        error: (error, stack) => StandardErrorState(
          title: 'Failed to load item',
          message: 'Please try again',
          onRetry: () => ref.invalidate(inventoryItemProvider(widget.itemId)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: valueColor ?? AppColors.primaryTextColor,
                fontWeight: valueColor != null ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}


