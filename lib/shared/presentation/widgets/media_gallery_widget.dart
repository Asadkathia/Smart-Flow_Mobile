import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Media Gallery Widget
/// 
/// Displays multiple images in a gallery format with preview and deletion support.
/// Supports both network images (via URL) and local files.
class MediaGalleryWidget extends StatelessWidget {
  final List<String> imageUrls;
  final bool showDeleteButton;
  final Function(String imageUrl)? onDelete;
  final Function(String imageUrl)? onImageTap;
  final double? itemHeight;
  final double? itemWidth;
  final Axis scrollDirection;

  const MediaGalleryWidget({
    super.key,
    required this.imageUrls,
    this.showDeleteButton = false,
    this.onDelete,
    this.onImageTap,
    this.itemHeight,
    this.itemWidth,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: scrollDirection == Axis.horizontal ? (itemHeight ?? 80.h) : null,
      width: scrollDirection == Axis.vertical ? (itemWidth ?? double.infinity) : null,
      child: ListView.separated(
        scrollDirection: scrollDirection,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => SizedBox(
          width: scrollDirection == Axis.horizontal ? 10.w : 0,
          height: scrollDirection == Axis.vertical ? 10.h : 0,
        ),
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          return _MediaGalleryItem(
            imageUrl: imageUrl,
            showDeleteButton: showDeleteButton,
            onDelete: onDelete != null ? () => onDelete!(imageUrl) : null,
            onTap: onImageTap != null ? () => onImageTap!(imageUrl) : () => _showImageFullScreen(context, imageUrl),
            height: itemHeight ?? 80.h,
            width: itemWidth ?? 80.w,
          );
        },
      ),
    );
  }

  void _showImageFullScreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              color: Colors.black54,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black54,
                              child: Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                  size: 48.sp,
                                ),
                              ),
                            ),
                          )
                        : Image.file(
                            File(imageUrl),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40.h,
              right: 16.w,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28.sp,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Media Gallery Item
/// 
/// Individual image item in the gallery with delete button support.
class _MediaGalleryItem extends StatelessWidget {
  final String imageUrl;
  final bool showDeleteButton;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final double height;
  final double width;

  const _MediaGalleryItem({
    required this.imageUrl,
    required this.showDeleteButton,
    this.onDelete,
    this.onTap,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: imageUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: width,
                      height: height,
                      color: AppColors.greyColor.withOpacity(0.2),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: width,
                      height: height,
                      color: AppColors.greyColor.withOpacity(0.2),
                      child: Icon(
                        Icons.error,
                        color: AppColors.errorRed,
                        size: 24.sp,
                      ),
                    ),
                  )
                : Image.file(
                    File(imageUrl),
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
          ),
          if (showDeleteButton && onDelete != null)
            Positioned(
              top: -8.h,
              right: -8.w,
              child: GestureDetector(
                onTap: () {
                  _showDeleteConfirmation(context);
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.whiteColor,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Image'),
        content: Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: AppColors.whiteColor,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Media Gallery with Upload Progress
/// 
/// Extended version that shows upload progress for pending uploads.
class MediaGalleryWithProgress extends StatelessWidget {
  final List<MediaItem> mediaItems;
  final Function(String imageUrl)? onDelete;
  final Function(String imageUrl)? onImageTap;
  final double? itemHeight;
  final double? itemWidth;

  const MediaGalleryWithProgress({
    super.key,
    required this.mediaItems,
    this.onDelete,
    this.onImageTap,
    this.itemHeight,
    this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: itemHeight ?? 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaItems.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = mediaItems[index];
          return _MediaGalleryItemWithProgress(
            mediaItem: item,
            onDelete: onDelete != null ? () => onDelete!(item.url) : null,
            onTap: onImageTap != null ? () => onImageTap!(item.url) : null,
            height: itemHeight ?? 80.h,
            width: itemWidth ?? 80.w,
          );
        },
      ),
    );
  }
}

/// Media Item Model
class MediaItem {
  final String url;
  final double? uploadProgress; // 0.0 to 1.0, null if uploaded
  final bool isUploading;
  final String? error;

  const MediaItem({
    required this.url,
    this.uploadProgress,
    this.isUploading = false,
    this.error,
  });
}

/// Media Gallery Item with Progress
class _MediaGalleryItemWithProgress extends StatelessWidget {
  final MediaItem mediaItem;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final double height;
  final double width;

  const _MediaGalleryItemWithProgress({
    required this.mediaItem,
    this.onDelete,
    this.onTap,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: width,
            height: height,
            color: AppColors.greyColor.withOpacity(0.2),
            child: mediaItem.url.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: mediaItem.url,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildPlaceholder(),
                    errorWidget: (context, url, error) => _buildErrorWidget(),
                  )
                : Image.file(
                    File(mediaItem.url),
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // Upload progress overlay
        if (mediaItem.isUploading && mediaItem.uploadProgress != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: mediaItem.uploadProgress,
                      strokeWidth: 3,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${(mediaItem.uploadProgress! * 100).toInt()}%',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Error overlay
        if (mediaItem.error != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.whiteColor,
                      size: 24.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Upload Failed',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Delete button
        if (onDelete != null && !mediaItem.isUploading)
          Positioned(
            top: -8.h,
            right: -8.w,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.errorRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                  size: 16.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Icon(
        Icons.error,
        color: AppColors.errorRed,
        size: 24.sp,
      ),
    );
  }
}



