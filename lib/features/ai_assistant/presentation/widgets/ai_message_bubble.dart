import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../data/models/ai_models.dart';

/// AI Message Bubble Widget
/// 
/// Displays a message in the AI assistant chat.
/// Different styling for user vs AI messages.
class AiMessageBubble extends StatelessWidget {
  final AiChatMessage message;

  const AiMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            // AI Avatar
            Container(
              width: 36.w,
              height: 36.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 20.sp,
                color: AppColors.whiteColor,
              ),
            ),
          ],
          // Message Content
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(message.isUser ? 16.r : 4.r),
                  topRight: Radius.circular(message.isUser ? 4.r : 16.r),
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
                  // Image if present
                  if (message.hasImage) ...[
                    Container(
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 48.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  // Message Text
                  Text(
                    message.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: message.isUser
                          ? AppColors.whiteColor
                          : AppColors.primaryTextColor,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Timestamp
                  Text(
                    _getFormattedTime(),
                    style: AppTextStyles.caption.copyWith(
                      color: message.isUser
                          ? AppColors.whiteColor.withOpacity(0.8)
                          : AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) SizedBox(width: 40.w),
          if (!message.isUser) SizedBox(width: 40.w),
        ],
      ),
    );
  }

  String _getFormattedTime() {
    if (message.createdAt == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(message.createdAt!);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${message.createdAt!.month}/${message.createdAt!.day}';
    }
  }
}



