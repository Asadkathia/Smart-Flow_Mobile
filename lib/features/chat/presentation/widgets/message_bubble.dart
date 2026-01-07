import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/chat_models.dart';

/// Message Bubble Widget
/// 
/// Displays a single message in a chat thread.
/// Supports different styling for current user vs other users.
class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isCurrentUser;
  final bool showSenderName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.showSenderName = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            // Avatar for other users
            Container(
              width: 32.w,
              height: 32.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 18.sp,
                color: AppColors.greyColor,
              ),
            ),
          ],
          // Message Content
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender Name (for non-current users)
                if (showSenderName && message.senderName != null) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
                    child: Text(
                      message.senderName!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                // Message Bubble
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? AppColors.primaryColor
                        : AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isCurrentUser ? 16.r : 4.r),
                      topRight: Radius.circular(isCurrentUser ? 4.r : 16.r),
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkGrey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.messageBody,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isCurrentUser
                              ? AppColors.whiteColor
                              : AppColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.getFormattedTime(),
                            style: AppTextStyles.caption.copyWith(
                              color: isCurrentUser
                                  ? AppColors.whiteColor.withOpacity(0.8)
                                  : AppColors.secondaryTextColor,
                            ),
                          ),
                          // Message Status (only for current user)
                          if (isCurrentUser) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              message.getStatusIcon(),
                              size: 12.sp,
                              color: message.getStatusColor(),
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
          if (isCurrentUser) SizedBox(width: 40.w), // Spacing for alignment
          if (!isCurrentUser) SizedBox(width: 40.w), // Spacing for alignment
        ],
      ),
    );
  }
}


