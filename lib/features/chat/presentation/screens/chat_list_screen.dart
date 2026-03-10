import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import '../../data/models/chat_models.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_paginated_provider.dart';
import '../widgets/chat_thread_card.dart';
import 'package:smartflowpro/shared/presentation/widgets/loading_skeleton.dart';

/// Chat List Screen
/// 
/// Displays all chat threads (direct and group chats).
/// Allows navigation to individual chat threads.
class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final searchController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatThreadsAsync = ref.watch(paginatedChatThreadsListProvider);
    final paginatedNotifier = ref.read(paginatedChatThreadsListProvider.notifier);
    final currentUserId = ref.watch(currentUserIdProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Chat',
          style: AppTextStyles.heading3.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryTextColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.whiteColor),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: AppColors.whiteColor),
            onPressed: () {
              _showNewChatDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (isSearching)
            Container(
              padding: EdgeInsets.all(16.w),
              color: AppColors.whiteColor,
              child: TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  prefixIcon: Icon(Icons.search, color: AppColors.greyColor),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: AppColors.greyColor),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.lightGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),

          // Chat List
          Expanded(
            child: chatThreadsAsync.when(
              data: (threads) {
                if (threads.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80.sp,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No chats yet',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Start a conversation with your team',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.greyColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final canLoadMore = paginatedNotifier.canLoadMore;
                
                return RefreshIndicator(
                  onRefresh: () async {
                    await paginatedNotifier.refresh();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: threads.length + (canLoadMore ? 1 : 0),
                    itemExtent: null, // Remove fixed height to allow Load More button
                    cacheExtent: 500.h,
                    itemBuilder: (context, index) {
                      // Show Load More button at the end
                      if (index == threads.length) {
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
                      
                      return ChatThreadCard(
                        thread: threads[index],
                        currentUserId: currentUserId,
                        onTap: () {
                          // Navigate to chat thread screen
                          context.goToChatThread(
                            threads[index].id,
                            threads[index].getDisplayName(currentUserId),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => ListLoadingSkeleton(
                itemCount: 5,
                itemBuilder: (context, index) => const ChatThreadSkeleton(),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60.sp,
                        color: AppColors.errorRed,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Unable to load chats',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.errorRed,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Please check your connection and try again',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.secondaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          paginatedNotifier.refresh();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewChatDialog() {
    context.showSnackBar('Create new chat functionality will be available soon');
  }
}

