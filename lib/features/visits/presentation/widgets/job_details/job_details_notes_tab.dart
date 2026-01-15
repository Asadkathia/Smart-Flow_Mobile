import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/shared/data/services/media_service.dart';
import '../../providers/job_details_provider.dart';
import '../../providers/visits_provider.dart' as visits_provider;
import '../../../data/models/note_model.dart';

/// Notes Tab for Job Details Screen
/// 
/// Displays notes for the selected visit and allows adding new notes.
/// Uses Riverpod providers for state management.
class JobDetailsNotesTab extends ConsumerWidget {
  const JobDetailsNotesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitId = ref.watch(selectedVisitIdProvider);
    
    // Fallback: use first visit from today's visits if no visitId
    final todayVisits = ref.watch(visits_provider.todayVisitsProvider).value;
    final effectiveVisitId = visitId ?? (todayVisits?.isNotEmpty == true ? todayVisits!.first.id : null);
    
    if (effectiveVisitId == null) {
      return Center(
        child: Text(
          'No visit selected',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyColor),
        ),
      );
    }

    final notesAsync = ref.watch(visits_provider.visitNotesProvider(effectiveVisitId));
    
    return Column(
      children: [
        Row(
          children: [
            // Add Note container button
            Expanded(
              child: GestureDetector(
                onTap: () => _showAddNoteDialog(context, ref, effectiveVisitId),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.greyColor.withAlpha(70),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Add Note',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Camera icon container button
            GestureDetector(
              onTap: () => _showCameraOptions(context, ref, effectiveVisitId),
              child: Container(
                height: 56.h,
                width: 56.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColor.withAlpha(70)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.green,
                  size: 28.w,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        // Notes list - Using Flexible instead of Expanded to work with SingleChildScrollView
        notesAsync.when(
          data: (notes) {
            if (notes.isEmpty) {
              return SizedBox(
                height: 300.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add_outlined,
                        size: 64.sp,
                        color: AppColors.greyColor,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No notes yet',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap "Add Note" to create your first note',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: notes.length,
              separatorBuilder: (_, __) => SizedBox(height: 18.h),
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildNoteCard(context, note);
              },
            );
          },
          loading: () => SizedBox(
            height: 200.h,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => SizedBox(
            height: 200.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: AppColors.errorRed,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading notes',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(visits_provider.visitNotesProvider(effectiveVisitId));
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildNoteCard(BuildContext context, NoteModel note) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Note content
          Text(
            note.content,
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          // Note metadata
          Row(
            children: [
              Text(
                note.formattedDate,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
          // Note: Image URLs removed per PRD - images are stored separately in visit_media
          // Image display functionality to be implemented via visit_media table
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref, String visitId) {
    final textController = TextEditingController();
    bool isInternal = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter note content...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                autofocus: true,
              ),
              SizedBox(height: 16.h),
              CheckboxListTile(
                title: Text('Internal Note'),
                subtitle: Text('Only visible to technicians'),
                value: isInternal,
                onChanged: (value) {
                  setState(() {
                    isInternal = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (textController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter note content')),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                
                // Show loading
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 16.w),
                        Text('Adding note...'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Add note
                await ref.read(visits_provider.visitNotesProvider(visitId).notifier).addNote(
                  visitId,
                  textController.text.trim(),
                  isInternal: isInternal,
                );

                // Show success
                scaffoldMessenger.hideCurrentSnackBar();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Note added successfully'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCameraOptions(BuildContext context, WidgetRef ref, String visitId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _handleCameraCapture(context, ref, visitId);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _handleGalleryPick(context, ref, visitId);
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCameraCapture(BuildContext context, WidgetRef ref, String visitId) async {
    try {
      final mediaService = ref.read(mediaServiceProvider);
      final XFile? image = await mediaService.pickImageFromCamera();
      
      if (image != null) {
        // Show dialog to add note with image
        _showAddNoteWithImageDialog(context, ref, visitId, image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture image: ${e.toString()}'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _handleGalleryPick(BuildContext context, WidgetRef ref, String visitId) async {
    try {
      final mediaService = ref.read(mediaServiceProvider);
      final XFile? image = await mediaService.pickImageFromGallery();
      
      if (image != null) {
        // Show dialog to add note with image
        _showAddNoteWithImageDialog(context, ref, visitId, image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  void _showAddNoteWithImageDialog(BuildContext context, WidgetRef ref, String visitId, String imagePath) {
    final textController = TextEditingController();
    bool isInternal = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Note with Image'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    File(imagePath),
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Enter note content...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  autofocus: true,
                ),
                SizedBox(height: 16.h),
                CheckboxListTile(
                  title: Text('Internal Note'),
                  subtitle: Text('Only visible to technicians'),
                  value: isInternal,
                  onChanged: (value) {
                    setState(() {
                      isInternal = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                
                // Show loading
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 16.w),
                        Text('Adding note with image...'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Add note with image
                // Convert path to File and pass to repository for upload
                final imageFile = File(imagePath);
                await ref.read(visits_provider.visitNotesProvider(visitId).notifier).addNote(
                  visitId,
                  textController.text.trim().isEmpty 
                      ? 'Image attached' 
                      : textController.text.trim(),
                  isInternal: isInternal,
                  imageFiles: [imageFile], // Pass File object for upload
                );

                // Show success
                scaffoldMessenger.hideCurrentSnackBar();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Note with image added successfully'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageFullScreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
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
    );
  }
}

