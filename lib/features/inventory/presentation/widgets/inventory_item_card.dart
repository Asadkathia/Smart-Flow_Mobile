import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../data/models/inventory_item_model.dart';

/// Inventory Item Card Widget
/// 
/// Displays an inventory item in a card format.
/// Shows item name, SKU, price, unit, and category.
class InventoryItemCard extends StatelessWidget {
  final InventoryItemModel item;
  final VoidCallback? onTap;

  const InventoryItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Item Image or Icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: item.imageUrl != null && _isValidImageUrl(item.imageUrl!)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: _getFullImageUrl(item.imageUrl!),
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.lightGray,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              color: AppColors.lightGray,
                              child: Center(
                                child: Container(
                                  width: 30.sp,
                                  height: 30.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.greyColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        color: AppColors.lightGray,
                        child: Center(
                          child: Container(
                            width: 30.sp,
                            height: 30.sp,
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 16.w),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isAiDetected)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 12.sp,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'AI',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    if (item.sku != null)
                      Text(
                        'SKU: ${item.sku}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        Text(
                          ' / ${item.unit}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                        if (item.category != null) ...[
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(item.category!).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              item.category!,
                              style: AppTextStyles.caption.copyWith(
                                color: _getCategoryColor(item.category!),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Status Indicator
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: item.isActive ? AppColors.successGreen : AppColors.greyColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL', 
      defaultValue: 'https://pbqbsdmwbjpsvxuuwjiv.supabase.co');
    return '$supabaseUrl/storage/v1/object/public/inventory/$cleanPath';
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'hvac parts':
        return AppColors.primaryColor;
      case 'plumbing':
        return Colors.blue;
      case 'electrical':
        return Colors.orange;
      default:
        return AppColors.greyColor;
    }
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
}

