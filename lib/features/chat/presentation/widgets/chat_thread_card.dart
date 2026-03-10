import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../data/models/chat_models.dart';

/// Chat Thread Card Widget
/// 
/// Displays a chat thread in the list.
/// Shows chat name, last message, time, and unread count.
class ChatThreadCard extends StatelessWidget {
  final ChatThreadModel thread;
  final String currentUserId;
  final VoidCallback? onTap;

  const ChatThreadCard({
    super.key,
    required this.thread,
    required this.currentUserId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: thread.unreadCount > 0
              ? AppColors.primaryColor.withOpacity(0.05)
              : AppColors.whiteColor,
          border: Border(
            bottom: BorderSide(
              color: AppColors.lightGray,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            SizedBox(width: 12.w),

            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          thread.getDisplayName(currentUserId),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: thread.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _getFormattedTime(),
                        style: AppTextStyles.caption.copyWith(
                          color: thread.unreadCount > 0
                              ? AppColors.primaryColor
                              : AppColors.greyColor,
                          fontWeight: thread.unreadCount > 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.lastMessage?.messageBody ?? 'No messages yet',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: thread.unreadCount > 0
                                ? AppColors.primaryTextColor
                                : AppColors.secondaryTextColor,
                            fontWeight: thread.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (thread.unreadCount > 0) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            thread.unreadCount.toString(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: thread.type == ChatType.group
            ? AppColors.primaryColor.withOpacity(0.2)
            : AppColors.greyColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        thread.type == ChatType.group
            ? Icons.group
            : Icons.person,
        color: thread.type == ChatType.group
            ? AppColors.primaryColor
            : AppColors.greyColor,
        size: 24.sp,
      ),
    );
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    final diff = now.difference(thread.updatedAt);

    if (diff.inMinutes < 1) {
      return 'Now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return DateFormat('MMM d').format(thread.updatedAt);
    }
  }
}



