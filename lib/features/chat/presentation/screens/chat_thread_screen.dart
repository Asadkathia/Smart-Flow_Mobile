import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../data/models/chat_models.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_realtime_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

/// Chat Thread Screen
/// 
/// Displays messages in a chat thread and allows sending new messages.
class ChatThreadScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String chatName;

  const ChatThreadScreen({
    super.key,
    required this.chatId,
    required this.chatName,
  });

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark chat as read when opened
    Future.delayed(Duration.zero, () {
      ref.read(chatActionsProvider.notifier).markAsRead(widget.chatId);
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final currentUserId = ref.watch(currentUserIdProvider);
    final actionsState = ref.watch(chatActionsProvider);
    final typingState = ref.watch(chatTypingProvider(widget.chatId));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.chatName,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryTextColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.whiteColor),
            onPressed: () {
              // TODO: Show chat info
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60.sp,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No messages yet',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Start the conversation',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.greyColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  reverse: true,
                  itemCount: messages.length + (typingState.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show typing indicator at the bottom (index 0 when reversed)
                    if (index == 0 && typingState.isNotEmpty) {
                      return TypingIndicator(
                        userName: typingState.typingUserIds.first,
                      );
                    }

                    // Adjust message index if typing indicator is shown
                    final messageIndex = typingState.isNotEmpty ? index - 1 : index;
                    final message = messages[messages.length - 1 - messageIndex];
                    final isCurrentUser = message.isFromCurrentUser(currentUserId);
                    
                    // Show sender name for group chats and non-current user messages
                    final showSenderName = !isCurrentUser;

                    return MessageBubble(
                      message: message,
                      isCurrentUser: isCurrentUser,
                      showSenderName: showSenderName,
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
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
                      'Error loading messages',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Message Input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGrey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (text) {
                        // Show typing indicator when user types
                        if (text.isNotEmpty) {
                          ref.read(chatTypingProvider(widget.chatId).notifier)
                              .setTyping(currentUserId);
                        } else {
                          ref.read(chatTypingProvider(widget.chatId).notifier)
                              .clearTyping(currentUserId);
                        }
                      },
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTextColor, // Dark text for readability
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.greyColor.withOpacity(0.6), // Lighter grey for hint
                        ),
                        filled: true,
                        fillColor: AppColors.whiteColor, // White background instead of lightGray
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(
                            color: AppColors.greyColor.withOpacity(0.3), // Subtle border
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(
                            color: AppColors.greyColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  actionsState.isLoading
                      ? SizedBox(
                          width: 48.w,
                          height: 48.w,
                          child: Center(
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: AppColors.primaryColor,
                          ),
                          iconSize: 28.sp,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 48.w,
                            minHeight: 48.w,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final messageBody = messageController.text.trim();
    if (messageBody.isEmpty) return;

    // Clear input immediately
    messageController.clear();

    // Send message
    final message = await ref.read(chatActionsProvider.notifier).sendMessage(
      chatId: widget.chatId,
      messageBody: messageBody,
    );

    if (message != null) {
      // Scroll to bottom
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }
}

