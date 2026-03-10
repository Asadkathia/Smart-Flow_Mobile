import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import '../../data/models/inventory_item_model.dart';
import '../providers/inventory_provider.dart';
import '../providers/inventory_paginated_provider.dart';
import '../widgets/inventory_item_card.dart';
import 'package:smartflowpro/shared/presentation/widgets/loading_skeleton.dart';
import 'package:smartflowpro/shared/presentation/widgets/conflict_banner.dart';
import 'package:smartflowpro/shared/presentation/widgets/standard_states.dart';
import 'package:smartflowpro/shared/presentation/providers/conflict_provider.dart';

/// Inventory List Screen
/// 
/// Displays all inventory items with search and filter capabilities.
/// Allows navigation to add new items manually or via AI.
class InventoryListScreen extends ConsumerStatefulWidget {
  const InventoryListScreen({super.key});

  @override
  ConsumerState<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends ConsumerState<InventoryListScreen> {
  final searchController = TextEditingController();
  String? selectedCategory;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(inventoryFilterProvider.notifier).state = InventoryFilter(
      searchQuery: query.trim().isEmpty ? null : query.trim(),
      category: selectedCategory,
    );
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      selectedCategory = category;
    });
    ref.read(inventoryFilterProvider.notifier).state = InventoryFilter(
      searchQuery: searchController.text.trim().isEmpty ? null : searchController.text.trim(),
      category: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(inventoryFilterProvider);
    // Create key for paginated provider: "category_isActive"
    final paginationKey = '${filter.category ?? 'all'}_${filter.isActive?.toString() ?? 'all'}';
    final inventoryAsync = ref.watch(paginatedInventoryListProvider(paginationKey));
    final paginatedNotifier = ref.read(paginatedInventoryListProvider(paginationKey).notifier);
    final conflictCount = ref.watch(conflictCountProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Inventory',
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
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: AppColors.whiteColor),
            onSelected: _onCategoryChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Categories')),
              const PopupMenuItem(value: 'HVAC Parts', child: Text('HVAC Parts')),
              const PopupMenuItem(value: 'Plumbing', child: Text('Plumbing')),
              const PopupMenuItem(value: 'Electrical', child: Text('Electrical')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Conflict Banner
          if (conflictCount > 0)
            ConflictBanner(
              message: 'Data conflicts detected',
              conflictCount: conflictCount,
              onResolve: () {
                context.goToConflictResolution();
              },
              onDismiss: () {
                ref.read(conflictStateManagerProvider.notifier).clearConflicts();
              },
            ),
          // Search Bar
          Container(
            padding: EdgeInsets.all(16.w),
            color: AppColors.whiteColor,
            child: TextField(
              controller: searchController,
              onChanged: _onSearch,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryTextColor, // Dark text for readability
              ),
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.greyColor.withOpacity(0.6), // Lighter grey for hint
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.greyColor),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: AppColors.greyColor),
                        onPressed: () {
                          searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.whiteColor, // White background instead of lightGray
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: AppColors.greyColor.withOpacity(0.3), // Subtle border
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: AppColors.greyColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),

          // Category Filter Chip (if selected)
          if (selectedCategory != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              color: AppColors.whiteColor,
              child: Row(
                children: [
                  Chip(
                    label: Text(selectedCategory!),
                    deleteIcon: Icon(Icons.close, size: 18.sp),
                    onDeleted: () => _onCategoryChanged(null),
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  ),
                ],
              ),
            ),

          // Inventory List with FAB overlay
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await paginatedNotifier.refresh();
                  },
                  child: AsyncListBuilder<InventoryItemModel>(
                    value: inventoryAsync,
                    emptyTitle: 'No inventory items found',
                    emptyMessage: 'Add items to get started',
                    emptyIcon: Icons.inventory_2_outlined,
                    errorTitle: 'Unable to load inventory',
                    errorMessage: 'Please check your connection and try again',
                    onRetry: () => paginatedNotifier.refresh(),
                    loading: (context) => ListLoadingSkeleton(
                      itemCount: 5,
                      itemBuilder: (context, index) => const InventoryItemSkeleton(),
                    ),
                    builder: (context, items) {
                      final canLoadMore = paginatedNotifier.canLoadMore;
                      
                      return ListView.builder(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 16.h,
                          bottom: 160.h, // Space for FABs
                        ),
                        itemCount: items.length + (canLoadMore ? 1 : 0),
                        cacheExtent: 500.h,
                        itemBuilder: (context, index) {
                          // Show Load More button at the end
                          if (index == items.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () => paginatedNotifier.loadMore(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: AppColors.whiteColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: Text(
                                    'Load More',
                                    style: AppTextStyles.buttonMedium,
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          return InventoryItemCard(
                            item: items[index],
                            onTap: () {
                              context.goToInventoryDetails(items[index].id);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                // Floating Action Buttons overlay
                Positioned(
                  bottom: 16.h,
                  right: 16.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // AI Detection Button (top)
                      FloatingActionButton.extended(
                        onPressed: () {
                          context.goToAiDetectInventory();
                        },
                        icon: Icon(Icons.camera_alt),
                        label: Text('AI Detect'),
                        backgroundColor: AppColors.primaryColor,
                        heroTag: 'ai_detect',
                      ),
                      SizedBox(height: 12.h),
                      // Manual Entry Button (bottom)
                      FloatingActionButton.extended(
                        onPressed: () {
                          context.goToAddInventoryItem();
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add Item'),
                        backgroundColor: AppColors.primaryTextColor,
                        heroTag: 'manual_add',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

