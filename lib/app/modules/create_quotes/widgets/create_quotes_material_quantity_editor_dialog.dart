import '../../../export/exports.dart';
import '../models/material_line.dart';

class CreateQuotesMaterialQuantityEditorDialog extends StatefulWidget {
  final MaterialLine line;
  final Function(int delta) onUpdate;

  const CreateQuotesMaterialQuantityEditorDialog({
    super.key,
    required this.line,
    required this.onUpdate,
  });

  @override
  State<CreateQuotesMaterialQuantityEditorDialog> createState() =>
      _CreateQuotesMaterialQuantityEditorDialogState();
}

class _CreateQuotesMaterialQuantityEditorDialogState
    extends State<CreateQuotesMaterialQuantityEditorDialog> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.line.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.line.material.name,
            style: AppTextStyles.heading4.copyWith(
              fontSize: 18.sp,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Adjust Quantity',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.neutralDarkGray,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (_currentQuantity > 1) {
                    setState(() {
                      _currentQuantity--;
                    });
                    widget.onUpdate(-1);
                  }
                },
                icon: const Icon(Icons.remove_circle),
                iconSize: 32.sp,
              ),
              SizedBox(width: 24.w),
              Text(
                '$_currentQuantity',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 24.sp,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(width: 24.w),
              IconButton(
                onPressed: () {
                  if (_currentQuantity < 999) {
                    setState(() {
                      _currentQuantity++;
                    });
                    widget.onUpdate(1);
                  }
                },
                icon: const Icon(Icons.add_circle),
                iconSize: 32.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: AppColors.skyAqua,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Done',
              style: AppTextStyles.buttonMedium,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
