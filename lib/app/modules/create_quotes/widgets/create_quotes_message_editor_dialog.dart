import '../../../export/exports.dart';

class CreateQuotesMessageEditorDialog extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const CreateQuotesMessageEditorDialog({
    super.key,
    required this.messageController,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Estimate Message',
        style: AppTextStyles.heading4.copyWith(color: AppColors.blackColor),
      ),
      content: TextField(
        controller: messageController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Enter your estimate message...',
          hintStyle: AppTextStyles.textFieldHint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.skyAqua),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonMedium.copyWith(color: AppColors.neutralDarkGray),
          ),
        ),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.skyAqua,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Save',
            style: AppTextStyles.buttonMedium,
          ),
        ),
      ],
    );
  }
}
